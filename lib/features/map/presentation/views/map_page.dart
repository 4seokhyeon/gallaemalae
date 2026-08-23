import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DayPeriod;
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/config/app_env.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/geo_point.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/features/map/presentation/view_models/map_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

const _brand = Color(0xFFC93A06);
const _brandDark = Color(0xFFB93403);
const _ink = Color(0xFF332B2A);
const _muted = Color(0xFF746B69);

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  NaverMapController? _mapController;
  GoRouter? _router;
  bool _wasMapRouteActive = false;
  bool _locationRequestInProgress = false;
  int _locationRequestGeneration = 0;
  final Map<String, NOverlayImage> _crowdMarkerIcons = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (identical(_router, router)) return;

    _router?.routerDelegate.removeListener(_handleRouteChange);
    _router = router;
    router.routerDelegate.addListener(_handleRouteChange);
    _handleRouteChange();
  }

  @override
  void dispose() {
    _stopMapLocationTracking();
    _router?.routerDelegate.removeListener(_handleRouteChange);
    super.dispose();
  }

  void _handleRouteChange() {
    final path = _router?.routerDelegate.currentConfiguration.uri.path;
    final isMapRouteActive = path == AppRoutes.map;

    if (!isMapRouteActive && _wasMapRouteActive) {
      // 네이티브 PlatformView가 제거되기 전에 heading/location 구독을
      // 먼저 중단해야 overlay 채널로 늦은 이벤트가 전달되지 않습니다.
      _stopMapLocationTracking();
    }
    if (isMapRouteActive && !_wasMapRouteActive && _mapController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _moveToCurrentLocation();
      });
    }
    _wasMapRouteActive = isMapRouteActive;
  }

  Future<void> _moveToCurrentLocation() async {
    final controller = _mapController;
    if (controller == null || _locationRequestInProgress) return;

    final requestGeneration = ++_locationRequestGeneration;
    _locationRequestInProgress = true;
    ref.read(mapViewModelProvider.notifier).setLocating(true);

    final status = await Permission.locationWhenInUse.request();
    if (!_isMapControllerActive(controller, requestGeneration)) return;

    if (status.isGranted) {
      final repository = ref.read(locationRepositoryProvider);
      try {
        if (!await repository.isServiceEnabled() ||
            !_isMapControllerActive(controller, requestGeneration)) {
          return;
        }

        final cachedPosition = await repository.getLastKnownPosition();
        if (!_isMapControllerActive(controller, requestGeneration)) return;
        if (cachedPosition != null) {
          await _updateCamera(controller, cachedPosition, animated: false);
        }

        final currentPosition = await repository.getCurrentPosition();
        if (!_isMapControllerActive(controller, requestGeneration)) return;
        await _updateCamera(controller, currentPosition, animated: true);
      } catch (error, stackTrace) {
        // GPS 시간 초과 시 마지막 위치 또는 현재 지도 위치를 유지합니다.
        debugPrint('현재 위치 조회 실패: $error');
        debugPrintStack(stackTrace: stackTrace);
      } finally {
        if (_locationRequestGeneration == requestGeneration) {
          _locationRequestInProgress = false;
        }
        if (mounted && _locationRequestGeneration == requestGeneration) {
          ref.read(mapViewModelProvider.notifier).setLocating(false);
        }
      }
      return;
    }

    _locationRequestInProgress = false;
    ref.read(mapViewModelProvider.notifier).setLocating(false);
    if (!mounted) return;
    await showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('위치 권한이 필요합니다'),
        content: const Text('현재 위치 주변의 축제와 혼잡도를 표시하려면 위치 권한을 허용해 주세요.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          if (status.isPermanentlyDenied)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('설정 열기'),
            ),
        ],
      ),
    );
  }

  bool _isMapControllerActive(
    NaverMapController controller,
    int requestGeneration,
  ) {
    return mounted &&
        identical(_mapController, controller) &&
        _locationRequestGeneration == requestGeneration;
  }

  void _stopMapLocationTracking() {
    _locationRequestGeneration++;
    _locationRequestInProgress = false;
    _mapController = null;
  }

  Future<void> _updateCamera(
    NaverMapController controller,
    GeoPoint point, {
    required bool animated,
  }) {
    final update = NCameraUpdate.scrollAndZoomTo(
      target: NLatLng(point.latitude, point.longitude),
      zoom: 14,
    );
    if (animated) {
      update.setAnimation(
        animation: NCameraAnimation.easing,
        duration: const Duration(milliseconds: 700),
      );
    }
    return controller.updateCamera(update).then((_) {});
  }

  void _handleMapReady(NaverMapController controller) {
    _mapController = controller;
    unawaited(
      _syncFestivalMarkers(
        controller,
        ref.read(mapViewModelProvider).visibleFestivals,
      ),
    );
    if (_wasMapRouteActive) _moveToCurrentLocation();
  }

  Future<void> _syncFestivalMarkers(
    NaverMapController controller,
    List<FestivalSummary> festivals,
  ) async {
    if (!identical(_mapController, controller)) return;
    try {
      await controller.clearOverlays(type: NOverlayType.marker);
      if (!identical(_mapController, controller)) return;
      final analyses = ref.read(mapViewModelProvider).analyses;
      final markers = <NMarker>{};
      for (final festival in festivals.where(
        (festival) =>
            festival.latitude >= -90 &&
            festival.latitude <= 90 &&
            festival.longitude >= -180 &&
            festival.longitude <= 180,
      )) {
        final analysis = analyses[festival.id];
        final icon = analysis == null ? null : await _crowdMarkerIcon(analysis);
        if (!identical(_mapController, controller)) return;
        final marker =
            NMarker(
              id: 'festival_${festival.id}',
              position: NLatLng(festival.latitude, festival.longitude),
              icon: icon,
              size: icon == null ? NMarker.autoSize : const Size(48, 54),
              iconTintColor: icon == null
                  ? const Color(0xFF777C85)
                  : Colors.transparent,
              caption: NOverlayCaption(text: festival.title),
              captionOffset: 4,
            )..setOnTapListener((_) {
              unawaited(
                ref
                    .read(mapViewModelProvider.notifier)
                    .selectFestival(festival.id),
              );
            });
        markers.add(marker);
      }
      if (markers.isNotEmpty) await controller.addOverlayAll(markers);
    } on MissingPluginException {
      // PlatformView가 정리된 뒤 도착한 비동기 결과는 무시합니다.
    }
  }

  Future<NOverlayImage> _crowdMarkerIcon(FestivalAnalysis analysis) {
    final key = '${analysis.overall.level.name}_${analysis.overall.score}';
    final cached = _crowdMarkerIcons[key];
    if (cached != null) return Future.value(cached);
    return NOverlayImage.fromWidget(
      context: context,
      size: const Size(48, 54),
      widget: _CrowdScoreMarker(
        score: analysis.overall.score,
        color: _crowdColor(analysis.overall.level),
      ),
    ).then((image) {
      _crowdMarkerIcons[key] = image;
      return image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapViewModelProvider);
    final viewModel = ref.read(mapViewModelProvider.notifier);
    ref.listen<List<FestivalSummary>>(
      mapViewModelProvider.select((value) => value.visibleFestivals),
      (_, festivals) {
        final controller = _mapController;
        if (controller != null) {
          unawaited(_syncFestivalMarkers(controller, festivals));
        }
      },
    );
    ref.listen<Map<int, FestivalAnalysis>>(
      mapViewModelProvider.select((value) => value.analyses),
      (_, _) {
        final controller = _mapController;
        if (controller != null) {
          unawaited(
            _syncFestivalMarkers(
              controller,
              ref.read(mapViewModelProvider).visibleFestivals,
            ),
          );
        }
      },
    );
    final horizontalPadding = AppLayout.horizontalPadding(context);
    final navigationInset = AppLayout.navigationOverlayInset(context);
    final cardBottom = navigationInset + 12;
    final hideMapControls =
        state.selectedFestivalId != null && AppLayout.isCompactHeight(context);

    return ColoredBox(
      color: const Color(0xFFE8EFEA),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: _NaverCrowdMap(
                isCardVisible: state.selectedFestivalId != null,
                onMapReady: _handleMapReady,
                onMapTapped: viewModel.clearSelectedFestival,
              ),
            ),
            const Align(alignment: Alignment.topCenter, child: _MapHeader()),
            Positioned(
              top: 72,
              left: horizontalPadding,
              right: horizontalPadding,
              child: Column(
                children: [
                  const _SearchBar(),
                  const SizedBox(height: 12),
                  _FilterChips(
                    selected: state.filter,
                    onSelected: viewModel.selectFilter,
                  ),
                ],
              ),
            ),
            if (state.isLocating)
              const Positioned(
                top: 174,
                left: 0,
                right: 0,
                child: _LocatingIndicator(),
              ),
            if (state.isLoading)
              const Positioned(
                top: 174,
                left: 0,
                right: 0,
                child: _FestivalLoadingIndicator(),
              ),
            if (state.errorMessage != null)
              Positioned(
                top: 174,
                left: horizontalPadding,
                right: horizontalPadding,
                child: _MapErrorBanner(
                  message: state.errorMessage!,
                  onRetry: viewModel.loadFestivals,
                ),
              ),
            if (!hideMapControls)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                right: horizontalPadding,
                bottom: state.selectedFestivalId == null
                    ? navigationInset + 18
                    : cardBottom + 370,
                child: Column(
                  children: [
                    _RoundMapButton(
                      icon: Icons.my_location_rounded,
                      onTap: _moveToCurrentLocation,
                    ),
                    const SizedBox(height: 10),
                    const _RoundMapButton(icon: Icons.layers_outlined),
                  ],
                ),
              ),
            if (state.selectedFestival != null)
              Positioned(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: cardBottom,
                child: _FestivalPredictionCard(
                  festival: state.selectedFestival!,
                  analysis: state.selectedAnalysis,
                  isAnalyzing: state.isSelectedFestivalAnalyzing,
                  onClose: viewModel.clearSelectedFestival,
                  onTap: () => context.push(
                    AppRoutes.detail(state.selectedFestivalId!.toString()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NaverCrowdMap extends StatelessWidget {
  const _NaverCrowdMap({
    required this.isCardVisible,
    required this.onMapReady,
    required this.onMapTapped,
  });

  final bool isCardVisible;
  final ValueChanged<NaverMapController> onMapReady;
  final VoidCallback onMapTapped;

  static const _yeouido = NLatLng(37.5283, 126.9326);

  @override
  Widget build(BuildContext context) {
    if (!AppEnv.hasNaverMapClientId) {
      return const _MissingMapKeyBackground();
    }

    final navigationInset = AppLayout.navigationOverlayInset(context);
    final logoBottom = navigationInset + (isCardVisible ? 310 : 12);

    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: const NCameraPosition(
          target: _yeouido,
          zoom: 11.4,
        ),
        minZoom: 5.8,
        maxZoom: 19,
        locationButtonEnable: false,
        zoomGesturesEnable: true,
        rotationGesturesEnable: false,
        tiltGesturesEnable: false,
        scaleBarEnable: false,
        logoMargin: EdgeInsets.only(left: 8, bottom: logoBottom),
      ),
      onMapTapped: (point, position) => onMapTapped(),
      onMapReady: onMapReady,
    );
  }
}

class _MissingMapKeyBackground extends StatelessWidget {
  const _MissingMapKeyBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFE7EFEB),
        backgroundBlendMode: BlendMode.multiply,
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 44),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Color(0x22000000), blurRadius: 16),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, color: _brand, size: 32),
                  SizedBox(height: 10),
                  Text(
                    '네이버 지도 인증키가 필요합니다',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '.env에 NAVER_MAP_CLIENT_ID를 설정한 뒤\n앱을 다시 실행해 주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;
    final minorPaint = Paint()
      ..color = const Color(0xFFC8D8D0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var y = 40.0; y < size.height; y += 82) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 28), minorPaint);
    }
    for (var x = -100.0; x < size.width; x += 112) {
      canvas.drawLine(Offset(x, 0), Offset(x + 180, size.height), roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapHeader extends StatelessWidget {
  const _MapHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white.withValues(alpha: 0.96),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu_rounded, color: _brand),
          Text(
            '갈래말래',
            style: TextStyle(
              color: _brand,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Icon(CupertinoIcons.bell, color: _brand, size: 22),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x27000000),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Color(0xFF574D4A), size: 26),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              '축제 또는 지역 검색',
              style: TextStyle(color: Color(0xFFA69D9A), fontSize: 16),
            ),
          ),
          Icon(Icons.tune_rounded, color: _brand, size: 24),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final FestivalMapFilter selected;
  final ValueChanged<FestivalMapFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: FestivalMapFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = FestivalMapFilter.values[index];
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => onSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF6740) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF6740)
                      : const Color(0xFFE6DDDA),
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x16000000), blurRadius: 8),
                ],
              ),
              child: Text(
                filter.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : _muted,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoundMapButton extends StatelessWidget {
  const _RoundMapButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.fluid(context, compact: 44, regular: 50);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 10)],
        ),
        child: Icon(icon, color: const Color(0xFF5C4C49), size: 25),
      ),
    );
  }
}

class _LocatingIndicator extends StatelessWidget {
  const _LocatingIndicator();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(color: Color(0x26000000), blurRadius: 12),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoActivityIndicator(color: _brand),
              SizedBox(width: 9),
              Text('현재 위치 확인 중…', style: TextStyle(color: _ink, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FestivalLoadingIndicator extends StatelessWidget {
  const _FestivalLoadingIndicator();

  @override
  Widget build(BuildContext context) => const Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(color: _brand),
            SizedBox(width: 9),
            Text('축제 불러오는 중…', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    ),
  );
}

class _MapErrorBanner extends StatelessWidget {
  const _MapErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 10)],
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: _brand),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('재시도')),
      ],
    ),
  );
}

class _FestivalPredictionCard extends StatelessWidget {
  const _FestivalPredictionCard({
    required this.festival,
    required this.onClose,
    required this.onTap,
    required this.analysis,
    required this.isAnalyzing,
  });

  final FestivalSummary festival;
  final VoidCallback onClose;
  final VoidCallback onTap;
  final FestivalAnalysis? analysis;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _categoryLabel(festival.category),
                      style: const TextStyle(
                        color: Color(0xFF1765E5),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      festival.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      festival.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_date(festival.startDate)} – ${_date(festival.endDate)}',
                      style: const TextStyle(color: _brand, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              if (analysis != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _crowdColor(
                      analysis!.overall.level,
                    ).withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${analysis!.overall.score}',
                        style: TextStyle(
                          color: _crowdColor(analysis!.overall.level),
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        _crowdLabel(analysis!.overall.level),
                        style: TextStyle(
                          color: _crowdColor(analysis!.overall.level),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: onClose,
                child: const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.close_rounded, color: _muted, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isAnalyzing)
            const Row(
              children: [
                CupertinoActivityIndicator(),
                SizedBox(width: 9),
                Text('혼잡도를 분석하고 있어요…'),
              ],
            )
          else if (analysis == null)
            const Text(
              '이 축제의 혼잡도 데이터가 아직 없어요. 상세 화면에서 날짜를 선택해 분석할 수 있어요.',
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            )
          else ...[
            Row(
              children: [
                const Text(
                  '시간대별 혼잡 예측',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '추천 ${_periodLabel(analysis!.recommendedPeriod)}',
                  style: const TextStyle(color: _brand, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 9),
            _TimeSlotBars(slots: analysis!.timeSlots),
            const SizedBox(height: 6),
            Text(
              analysis!.freshness == DataFreshness.stale
                  ? '저장된 분석 데이터 · 네트워크 연결 후 갱신됩니다'
                  : '예측 신뢰도 ${(analysis!.confidence * 100).round()}%',
              style: const TextStyle(color: _muted, fontSize: 10),
            ),
          ],
          const SizedBox(height: 17),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 53,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _brandDark,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insights_rounded, color: Colors.white),
                  SizedBox(width: 9),
                  Text(
                    '상세 정보 및 혼잡도 분석',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSlotBars extends StatelessWidget {
  const _TimeSlotBars({required this.slots});
  final List<TimeSlotPrediction> slots;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 58,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final slot in slots) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 10 + slot.score * .32,
                  decoration: BoxDecoration(
                    color: _crowdColor(slot.level),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _periodLabel(slot.period),
                  style: const TextStyle(fontSize: 9, color: _muted),
                ),
              ],
            ),
          ),
          if (slot != slots.last) const SizedBox(width: 7),
        ],
      ],
    ),
  );
}

class _CrowdScoreMarker extends StatelessWidget {
  const _CrowdScoreMarker({required this.score, required this.color});
  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      Positioned(
        top: 5,
        child: Transform.rotate(
          angle: .785,
          child: Container(width: 30, height: 30, color: color),
        ),
      ),
      Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 8)],
        ),
        child: Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ],
  );
}

Color _crowdColor(CrowdLevel level) => switch (level) {
  CrowdLevel.low => const Color(0xFF1FA97A),
  CrowdLevel.medium => const Color(0xFFFF8A34),
  CrowdLevel.high => const Color(0xFFE34A33),
  CrowdLevel.veryHigh => const Color(0xFFBD171C),
};

String _crowdLabel(CrowdLevel level) => switch (level) {
  CrowdLevel.low => '여유',
  CrowdLevel.medium => '보통',
  CrowdLevel.high => '혼잡',
  CrowdLevel.veryHigh => '매우 혼잡',
};

String _periodLabel(DayPeriod period) => switch (period) {
  DayPeriod.morning => '오전',
  DayPeriod.afternoon => '오후',
  DayPeriod.evening => '저녁',
};

String _categoryLabel(FestivalCategory category) => switch (category) {
  FestivalCategory.culture => '문화',
  FestivalCategory.nature => '자연',
  FestivalCategory.food => '먹거리',
  FestivalCategory.performance => '공연',
  FestivalCategory.tradition => '전통',
  FestivalCategory.other => '기타',
};

String _date(DateTime value) =>
    '${value.year}.${value.month.toString().padLeft(2, '0')}.'
    '${value.day.toString().padLeft(2, '0')}';
