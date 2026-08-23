import 'package:flutter_riverpod/flutter_riverpod.dart';

class FestivalRequestStatusController extends Notifier<bool> {
  @override
  bool build() => false;

  void setRetrying(bool value) => state = value;
}

final festivalRequestStatusProvider =
    NotifierProvider<FestivalRequestStatusController, bool>(
      FestivalRequestStatusController.new,
    );
