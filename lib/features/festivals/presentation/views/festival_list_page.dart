import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/core/network/festival_request_status.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/features/festivals/presentation/view_models/festival_list_view_model.dart';
import 'package:go_router/go_router.dart';

const _brand = Color(0xFFC93A06);
const _background = Color(0xFFF7F7FA);

class FestivalListPage extends ConsumerStatefulWidget {
  const FestivalListPage({super.key});
  @override
  ConsumerState<FestivalListPage> createState() => _FestivalListPageState();
}

class _FestivalListPageState extends ConsumerState<FestivalListPage> {
  final _controller = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.extentAfter < 320) {
      ref.read(festivalListViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(festivalListViewModelProvider);
    final isRetrying = ref.watch(festivalRequestStatusProvider);
    final body = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  controller: _searchController,
                  hintText: '축제명 또는 장소 검색',
                  leading: const Icon(Icons.search_rounded),
                  trailing: [
                    if (state.query.isNotEmpty)
                      IconButton(
                        tooltip: '검색어 지우기',
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(festivalListViewModelProvider.notifier)
                              .applyQuery('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                  ],
                  onSubmitted: (value) => ref
                      .read(festivalListViewModelProvider.notifier)
                      .applyQuery(value),
                ),
              ),
              const SizedBox(width: 8),
              Badge(
                isLabelVisible:
                    state.regionCode != null ||
                    state.from != null ||
                    state.to != null,
                child: IconButton.filledTonal(
                  tooltip: '지역 및 날짜 필터',
                  onPressed: () => _showFilters(state),
                  icon: const Icon(Icons.tune_rounded),
                ),
              ),
            ],
          ),
        ),
        if (state.recentSearches.isNotEmpty && state.query.isEmpty)
          _RecentSearches(
            searches: state.recentSearches,
            onSelected: (query) {
              _searchController.text = query;
              ref
                  .read(festivalListViewModelProvider.notifier)
                  .applyQuery(query);
            },
            onClear: ref
                .read(festivalListViewModelProvider.notifier)
                .clearRecentSearches,
          ),
        _CategoryFilters(selected: state.category),
        if (isRetrying) const _RetryingNotice(),
        if (state.hasActiveFilters || state.category != null)
          _ActiveFilterSummary(
            state: state,
            onReset: () {
              _searchController.clear();
              ref.read(festivalListViewModelProvider.notifier).resetFilters();
            },
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: ref.read(festivalListViewModelProvider.notifier).refresh,
            child: _FestivalList(
              state: state,
              controller: _controller,
              onRetry: ref.read(festivalListViewModelProvider.notifier).refresh,
            ),
          ),
        ),
      ],
    );
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        backgroundColor: _background,
        navigationBar: const CupertinoNavigationBar(middle: Text('전체 축제')),
        child: SafeArea(
          bottom: false,
          child: Material(color: _background, child: body),
        ),
      );
    }
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(title: const Text('전체 축제')),
      body: body,
    );
  }

  Future<void> _showFilters(FestivalListState state) async {
    var regionCode = state.regionCode ?? '';
    DateTimeRange? range = state.from != null && state.to != null
        ? DateTimeRange(start: state.from!, end: state.to!)
        : null;
    final result = await showModalBottomSheet<(String, DateTimeRange?)>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '상세 필터',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  initialValue: regionCode,
                  decoration: const InputDecoration(
                    labelText: '지역',
                    border: OutlineInputBorder(),
                  ),
                  items: _regions
                      .map(
                        (region) => DropdownMenuItem<String>(
                          value: region.$2 ?? '',
                          child: Text(region.$1),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setSheetState(() => regionCode = value ?? ''),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final selected = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(now.year, now.month, now.day),
                      lastDate: now.add(const Duration(days: 730)),
                      initialDateRange: range,
                      helpText: '축제 기간 선택',
                    );
                    if (selected != null) {
                      setSheetState(() => range = selected);
                    }
                  },
                  icon: const Icon(Icons.date_range_rounded),
                  label: Text(
                    range == null
                        ? '날짜 범위 선택'
                        : '${_fullDate(range!.start)} – ${_fullDate(range!.end)}',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(sheetContext, (null, null)),
                      child: const Text('지역·날짜 초기화'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(sheetContext, (regionCode, range)),
                      child: const Text('적용'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result == null) return;
    await ref
        .read(festivalListViewModelProvider.notifier)
        .applyFilters(
          regionCode: result.$1.isEmpty ? null : result.$1,
          from: result.$2?.start,
          to: result.$2?.end,
        );
  }
}

class _RetryingNotice extends StatelessWidget {
  const _RetryingNotice();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
    child: Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 10),
        Expanded(child: Text('서버에서 축제 정보를 불러오는 중이에요')),
      ],
    ),
  );
}

const _regions = <(String, String?)>[
  ('전체 지역', null),
  ('서울', '11'),
  ('부산', '26'),
  ('대구', '27'),
  ('인천', '28'),
  ('광주', '29'),
  ('대전', '30'),
  ('울산', '31'),
  ('세종', '36'),
  ('경기', '41'),
  ('강원', '51'),
  ('충북', '43'),
  ('충남', '44'),
  ('전북', '52'),
  ('전남', '46'),
  ('경북', '47'),
  ('경남', '48'),
  ('제주', '50'),
];

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.searches,
    required this.onSelected,
    required this.onClear,
  });
  final List<String> searches;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: searches.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, index) => ActionChip(
                label: Text(searches[index]),
                onPressed: () => onSelected(searches[index]),
              ),
            ),
          ),
        ),
        TextButton(onPressed: onClear, child: const Text('삭제')),
      ],
    ),
  );
}

class _ActiveFilterSummary extends StatelessWidget {
  const _ActiveFilterSummary({required this.state, required this.onReset});
  final FestivalListState state;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final labels = <String>[
      if (state.query.isNotEmpty) '“${state.query}”',
      if (state.regionCode != null) _regionLabel(state.regionCode!),
      if (state.from != null && state.to != null)
        '${_fullDate(state.from!)}–${_fullDate(state.to!)}',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              labels.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _brand, fontSize: 12),
            ),
          ),
          TextButton(onPressed: onReset, child: const Text('전체 초기화')),
        ],
      ),
    );
  }
}

class _CategoryFilters extends ConsumerWidget {
  const _CategoryFilters({required this.selected});
  final FestivalCategory? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const filters = <(String, FestivalCategory?)>[
      ('전체', null),
      ('문화', FestivalCategory.culture),
      ('자연', FestivalCategory.nature),
      ('먹거리', FestivalCategory.food),
      ('공연', FestivalCategory.performance),
      ('전통', FestivalCategory.tradition),
      ('기타', FestivalCategory.other),
    ];
    return SizedBox(
      height: 62,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final (label, category) = filters[index];
          return ChoiceChip(
            label: Text(label),
            selected: selected == category,
            onSelected: (_) => ref
                .read(festivalListViewModelProvider.notifier)
                .selectCategory(category),
          );
        },
      ),
    );
  }
}

class _FestivalList extends StatelessWidget {
  const _FestivalList({
    required this.state,
    required this.controller,
    required this.onRetry,
  });
  final FestivalListState state;
  final ScrollController controller;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final items = state.visibleItems;
    if (state.isInitialLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      final failedToLoadInitialData =
          state.errorMessage != null && state.page < 0;
      return ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 150),
          if (failedToLoadInitialData) ...[
            const Icon(Icons.cloud_off_rounded, color: _brand, size: 42),
            const SizedBox(height: 12),
            const Text(
              '첫 축제 정보를 불러오지 못했어요',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            state.errorMessage ?? '조건에 맞는 축제가 없습니다.',
            textAlign: TextAlign.center,
          ),
          if (state.errorMessage != null)
            Center(
              child: TextButton(onPressed: onRetry, child: const Text('재시도')),
            ),
        ],
      );
    }
    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: items.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final festival = items[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 64,
                height: 64,
                child: festival.primaryImageUrl.isEmpty
                    ? const ColoredBox(
                        color: Color(0xFFFFE5DD),
                        child: Icon(Icons.festival_rounded, color: _brand),
                      )
                    : Image.network(
                        festival.primaryImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: Color(0xFFFFE5DD),
                          child: Icon(Icons.festival_rounded, color: _brand),
                        ),
                      ),
              ),
            ),
            title: Text(
              festival.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${festival.address}\n${_date(festival.startDate)} – ${_date(festival.endDate)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.detail(festival.id.toString())),
          ),
        );
      },
    );
  }
}

String _date(DateTime value) => '${value.month}.${value.day}';
String _fullDate(DateTime value) =>
    '${value.year}.${value.month.toString().padLeft(2, '0')}.${value.day.toString().padLeft(2, '0')}';
String _regionLabel(String code) =>
    _regions.where((region) => region.$2 == code).firstOrNull?.$1 ?? code;
