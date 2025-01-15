import 'dart:developer';

mixin LoggingMixin {
  void logCreation() {
    log('${runtimeType.toString()} создан');
  }
}
