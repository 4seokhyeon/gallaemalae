import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/core/navigation/tab_reselection.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';
import 'package:gallaemalae/domain/entities/visit.dart';
import 'package:gallaemalae/features/favorites/presentation/view_models/favorites_view_model.dart';
import 'package:gallaemalae/features/analysis/presentation/view_models/analysis_view_model.dart';
import 'package:gallaemalae/features/personality/presentation/view_models/personality_view_model.dart';
import 'package:gallaemalae/features/visits/presentation/view_models/visit_plans_view_model.dart';
import 'package:gallaemalae/features/onboarding/presentation/view_models/user_name_view_model.dart';
import 'package:go_router/go_router.dart';

const _brand = Color(0xFFC93A06);
const _orange = Color(0xFFFF6338);
const _ink = Color(0xFF29262C);
const _muted = Color(0xFF756E70);
const _background = Color(0xFFF8F8FB);

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final personality = ref.watch(personalityProvider).value;
    final favorites = ref.watch(favoritePlacesProvider);
    final userName = ref.watch(userNameProvider).valueOrNull ?? '사용자';
    final visitPlans = ref.watch(visitPlansProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final planItems = visitPlans.valueOrNull ?? const <Visit>[];
    final upcomingCount = planItems
        .where((visit) => !visit.visitedAt.isBefore(today))
        .length;
    final pastCount = planItems.length - upcomingCount;
    final body = ReselectableTabScrollView(
      tabIndex: 3,
      builder: (controller) => CustomScrollView(
        controller: controller,
        slivers: [
          const SliverToBoxAdapter(child: _ProfileHeader()),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppLayout.horizontalPadding(context),
              24,
              AppLayout.horizontalPadding(context),
              AppLayout.navigationOverlayInset(context) + 30,
            ),
            sliver: SliverList.list(
              children: [
                _UserCard(
                  name: userName,
                  personality: personality,
                  onEditName: () => _editName(userName),
                  onRetest: _retest,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: '관심 축제',
                        value: '${favorites.valueOrNull?.length ?? 0}',
                        unit: '곳',
                        color: _brand,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: '방문 예정',
                        value: '$upcomingCount',
                        unit: '건',
                        color: const Color(0xFF1359E8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: '지난 일정',
                        value: '$pastCount',
                        unit: '건',
                        color: _muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                _SectionTitle(
                  icon: Icons.favorite_rounded,
                  title: '나의 관심 축제',
                  trailing: '전체보기',
                  onTrailingTap: () =>
                      context.push(AppRoutes.favoriteFestivals),
                ),
                const SizedBox(height: 13),
                _FavoriteFestivals(favorites: favorites),
                const SizedBox(height: 26),
                _SectionTitle(
                  icon: Icons.calendar_month_rounded,
                  title: '방문 일정',
                  trailing: '전체보기',
                  onTrailingTap: () => context.push(AppRoutes.visitPlans),
                ),
                const SizedBox(height: 15),
                _VisitPlansPreview(plans: visitPlans),
                const SizedBox(height: 28),
                _PersonalityCard(personality: personality, onRetest: _retest),
                const SizedBox(height: 28),
                const _SectionTitle(
                  icon: Icons.settings_outlined,
                  title: '데이터 및 설정',
                ),
                const SizedBox(height: 13),
                _SettingsCard(
                  onEditName: () => _editName(userName),
                  onClearSearches: _clearRecentSearches,
                  onClearFavorites: () => _clearFavorites(
                    favorites.valueOrNull ?? const <FavoritePlace>[],
                  ),
                  onClearPlans: () => _clearPlans(planItems),
                  onClearCache: _clearCache,
                  onResetAll: () => _resetAll(
                    favorites.valueOrNull ?? const <FavoritePlace>[],
                    planItems,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        backgroundColor: _background,
        child: SafeArea(bottom: false, child: body),
      );
    }
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(bottom: false, child: body),
    );
  }

  void _retest() {
    ref.read(personalityTestControllerProvider.notifier).reset();
    context.push(AppRoutes.personalityTest);
  }

  Future<void> _editName(String currentName) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _EditNameDialog(initialName: currentName),
    );
    if (name != null) await ref.read(userNameProvider.notifier).save(name);
  }

  Future<bool> _confirm(String title, String message) async =>
      await showAdaptiveDialog<bool>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('삭제'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _clearRecentSearches() async {
    if (!await _confirm('최근 검색어 삭제', '저장된 최근 검색어를 모두 삭제할까요?')) return;
    await ref
        .read(userActivityRepositoryProvider)
        .writeSetting('recent_festival_searches_v1', '[]');
  }

  Future<void> _clearFavorites(List<FavoritePlace> favorites) async {
    if (favorites.isEmpty ||
        !await _confirm('관심 축제 삭제', '저장한 관심 축제를 모두 삭제할까요?')) {
      return;
    }
    await ref.read(favoritesControllerProvider.notifier).clear(favorites);
  }

  Future<void> _clearPlans(List<Visit> plans) async {
    if (plans.isEmpty || !await _confirm('방문 일정 삭제', '저장한 방문 일정을 모두 삭제할까요?')) {
      return;
    }
    for (final plan in plans) {
      await ref
          .read(visitPlansControllerProvider.notifier)
          .remove(int.parse(plan.placeId));
    }
  }

  Future<void> _clearCache() async {
    if (!await _confirm('캐시 삭제', '저장된 축제 API 데이터를 삭제할까요?')) return;
    await ref.read(festivalCacheStoreProvider).clear();
  }

  Future<void> _resetAll(
    List<FavoritePlace> favorites,
    List<Visit> plans,
  ) async {
    if (!await _confirm('앱 데이터 초기화', '이름, 성향, 관심 축제와 방문 일정을 모두 삭제할까요?')) {
      return;
    }
    await ref.read(favoritesControllerProvider.notifier).clear(favorites);
    for (final plan in plans) {
      await ref
          .read(visitPlansControllerProvider.notifier)
          .remove(int.parse(plan.placeId));
    }
    final repository = ref.read(userActivityRepositoryProvider);
    await repository.deleteSetting('user_name_v1');
    await repository.deleteSetting('festival_personality_v1');
    await repository.deleteSetting('recent_festival_searches_v1');
    await repository.deleteSetting(analysisSelectionSettingKey);
    await ref.read(festivalCacheStoreProvider).clear();
    ref.invalidate(userNameProvider);
    ref.invalidate(personalityProvider);
    if (mounted) context.go(AppRoutes.nameEntry);
  }
}

class _EditNameDialog extends StatefulWidget {
  const _EditNameDialog({required this.initialName});
  final String initialName;

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
    _controller.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  void _save() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) Navigator.pop(context, value);
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _controller.text.trim().isNotEmpty;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: const Text('이름 변경'),
        content: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: CupertinoTextField(
            controller: _controller,
            autofocus: true,
            maxLength: 20,
            placeholder: '이름',
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => canSave ? _save() : null,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            onPressed: canSave ? _save : null,
            isDefaultAction: true,
            child: const Text('저장'),
          ),
        ],
      );
    }
    return AlertDialog(
      title: const Text('이름 변경'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 20,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(labelText: '이름'),
        onSubmitted: (_) => canSave ? _save() : null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: canSave ? _save : null,
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFEAE7E7))),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.menu_rounded, color: _brand, size: 25),
        Text(
          '갈래말래',
          style: TextStyle(
            color: _brand,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Icon(CupertinoIcons.bell, color: _brand, size: 23),
      ],
    ),
  );
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.name,
    required this.personality,
    required this.onEditName,
    required this.onRetest,
  });
  final String name;
  final FestivalPersonality? personality;
  final VoidCallback onEditName;
  final VoidCallback onRetest;
  @override
  Widget build(BuildContext context) => _WhiteCard(
    child: Row(
      children: [
        const CircleAvatar(
          radius: 38,
          backgroundColor: Color(0xFFFFE3DA),
          child: Icon(Icons.person_rounded, color: _brand, size: 46),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$name 님',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                personality?.shortTitle ?? '성향 테스트 전',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: [
                  TextButton(onPressed: onEditName, child: const Text('이름 변경')),
                  TextButton(onPressed: onRetest, child: const Text('성향 재검사')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}

class _PersonalityCard extends StatelessWidget {
  const _PersonalityCard({required this.personality, required this.onRetest});
  final FestivalPersonality? personality;
  final VoidCallback onRetest;
  @override
  Widget build(BuildContext context) => _WhiteCard(
    child: Column(
      children: [
        Row(
          children: [
            const Icon(Icons.psychology_alt_outlined, color: _brand),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '나의 축제 성향',
                style: TextStyle(
                  color: _ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onRetest,
              icon: const Icon(Icons.refresh_rounded, size: 15),
              label: const Text('다시 테스트하기'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1359E8),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8EBE6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personality?.title ?? '성향 테스트가 필요해요',
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      personality?.description ?? '테스트를 통해 맞춤 축제를 추천받아 보세요.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });
  final String label, value, unit;
  final Color color;
  @override
  Widget build(BuildContext context) => _WhiteCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
        const SizedBox(height: 7),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(color: _ink, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: _brand, size: 22),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      if (trailing != null)
        TextButton(
          onPressed: onTrailingTap,
          child: Text(
            trailing!,
            style: const TextStyle(color: Color(0xFF1359E8), fontSize: 12),
          ),
        ),
    ],
  );
}

class _FavoriteFestivals extends StatelessWidget {
  const _FavoriteFestivals({required this.favorites});

  final AsyncValue<List<FavoritePlace>> favorites;

  @override
  Widget build(BuildContext context) => favorites.when(
    loading: () => const _FavoriteEmpty(message: '관심 축제를 불러오는 중이에요.'),
    error: (_, _) => const _FavoriteEmpty(message: '관심 축제를 불러오지 못했어요.'),
    data: (items) {
      if (items.isEmpty) {
        return const _FavoriteEmpty(message: '축제 상세에서 하트를 눌러 저장해 보세요.');
      }
      return SizedBox(
        height: 216,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 13),
          itemBuilder: (context, index) {
            final favorite = items[index];
            return _FestivalTile(
              title: favorite.name,
              subtitle: '저장한 관심 축제',
              match: '상세보기',
              color: const Color(0xFF233D67),
              onTap: () => context.push(AppRoutes.detail(favorite.placeId)),
            );
          },
        ),
      );
    },
  );
}

class _FavoriteEmpty extends StatelessWidget {
  const _FavoriteEmpty({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    height: 110,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(message, style: const TextStyle(color: _muted)),
  );
}

class _FestivalTile extends StatelessWidget {
  const _FestivalTile({
    required this.title,
    required this.subtitle,
    required this.match,
    required this.color,
    required this.onTap,
  });
  final String title, subtitle;
  final Color color;
  final String match;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(13),
    child: Container(
      width: 255,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 12)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 125,
              color: color,
              child: const Center(
                child: Icon(
                  Icons.celebration_rounded,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    color: const Color(0xFFFFE8DF),
                    child: Text(
                      match,
                      style: const TextStyle(
                        color: _brand,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _VisitPlansPreview extends StatelessWidget {
  const _VisitPlansPreview({required this.plans});
  final AsyncValue<List<Visit>> plans;

  @override
  Widget build(BuildContext context) => plans.when(
    loading: () => const _FavoriteEmpty(message: '방문 일정을 불러오는 중이에요.'),
    error: (_, _) => const _FavoriteEmpty(message: '방문 일정을 불러오지 못했어요.'),
    data: (items) {
      if (items.isEmpty) {
        return const _FavoriteEmpty(message: '축제 상세에서 방문 예정일을 저장해 보세요.');
      }
      final sorted = [...items]
        ..sort((a, b) => a.visitedAt.compareTo(b.visitedAt));
      return Column(
        children: [
          for (var index = 0; index < sorted.take(2).length; index++) ...[
            _VisitCard(
              title: sorted[index].placeName,
              date: _visitDate(sorted[index].visitedAt),
              crowdScore: sorted[index].crowdLevel,
              onTap: () => context.push(AppRoutes.visitPlans),
            ),
            if (index < sorted.take(2).length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    },
  );
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({
    required this.title,
    required this.date,
    required this.crowdScore,
    required this.onTap,
  });
  final String title, date;
  final int crowdScore;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: _WhiteCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF9E9E3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.history_rounded, color: _brand),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '저장 당시 예상 혼잡도: $crowdScore점',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

String _visitDate(DateTime value) =>
    '${value.year}.${value.month.toString().padLeft(2, '0')}.'
    '${value.day.toString().padLeft(2, '0')}';

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.onEditName,
    required this.onClearSearches,
    required this.onClearFavorites,
    required this.onClearPlans,
    required this.onClearCache,
    required this.onResetAll,
  });
  final VoidCallback onEditName;
  final VoidCallback onClearSearches;
  final VoidCallback onClearFavorites;
  final VoidCallback onClearPlans;
  final VoidCallback onClearCache;
  final VoidCallback onResetAll;
  @override
  Widget build(BuildContext context) => _WhiteCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        _SettingRow(
          icon: Icons.badge_outlined,
          title: '이름 변경',
          onTap: onEditName,
        ),
        const Divider(height: 1),
        _SettingRow(
          icon: Icons.search_off_rounded,
          title: '최근 검색어 삭제',
          onTap: onClearSearches,
        ),
        const Divider(height: 1),
        _SettingRow(
          icon: Icons.heart_broken_outlined,
          title: '관심 축제 전체 삭제',
          onTap: onClearFavorites,
        ),
        const Divider(height: 1),
        _SettingRow(
          icon: Icons.event_busy_outlined,
          title: '방문 일정 전체 삭제',
          onTap: onClearPlans,
        ),
        const Divider(height: 1),
        _SettingRow(
          icon: Icons.cleaning_services_outlined,
          title: '오프라인 캐시 삭제',
          onTap: onClearCache,
        ),
        const Divider(height: 1),
        _SettingRow(
          icon: Icons.delete_forever_outlined,
          title: '앱 데이터 전체 초기화',
          titleColor: Colors.red,
          onTap: onResetAll,
        ),
      ],
    ),
  );
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    this.titleColor = _ink,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final Color titleColor;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        children: [
          Icon(
            icon,
            color: titleColor == Colors.red
                ? Colors.red
                : const Color(0xFF66504A),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) const Icon(Icons.chevron_right_rounded),
        ],
      ),
    ),
  );
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.child,
    this.padding = const EdgeInsets.all(17),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0E000000),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}
