import 'package:tron_stake/constants/image_constants.dart';
import 'package:tron_stake/domain/mixin/log_mixin.dart';
import 'package:tron_stake/presentation/screens/welcome_screen/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeController extends ChangeNotifier with LoggingMixin {
  WelcomeController() {
    logCreation();
  }
  final PageController _controller = PageController();
  int _initialPage = 0;

  PageController get controller => _controller;
  int get initialPage => _initialPage;

  set setIndex(int i) {
    if (_initialPage == i) return;
    _initialPage = i;
    SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  List<OnboardingModel> listOnboarding(AppLocalizations localizations) => [
        OnboardingModel(
          title: localizations.welcome001,
          body: localizations.welcome002,
          button: localizations.welcomeB001,
          image: ImageConstants.oneOnboarding,
        ),
        OnboardingModel(
          title: localizations.welcome003,
          body: localizations.welcome004,
          button: localizations.welcomeB001,
          image: ImageConstants.twoOnboarding,
        ),
        OnboardingModel(
          title: localizations.welcome005,
          body: localizations.welcome006,
          button: localizations.welcomeB002,
          image: ImageConstants.threeOnboarding,
        ),
      ];
}
