import 'package:tron_stake/domain/routes/routes_services.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/l10n/local.dart';
import 'package:tron_stake/presentation/screens/loading_screen/loading_screen.dart';
import 'package:tron_stake/presentation/screens/success_screen/controller/success_v2_controller.dart';
import 'package:tron_stake/templates/default_templates.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, this.sessionId});
  final String? sessionId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<SuccessV2Controller>(
          create: (_) => SuccessV2Controller(sessionId)),
    ], child: const _BodyScreen());
  }
}

class _BodyScreen extends StatelessWidget {
  const _BodyScreen();

  @override
  Widget build(BuildContext context) {
    final successController = context.watch<SuccessV2Controller>();
    if (successController.statusPay == StatusPay.confirm) {
      return const ConfirmeScreen();
    }
    if (successController.statusPay == StatusPay.error) {
      return const ErrorScreen();
    }
    return const LoadingScreen();
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.string(context);
    return DefaultTemplates(
      body: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          const Icon(
            CupertinoIcons.clear,
            color: ThemesColors.error,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            localizations.success001,
            style: ThemesFonts.headlineMedium(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            localizations.success002,
            style: ThemesFonts.bodyMedium(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              const Spacer(),
              CupertinoButton(
                onPressed: () async => await Nav.navigationService
                    .navigateRemoveUntil(defaultScreen),
                child: Text(localizations.successB001,
                    style: ThemesFonts.bodyMedium()),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class ConfirmeScreen extends StatelessWidget {
  const ConfirmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.string(context);
    return DefaultTemplates(
      body: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled,
            color: ThemesColors.secondary,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            localizations.success003,
            style: ThemesFonts.headlineMedium(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            localizations.success004,
            style: ThemesFonts.bodyMedium(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              const Spacer(),
              CupertinoButton(
                onPressed: () async => await Nav.navigationService
                    .navigateRemoveUntil(defaultScreen),
                child: Text(localizations.successB001,
                    style: ThemesFonts.bodyMedium()),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
