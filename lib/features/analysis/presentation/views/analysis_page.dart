import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/core/navigation/tab_reselection.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

const _brand = Color(0xFFC93A06);
const _orange = Color(0xFFFF6338);
const _green = Color(0xFF00AE83);
const _blue = Color(0xFF1359E8);
const _ink = Color(0xFF29262C);
const _muted = Color(0xFF7C7475);
const _background = Color(0xFFF7F7FA);

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  static const _shareText = '''[갈래말래] 서울 불꽃 축제 2024 혼잡도 분석

현재 실시간 혼잡 점수는 42점으로 비교적 쾌적해요.
오후 6시 이후 혼잡도가 완화되어 방문하기 좋습니다.
예상 방문객 12,500명 · 전 시간대 대비 15% 감소

#갈래말래 #서울불꽃축제 #실시간혼잡도''';

  Future<void> _share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        subject: '서울 불꽃 축제 2024 혼잡도 분석',
        text: _shareText,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = ReselectableTabScrollView(
      tabIndex: 2,
      builder: (controller) => CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(child: _AnalysisHeader(onShare: _share)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppLayout.horizontalPadding(context),
              24,
              AppLayout.horizontalPadding(context),
              AppLayout.navigationOverlayInset(context) + 32,
            ),
            sliver: SliverList.list(
              children: const [
                _FestivalHeading(),
                SizedBox(height: 20),
                _DecisionCard(),
                SizedBox(height: 16),
                _CrowdScoreCard(),
                SizedBox(height: 24),
                _SectionHeading(title: '시간대별 AI 혼잡 예측', trailing: '24시간 기준'),
                SizedBox(height: 12),
                _ForecastCard(),
                SizedBox(height: 18),
                _VisitorAnalysisCard(),
                SizedBox(height: 18),
                _AiDetailCard(),
                SizedBox(height: 18),
                _TransportCard(),
                SizedBox(height: 24),
                _SectionHeading(title: '주변 주요 포인트'),
                SizedBox(height: 12),
                _AreaMapCard(),
              ],
            ),
          ),
        ],
      ),
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        backgroundColor: _background,
        child: SafeArea(bottom: false, child: content),
      );
    }
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(bottom: false, child: content),
    );
  }
}

class _AnalysisHeader extends StatelessWidget {
  const _AnalysisHeader({required this.onShare});

  final Future<void> Function(BuildContext context) onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAE7E7))),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_rounded, color: _brand, size: 25),
          const Expanded(
            child: Center(
              child: Text(
                '갈래말래',
                style: TextStyle(
                  color: _brand,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ),
          Builder(
            builder: (buttonContext) => Semantics(
              label: '분석 결과 공유하기',
              button: true,
              child: IconButton(
                tooltip: '공유하기',
                visualDensity: VisualDensity.compact,
                onPressed: () => onShare(buttonContext),
                icon: const Icon(CupertinoIcons.share, color: _brand, size: 23),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FestivalHeading extends StatelessWidget {
  const _FestivalHeading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _Tag(label: 'Family-friendly', color: Color(0xFF2869E8)),
            _Tag(label: 'LIVE Data', color: Color(0xFF098966)),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '서울 불꽃 축제 2024',
          style: TextStyle(
            color: _ink,
            fontSize: 23,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '여의도 한강공원  |  10월 5일 토요일',
          style: TextStyle(
            color: _muted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.center,
        colors: [Color(0xFFFFE1D9), Colors.white],
      ),
      child: Column(
        children: [
          const Text(
            '오늘의 갈래? 말래?',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 116,
            height: 116,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _brand, width: 7),
            ),
            child: const Text(
              '갈래!',
              style: TextStyle(
                color: _brand,
                fontSize: 31,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 17),
          const Text(
            '현재 혼잡도가 완화되고 있으며,\n오후 6시 이후 자리가 빠르게 소진될 것으로 보여요.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => context.go('/map'),
              style: FilledButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text(
                '지금 출발하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrowdScoreCard extends StatelessWidget {
  const _CrowdScoreCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '실시간 혼잡 점수',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _ScoreBadge(),
            ],
          ),
          SizedBox(height: 15),
          _CrowdGauge(),
          SizedBox(height: 17),
          _MetricLine(
            icon: Icons.groups_rounded,
            iconColor: Color(0xFF008768),
            text: '예상 방문객: 12,500명',
          ),
          SizedBox(height: 10),
          _MetricLine(
            icon: Icons.trending_down_rounded,
            iconColor: _brand,
            text: '전 시간대비 15% 감소 중',
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Text(
        '42',
        style: TextStyle(
          color: Color(0xFF003D34),
          fontSize: 36,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CrowdGauge extends StatelessWidget {
  const _CrowdGauge();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final markerX = constraints.maxWidth * .42;
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 11,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_green, Color(0xFFF4D936), _orange],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Positioned(
                    left: markerX - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _brand, width: 4),
                        boxShadow: const [
                          BoxShadow(color: Color(0x22000000), blurRadius: 3),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 3),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('쾌적함', style: TextStyle(color: _muted, fontSize: 11)),
            Text('매우 붐빔', style: TextStyle(color: _muted, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 21),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
          Text(trailing!, style: const TextStyle(color: _muted, fontSize: 12)),
      ],
    );
  }
}

class _ForecastCard extends StatelessWidget {
  const _ForecastCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      padding: EdgeInsets.fromLTRB(12, 22, 12, 12),
      child: SizedBox(
        height: 205,
        child: CustomPaint(painter: _ForecastPainter()),
      ),
    );
  }
}

class _ForecastPainter extends CustomPainter {
  const _ForecastPainter();

  static const values = [.25, .42, .60, .78, .92, .78];
  static const colors = [
    Color(0xFFCEE4DE),
    Color(0xFF91C3B5),
    Color(0xFFE7C7B9),
    Color(0xFFD48B6A),
    _brand,
    Color(0xFFC86438),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = const Color(0xFFECECEF);
    for (var i = 0; i < 4; i++) {
      final y = 10 + i * 45.0;
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), grid);
    }
    const gap = 6.0;
    final barWidth = (size.width - gap * 5) / 6;
    const baseY = 170.0;
    for (var i = 0; i < values.length; i++) {
      final height = 145 * values[i];
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(i * (barWidth + gap), baseY - height, barWidth, height),
        topLeft: const Radius.circular(7),
        topRight: const Radius.circular(7),
      );
      canvas.drawRRect(rect, Paint()..color = colors[i]);
      if (i == 4) {
        canvas.drawRRect(
          rect.inflate(3),
          Paint()
            ..color = _brand
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        final label = TextPainter(
          text: const TextSpan(
            text: '피크',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final labelRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(rect.center.dx, 5),
            width: 38,
            height: 19,
          ),
          const Radius.circular(4),
        );
        canvas.drawRRect(labelRect, Paint()..color = _brand);
        label.paint(canvas, Offset(labelRect.center.dx - label.width / 2, -1));
      }
    }
    const labels = ['10:00', '14:00', '18:00', '20:00'];
    for (var i = 0; i < labels.length; i++) {
      final painter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: _muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = i * (size.width - painter.width) / 3;
      painter.paint(canvas, Offset(x, 184));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VisitorAnalysisCard extends StatelessWidget {
  const _VisitorAnalysisCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '방문객 분석',
            style: TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _GenderValue(label: '남성', value: '42%', color: _blue),
              ),
              SizedBox(
                height: 50,
                child: VerticalDivider(color: Color(0xFFF0C8BA)),
              ),
              Expanded(
                child: _GenderValue(label: '여성', value: '58%', color: _brand),
              ),
            ],
          ),
          SizedBox(height: 20),
          _AgeBar(label: '20대', value: .65, color: _orange),
          SizedBox(height: 10),
          _AgeBar(label: '30대', value: .45, color: Color(0xFFF39A7E)),
        ],
      ),
    );
  }
}

class _GenderValue extends StatelessWidget {
  const _GenderValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AgeBar extends StatelessWidget {
  const _AgeBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: value,
              color: color,
              backgroundColor: const Color(0xFFECECEF),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 32,
          child: Text(
            '${(value * 100).round()}%',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _AiDetailCard extends StatelessWidget {
  const _AiDetailCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_alt_outlined, color: _brand, size: 24),
              SizedBox(width: 8),
              Text(
                'AI 예측 분석 상세',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            '과거 3개년 동기간 누적 데이터와 실시간 유동인구,\nSNS 트렌드를 종합 분석한 결과입니다.',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
          ),
          SizedBox(height: 18),
          _AnalysisRow(label: '과거 방문 패턴', value: '92% 높은 일치'),
          SizedBox(height: 14),
          _AnalysisRow(
            label: '실시간 SNS 반응',
            value: '85% 긍정',
            valueColor: _brand,
          ),
          SizedBox(height: 14),
          _AnalysisRow(label: '기상 상황', value: '맑음 (변동성 낮음)'),
        ],
      ),
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  const _AnalysisRow({
    required this.label,
    required this.value,
    this.valueColor = _muted,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TransportCard extends StatelessWidget {
  const _TransportCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '교통 및 주차',
            style: TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 15),
          _TransportItem(
            icon: Icons.local_parking_rounded,
            iconColor: _brand,
            title: '여의도 3주차장',
            subtitle: '잔여 5면 | 대기 시간 약 30분',
            status: '만차 임박',
          ),
          SizedBox(height: 10),
          _TransportItem(
            icon: Icons.train_rounded,
            iconColor: _blue,
            title: '5호선 여의나루역',
            subtitle: '무정차 통과 가능성 있음 (18:00~)',
            status: '다소 혼잡',
          ),
        ],
      ),
    );
  }
}

class _TransportItem extends StatelessWidget {
  const _TransportItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: const TextStyle(
              color: _orange,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaMapCard extends StatelessWidget {
  const _AreaMapCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _MiniMapPainter()),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xB3000000)],
                ),
              ),
            ),
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: _brand, size: 43),
                  Text(
                    '여의도',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 17,
              right: 17,
              bottom: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '여의도 일대 교통 지도',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '터치하여 실시간 상세 교통 정보 확인',
                    style: TextStyle(color: Color(0xFFDADADA), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  const _MiniMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFDDE8E1),
    );
    final water = Path()
      ..moveTo(0, size.height * .65)
      ..cubicTo(
        size.width * .25,
        size.height * .35,
        size.width * .6,
        size.height * .9,
        size.width,
        size.height * .48,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFFA9D7E5));
    final random = math.Random(8);
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    final minorPaint = Paint()
      ..color = const Color(0xFFACC5B7)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 12; i++) {
      final start = Offset(-20, random.nextDouble() * size.height);
      final end = Offset(size.width + 20, random.nextDouble() * size.height);
      canvas.drawLine(start, end, i.isEven ? roadPaint : minorPaint);
    }
    canvas.drawCircle(
      Offset(size.width * .72, size.height * .22),
      26,
      Paint()..color = const Color(0xFF8FCAA6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}
