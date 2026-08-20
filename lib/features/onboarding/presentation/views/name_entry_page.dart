import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/features/onboarding/presentation/view_models/user_name_view_model.dart';
import 'package:go_router/go_router.dart';

class NameEntryPage extends ConsumerStatefulWidget {
  const NameEntryPage({super.key});

  @override
  ConsumerState<NameEntryPage> createState() => _NameEntryPageState();
}

class _NameEntryPageState extends ConsumerState<NameEntryPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(userNameProvider.notifier).save(_controller.text);
      if (mounted) context.go(AppRoutes.personalityTest);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F8FB),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.waving_hand_rounded,
                    size: 64,
                    color: Color(0xFFC93A06),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '어떻게 불러드릴까요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '이름만 입력하면 바로 축제 성향 테스트를 시작해요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF777079), height: 1.5),
                  ),
                  const SizedBox(height: 34),
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    maxLength: 20,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: '이름',
                      hintText: '예: 김지수',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '이름을 입력해 주세요.'
                        : null,
                    onFieldSubmitted: (_) => _saving ? null : _continue(),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _saving ? null : _continue,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: const Color(0xFFC93A06),
                    ),
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('성향 테스트 시작하기'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '입력한 이름은 기기에만 저장됩니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8A8488), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
