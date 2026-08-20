import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/visit.dart';
import 'package:gallaemalae/features/analysis/presentation/view_models/analysis_view_model.dart';
import 'package:gallaemalae/features/visits/presentation/view_models/visit_plans_view_model.dart';
import 'package:go_router/go_router.dart';

class VisitPlansPage extends ConsumerWidget {
  const VisitPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(visitPlansProvider);
    final body = plans.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _Message(text: '방문 일정을 불러오지 못했어요.'),
      data: (items) {
        if (items.isEmpty) {
          return const _Message(text: '저장한 방문 일정이 없어요.\n축제 상세에서 방문일을 선택해 보세요.');
        }
        final sorted = [...items]
          ..sort((a, b) => a.visitedAt.compareTo(b.visitedAt));
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          itemCount: sorted.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _PlanCard(
            plan: sorted[index],
            onAnalyze: () => _openAnalysis(context, ref, sorted[index]),
            onChangeDate: () => _changeDate(context, ref, sorted[index]),
            onDelete: () => _delete(context, ref, sorted[index]),
          ),
        );
      },
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('방문 일정')),
        child: SafeArea(bottom: false, child: body),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('방문 일정')),
      body: body,
    );
  }

  Future<void> _openAnalysis(
    BuildContext context,
    WidgetRef ref,
    Visit plan,
  ) async {
    await ref
        .read(userActivityRepositoryProvider)
        .writeSetting(
          analysisSelectionSettingKey,
          jsonEncode({
            'festivalId': int.parse(plan.placeId),
            'visitDate': _apiDate(plan.visitedAt),
          }),
        );
    ref.invalidate(analysisViewModelProvider);
    if (context.mounted) context.go(AppRoutes.analysis);
  }

  Future<void> _changeDate(
    BuildContext context,
    WidgetRef ref,
    Visit plan,
  ) async {
    final festivalId = int.tryParse(plan.placeId);
    if (festivalId == null) return;
    final FestivalDetail festival;
    try {
      festival = await ref
          .read(festivalRepositoryProvider)
          .getDetail(festivalId);
    } catch (_) {
      if (context.mounted) {
        await _showMessage(context, '축제 정보를 불러오지 못했어요.');
      }
      return;
    }
    if (!context.mounted) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(
      festival.startDate.year,
      festival.startDate.month,
      festival.startDate.day,
    );
    final end = DateTime(
      festival.endDate.year,
      festival.endDate.month,
      festival.endDate.day,
    );
    final firstDate = today.isAfter(start) ? today : start;
    if (firstDate.isAfter(end)) {
      await _showMessage(context, '종료된 축제는 방문 날짜를 변경할 수 없어요.');
      return;
    }
    final current =
        plan.visitedAt.isBefore(firstDate) || plan.visitedAt.isAfter(end)
        ? firstDate
        : plan.visitedAt;
    final selected = await _pickDate(context, current, firstDate, end);
    if (selected == null) return;
    await ref
        .read(visitPlansControllerProvider.notifier)
        .save(
          festival: festival,
          visitDate: selected,
          crowdScore: plan.crowdLevel,
        );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Visit plan) async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('방문 일정 취소'),
        content: Text('${plan.placeName} 일정을 취소할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('유지'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('일정 취소'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(visitPlansControllerProvider.notifier)
          .remove(int.parse(plan.placeId));
    }
  }

  Future<void> _showMessage(BuildContext context, String message) {
    return showAdaptiveDialog<void>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDate(
    BuildContext context,
    DateTime initial,
    DateTime first,
    DateTime last,
  ) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: first,
        lastDate: last,
        helpText: '변경할 방문 예정일',
      );
    }
    var selected = initial;
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (popupContext) => Container(
        height: 330,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: Column(
          children: [
            SizedBox(
              height: 260,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initial,
                minimumDate: first,
                maximumDate: last.add(const Duration(hours: 23)),
                onDateTimeChanged: (value) => selected = value,
              ),
            ),
            CupertinoButton(
              onPressed: () => Navigator.pop(popupContext, selected),
              child: const Text('날짜 변경'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.onAnalyze,
    required this.onChangeDate,
    required this.onDelete,
  });
  final Visit plan;
  final VoidCallback onAnalyze;
  final VoidCallback onChangeDate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isPast = plan.visitedAt.isBefore(today);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.placeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Chip(label: Text(isPast ? '지난 일정' : '방문 예정')),
              ],
            ),
            Text('${_displayDate(plan.visitedAt)} · 예상 혼잡 ${plan.crowdLevel}점'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onDelete, child: const Text('일정 취소')),
                TextButton(onPressed: onChangeDate, child: const Text('날짜 변경')),
                FilledButton.tonal(
                  onPressed: onAnalyze,
                  child: const Text('분석 보기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}

String _apiDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

String _displayDate(DateTime date) =>
    '${date.year}.${date.month.toString().padLeft(2, '0')}.'
    '${date.day.toString().padLeft(2, '0')}';
