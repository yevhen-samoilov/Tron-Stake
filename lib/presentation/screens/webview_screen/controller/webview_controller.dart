import 'package:tron_stake/domain/mixin/log_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewController extends ChangeNotifier with LoggingMixin {
  WebviewController() {
    logCreation();
  }
  final browser = MyChromeSafariBrowser();
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {}

  @override
  void onClosed() {}
}
