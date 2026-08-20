import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/features/favorites/presentation/view_models/favorites_view_model.dart';
import 'package:go_router/go_router.dart';

class FavoriteFestivalsPage extends ConsumerWidget {
  const FavoriteFestivalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritePlacesProvider);
    final body = favorites.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _Message(
        icon: Icons.error_outline_rounded,
        text: '관심 축제를 불러오지 못했어요.',
      ),
      data: (items) => items.isEmpty
          ? const _Message(
              icon: Icons.favorite_border_rounded,
              text: '저장한 관심 축제가 없어요.\n축제 상세에서 하트를 눌러 보세요.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _FavoriteCard(
                favorite: items[index],
                onDelete: () => ref
                    .read(favoritesControllerProvider.notifier)
                    .remove(items[index].placeId),
              ),
            ),
    );

    final canClear = favorites.valueOrNull?.isNotEmpty == true;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('관심 축제'),
          trailing: canClear
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      _confirmClear(context, ref, favorites.requireValue),
                  child: const Icon(CupertinoIcons.delete),
                )
              : null,
        ),
        child: SafeArea(bottom: false, child: body),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 축제'),
        actions: [
          if (canClear)
            IconButton(
              tooltip: '전체 삭제',
              onPressed: () =>
                  _confirmClear(context, ref, favorites.requireValue),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: body,
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    WidgetRef ref,
    List<FavoritePlace> favorites,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('관심 축제 전체 삭제'),
        content: const Text('저장한 관심 축제를 모두 삭제할까요?'),
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
    );
    if (confirmed == true) {
      await ref.read(favoritesControllerProvider.notifier).clear(favorites);
    }
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.favorite, required this.onDelete});
  final FavoritePlace favorite;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      onTap: () => context.push(AppRoutes.detail(favorite.placeId)),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      leading: const CircleAvatar(child: Icon(Icons.celebration_rounded)),
      title: Text(
        favorite.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: const Text('눌러서 축제 상세보기'),
      trailing: IconButton(
        tooltip: '관심 축제에서 삭제',
        onPressed: onDelete,
        icon: const Icon(Icons.favorite_rounded, color: Color(0xFFC93A06)),
      ),
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: Colors.grey),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
