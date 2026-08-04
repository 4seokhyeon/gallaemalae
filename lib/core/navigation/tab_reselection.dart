import 'package:flutter/widgets.dart';

class TabReselectionEvent extends ChangeNotifier {
  TabReselectionEvent._();
  static final instance = TabReselectionEvent._();

  int? _index;
  int? get index => _index;

  void notify(int index) {
    _index = index;
    notifyListeners();
  }
}

class ReselectableTabScrollView extends StatefulWidget {
  const ReselectableTabScrollView({
    required this.tabIndex,
    required this.builder,
    super.key,
  });

  final int tabIndex;
  final Widget Function(ScrollController controller) builder;

  @override
  State<ReselectableTabScrollView> createState() =>
      _ReselectableTabScrollViewState();
}

class _ReselectableTabScrollViewState extends State<ReselectableTabScrollView> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    TabReselectionEvent.instance.addListener(_handleReselection);
  }

  void _handleReselection() {
    if (TabReselectionEvent.instance.index != widget.tabIndex ||
        !_controller.hasClients ||
        _controller.offset <= _controller.position.minScrollExtent) {
      return;
    }
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    TabReselectionEvent.instance.removeListener(_handleReselection);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_controller);
}
