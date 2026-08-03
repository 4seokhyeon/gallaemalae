import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/config/app_env.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/geo_point.dart';
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
    _router?.routerDelegate.removeListener(_handleRouteChange);
    super.dispose();
  }

  void _handleRouteChange() {
    final path = _router?.routerDelegate.currentConfiguration.uri.path;
    final isMapRouteActive = path == AppRoutes.map;

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

    _locationRequestInProgress = true;
    ref.read(mapViewModelProvider.notifier).setLocating(true);

    final status = await Permission.locationWhenInUse.request();
    if (!mounted) return;

    if (status.isGranted) {
      final repository = ref.read(locationRepositoryProvider);
      controller.setLocationTrackingMode(NLocationTrackingMode.follow);
      try {
        if (!await repository.isServiceEnabled()) return;

        final cachedPosition = await repository.getLastKnownPosition();
        if (cachedPosition != null) {
          await _updateCamera(cachedPosition, animated: false);
        }

        final currentPosition = await repository.getCurrentPosition();
        await _updateCamera(currentPosition, animated: true);
      } catch (error, stackTrace) {
        // GPS 시간 초과 시 마지막 위치 또는 현재 지도 위치를 유지합니다.
        debugPrint('현재 위치 조회 실패: $error');
        debugPrintStack(stackTrace: stackTrace);
      } finally {
        _locationRequestInProgress = false;
        if (mounted) {
          ref.read(mapViewModelProvider.notifier).setLocating(false);
        }
      }
      return;
    }

    _locationRequestInProgress = false;
    ref.read(mapViewModelProvider.notifier).setLocating(false);
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

  Future<void> _updateCamera(GeoPoint point, {required bool animated}) {
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
    return _mapController!.updateCamera(update).then((_) {});
  }

  void _handleMapReady(NaverMapController controller) {
    _mapController = controller;
    if (_wasMapRouteActive) _moveToCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapViewModelProvider);
    final viewModel = ref.read(mapViewModelProvider.notifier);
    final horizontalPadding = AppLayout.horizontalPadding(context);
    final navigationInset = AppLayout.navigationOverlayInset(context);
    final cardBottom = navigationInset + 12;
    final hideMapControls =
        state.selectedPlaceId != null && AppLayout.isCompactHeight(context);

    return ColoredBox(
      color: const Color(0xFFE8EFEA),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: _NaverCrowdMap(
                isCardVisible: state.selectedPlaceId != null,
                onMapReady: _handleMapReady,
                onMarkerTapped: viewModel.selectPlace,
                onMapTapped: viewModel.clearSelectedPlace,
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
            if (!hideMapControls)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                right: horizontalPadding,
                bottom: state.selectedPlaceId == null
                    ? navigationInset + 18
                    : cardBottom + 300,
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
            if (state.selectedPlaceId != null)
              Positioned(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: cardBottom,
                child: _FestivalPredictionCard(
                  onClose: viewModel.clearSelectedPlace,
                  onTap: () =>
                      context.push(AppRoutes.detail(state.selectedPlaceId!)),
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
    required this.onMarkerTapped,
    required this.onMapTapped,
  });

  final bool isCardVisible;
  final ValueChanged<NaverMapController> onMapReady;
  final ValueChanged<String> onMarkerTapped;
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
      onMapReady: (controller) async {
        onMapReady(controller);
        final festivalMarker =
            NMarker(
              id: 'hangang_fireworks',
              position: _yeouido,
              iconTintColor: const Color(0xFFD21F24),
              caption: const NOverlayCaption(text: '매우 혼잡'),
            )..setOnTapListener((marker) {
              onMarkerTapped('hangang-fireworks');
            });
        final gangnamMarker =
            NMarker(
              id: 'gangnam_normal',
              position: const NLatLng(37.4979, 127.0276),
              iconTintColor: const Color(0xFFFF6838),
              caption: const NOverlayCaption(text: '보통'),
            )..setOnTapListener((marker) {
              onMarkerTapped('gangnam-normal');
            });

        final overlays = <NAddableOverlay>{
          NCircleOverlay(
            id: 'crowd_hot_yeouido',
            center: _yeouido,
            radius: 3100,
            color: const Color(0x60E83027),
            outlineColor: Colors.transparent,
          ),
          NCircleOverlay(
            id: 'crowd_hot_jongno',
            center: const NLatLng(37.5729, 126.9794),
            radius: 1900,
            color: const Color(0x54F15A2A),
            outlineColor: Colors.transparent,
          ),
          NCircleOverlay(
            id: 'crowd_normal_gangnam',
            center: const NLatLng(37.4979, 127.0276),
            radius: 2600,
            color: const Color(0x52FF7B36),
            outlineColor: Colors.transparent,
          ),
          NCircleOverlay(
            id: 'crowd_relaxed_mapo',
            center: const NLatLng(37.5563, 126.9220),
            radius: 1500,
            color: const Color(0x4939C79B),
            outlineColor: Colors.transparent,
          ),
          festivalMarker,
          gangnamMarker,
        };
        await controller.addOverlayAll(overlays);
      },
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

  final CrowdFilter selected;
  final ValueChanged<CrowdFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CrowdFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = CrowdFilter.values[index];
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

class _FestivalPredictionCard extends StatelessWidget {
  const _FestivalPredictionCard({required this.onClose, required this.onTap});

  final VoidCallback onClose;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const bars = [
      10.0,
      15.0,
      20.0,
      29.0,
      34.0,
      43.0,
      47.0,
      41.0,
      31.0,
      24.0,
      14.0,
      9.0,
    ];
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
                    const Row(
                      children: [
                        Text(
                          'MUSIC FESTIVAL',
                          style: TextStyle(
                            color: Color(0xFF1765E5),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.schedule, size: 15, color: _muted),
                        SizedBox(width: 3),
                        Text(
                          '14:00 - 22:00',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text(
                      '2024 한강 불꽃 축제',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '여의도 한강공원 일대 · 2.4km 거리',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFC1C1)),
                ),
                child: const Column(
                  children: [
                    Text(
                      '88%',
                      style: TextStyle(
                        color: Color(0xFFD51F27),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '매우 혼잡',
                      style: TextStyle(color: Color(0xFFD51F27), fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: onClose,
                child: const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.close_rounded, color: _muted, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('시간별 혼잡도 예측', style: TextStyle(color: _muted, fontSize: 12)),
              Text(
                '19:00 최고 혼잡',
                style: TextStyle(color: _brand, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 51,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < bars.length; index++)
                  Expanded(
                    child: Container(
                      height: bars[index],
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index < 3
                            ? const Color(0xFF43C6A2)
                            : index < 8
                            ? const Color(0xFFFF5C35)
                            : const Color(0xFFFF916F),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                        border: index == 6
                            ? Border.all(color: _brandDark, width: 2)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('12:00', style: TextStyle(color: _muted, fontSize: 9)),
              Text('NOW', style: TextStyle(color: _ink, fontSize: 9)),
              Text('24:00', style: TextStyle(color: _muted, fontSize: 9)),
            ],
          ),
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
                    '상세 예측 및 대안 보기',
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
