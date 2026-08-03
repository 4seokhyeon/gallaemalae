import 'package:flutter/widgets.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({required this.placeId, super.key});

  final String placeId;

  @override
  Widget build(BuildContext context) {
    return AdaptivePage(
      title: '상세 예측',
      child: Center(child: Text('$placeId의 예측 및 대안 장소 추천')),
    );
  }
}
