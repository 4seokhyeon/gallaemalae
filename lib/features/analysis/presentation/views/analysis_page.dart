import 'package:flutter/widgets.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptivePage(
      title: '분석',
      child: Center(child: Text('시간대별 혼잡도 예측 및 상세 통계')),
    );
  }
}
