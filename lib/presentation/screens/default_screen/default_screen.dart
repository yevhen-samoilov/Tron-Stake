import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/presentation/controllers/init_controller.dart';
import 'package:tron_stake/presentation/controllers/loading_controller.dart';
import 'package:tron_stake/presentation/screens/auth_screens/screens/auth_screen.dart';
import 'package:tron_stake/presentation/screens/home_screen/home_screen.dart';
import 'package:tron_stake/presentation/screens/loading_screen/loading_screen.dart';
import 'package:tron_stake/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:tron_stake/presentation/widgets/error_visible_widget.dart';
import 'package:tron_stake/presentation/widgets/info_visible_widget.dart';
import 'package:tron_stake/presentation/widgets/loading_visible_widget.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BodyScreen();
  }
}

class _BodyScreen extends StatelessWidget {
  const _BodyScreen();

  @override
  Widget build(BuildContext context) {
    final initController = context.watch<InitController>();
    final walletProvider = context.watch<WalletProvider>();

    final showWelcome = initController.showWelcome;
    final showAuth = walletProvider.showAuth;
    if (showWelcome == ShowWelcome.wait || showAuth == ShowAuth.wait) {
      return const LoadingScreen();
    }

    if (showWelcome == ShowWelcome.show) {
      return const WelcomeScreen();
    }

    if (showAuth == ShowAuth.show) {
      return const AuthScreen();
    }

    // Используем context.read, чтобы избежать лишних перерисовок
    final loadingController = context.watch<LoadingController>();
    final visibleLoading = loadingController.visibleLoading;
    final visibleError = loadingController.visibleError;
    final visibleInfo = loadingController.visibleInfo;

    return Stack(
      children: [
        const HomeScreen(),
        Visibility(
          visible: visibleLoading,
          child: const LoadingVisibleWidget(),
        ),
        Visibility(
          visible: visibleError,
          child: const ErrorVisibleWidget(),
        ),
        Visibility(
          visible: visibleInfo,
          child: const InfoVisibleWidget(),
        ),
      ],
    );
  }
}
