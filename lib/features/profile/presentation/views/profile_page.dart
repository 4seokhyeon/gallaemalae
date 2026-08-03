import 'package:flutter/widgets.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptivePage(
      title: '프로필',
      child: Center(child: Text('개인 설정 · 제보 내역 · 관심 축제')),
    );
  }
}
