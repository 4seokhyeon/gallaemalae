import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/features/home/presentation/view_models/home_view_model.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    return AdaptivePage(
      title: '홈',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI 맞춤 추천', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 12),
          Text(state.summary),
        ],
      ),
    );
  }
}
