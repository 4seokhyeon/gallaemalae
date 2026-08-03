import 'package:flutter/widgets.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptivePage(
      title: '지도',
      child: Center(child: Text('실시간 혼잡도 히트맵 및 장소 검색')),
    );
  }
}
