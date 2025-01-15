import 'dart:async';
import 'package:tron_stake/domain/mixin/log_mixin.dart';
import 'package:flutter/material.dart';
import 'package:tron_stake/data/local/services/database_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

enum ShowWelcome { wait, show, noshow }

class InitController extends ChangeNotifier with LoggingMixin {
  InitController() {
    logCreation();
    initState();
  }
  void initState() => init();

  ShowWelcome _showWelcome = ShowWelcome.wait;

  ShowWelcome get showWelcome => _showWelcome;

  set setShowWelcome(ShowWelcome s) {
    _showWelcome = s;
    notifyListeners();
  }

  Future<void> skip() async {
    await DataBaseService.save('welcome', {'welcome': true});
    setShowWelcome = ShowWelcome.noshow;
  }

  

  Future<void> init() async {
    final bool isWelcome = await DataBaseService.check('welcome');
    if (isWelcome) {
      setShowWelcome = ShowWelcome.noshow;
    } else {
      setShowWelcome = ShowWelcome.show;
      FlutterNativeSplash.remove();
    }
  }
}
