import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';

class FestivalListState {
  const FestivalListState({
    this.items = const [],
    this.category,
    this.query = '',
    this.regionCode,
    this.from,
    this.to,
    this.recentSearches = const [],
    this.page = -1,
    this.totalPages = 1,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });
  final List<FestivalSummary> items;
  final FestivalCategory? category;
  final String query;
  final String? regionCode;
  final DateTime? from;
  final DateTime? to;
  final List<String> recentSearches;
  final int page;
  final int totalPages;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  bool get hasMore => page + 1 < totalPages;
  List<FestivalSummary> get visibleItems => filterFestivalItems(items, query);
  bool get hasActiveFilters =>
      query.isNotEmpty || regionCode != null || from != null || to != null;

  FestivalListState copyWith({
    List<FestivalSummary>? items,
    FestivalCategory? category,
    String? query,
    String? regionCode,
    DateTime? from,
    DateTime? to,
    List<String>? recentSearches,
    int? page,
    int? totalPages,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearCategory = false,
    bool clearRegion = false,
    bool clearDates = false,
    bool clearError = false,
  }) => FestivalListState(
    items: items ?? this.items,
    category: clearCategory ? null : category ?? this.category,
    query: query ?? this.query,
    regionCode: clearRegion ? null : regionCode ?? this.regionCode,
    from: clearDates ? null : from ?? this.from,
    to: clearDates ? null : to ?? this.to,
    recentSearches: recentSearches ?? this.recentSearches,
    page: page ?? this.page,
    totalPages: totalPages ?? this.totalPages,
    isInitialLoading: isInitialLoading ?? this.isInitialLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}

class FestivalListViewModel extends AutoDisposeNotifier<FestivalListState> {
  static const _pageSize = 20;
  static const _recentSearchesKey = 'recent_festival_searches_v1';
  int _generation = 0;

  @override
  FestivalListState build() {
    Future<void>.microtask(_initialize);
    return const FestivalListState(isInitialLoading: true);
  }

  Future<void> _initialize() async {
    try {
      final saved = await ref
          .read(userActivityRepositoryProvider)
          .readSetting(_recentSearchesKey);
      if (saved != null && saved.isNotEmpty) {
        state = state.copyWith(
          recentSearches: (jsonDecode(saved) as List<dynamic>).cast<String>(),
        );
      }
    } catch (_) {
      // 검색 목록 조회는 최근 검색어 복원 실패와 관계없이 계속합니다.
    }
    await refresh();
  }

  Future<void> selectCategory(FestivalCategory? category) async {
    state = state.copyWith(category: category, clearCategory: category == null);
    await refresh();
  }

  Future<void> applyQuery(String value) async {
    final query = value.trim();
    state = state.copyWith(query: query);
    if (query.isNotEmpty) await _saveRecentSearch(query);
    await refresh();
  }

  Future<void> applyFilters({
    String? regionCode,
    DateTime? from,
    DateTime? to,
  }) async {
    state = state.copyWith(
      regionCode: regionCode,
      from: from,
      to: to,
      clearRegion: regionCode == null,
      clearDates: from == null && to == null,
    );
    await refresh();
  }

  Future<void> resetFilters() async {
    state = state.copyWith(
      query: '',
      clearCategory: true,
      clearRegion: true,
      clearDates: true,
    );
    await refresh();
  }

  Future<void> clearRecentSearches() async {
    state = state.copyWith(recentSearches: const []);
    await ref
        .read(userActivityRepositoryProvider)
        .writeSetting(_recentSearchesKey, '[]');
  }

  Future<void> _saveRecentSearch(String query) async {
    final searches = [
      query,
      ...state.recentSearches.where(
        (item) => item.toLowerCase() != query.toLowerCase(),
      ),
    ].take(5).toList();
    state = state.copyWith(recentSearches: searches);
    await ref
        .read(userActivityRepositoryProvider)
        .writeSetting(_recentSearchesKey, jsonEncode(searches));
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    state = state.copyWith(isInitialLoading: true, clearError: true);
    try {
      final result = await _search(0);
      if (generation != _generation) return;
      state = state.copyWith(
        items: result.items,
        page: result.page,
        totalPages: result.totalPages,
        isInitialLoading: false,
      );
    } catch (error) {
      if (generation != _generation) return;
      state = state.copyWith(isInitialLoading: false, errorMessage: '$error');
    }
  }

  Future<void> loadMore() async {
    if (state.isInitialLoading || state.isLoadingMore || !state.hasMore) return;
    final generation = _generation;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final result = await _search(state.page + 1);
      if (generation != _generation) return;
      final ids = state.items.map((item) => item.id).toSet();
      state = state.copyWith(
        items: [
          ...state.items,
          ...result.items.where((item) => ids.add(item.id)),
        ],
        page: result.page,
        totalPages: result.totalPages,
        isLoadingMore: false,
      );
    } catch (error) {
      if (generation != _generation) return;
      state = state.copyWith(isLoadingMore: false, errorMessage: '$error');
    }
  }

  Future<FestivalPage> _search(int page) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final from = state.from ?? today;
    final to = state.to ?? today.add(const Duration(days: 90));
    return ref
        .read(festivalRepositoryProvider)
        .search(
          regionCode: state.regionCode,
          from: from,
          to: to,
          categories: state.category == null ? const {} : {state.category!},
          page: page,
          size: state.query.isEmpty ? _pageSize : 100,
        );
  }
}

List<FestivalSummary> filterFestivalItems(
  List<FestivalSummary> items,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return items;
  return items
      .where(
        (festival) =>
            festival.title.toLowerCase().contains(normalized) ||
            festival.address.toLowerCase().contains(normalized),
      )
      .toList();
}

final festivalListViewModelProvider =
    NotifierProvider.autoDispose<FestivalListViewModel, FestivalListState>(
      FestivalListViewModel.new,
    );
