import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/routes/routes_services.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/l10n/local.dart';
import 'package:tron_stake/presentation/screens/auth_screens/controllers/auth_controller.dart';
import 'package:tron_stake/presentation/screens/auth_screens/widgets/image_widget.dart';
import 'package:tron_stake/presentation/screens/default_screen/default_screen.dart';
import 'package:tron_stake/presentation/widgets/policy_revenue_widget.dart';
import 'package:tron_stake/templates/default_templates.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BodyScreen();
  }
}

class _BodyScreen extends StatelessWidget {
  const _BodyScreen();

  @override
  Widget build(BuildContext context) {
    return const DefaultTemplates(
      isScroll: false,
      body: SafeArea(
        left: false,
        right: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final walletProvider = context.watch<WalletProvider>();

    final localizations = S.string(context);

    final showAuth = walletProvider.showAuth;
    if (showAuth == ShowAuth.noshow) return const DefaultScreen();
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            const ImageWidget(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                localizations.signUp001,
                style: ThemesFonts.headlineMedium(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                localizations.signUp002,
                style: ThemesFonts.small(),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CupertinoButton.filled(
                onPressed: () async {
                  await authController.signUp(context, walletProvider);
                },
                child: Center(
                  child: Text(
                    localizations.signUpB001,
                    textAlign: TextAlign.center,
                    style: ThemesFonts.bodyMedium(color: ThemesColors.white),
                  ),
                ),
              ),
            ),
            CupertinoButton(
              color: Colors.transparent,
              onPressed: () async =>
                  await Nav.navigationService.navigateTo(signInScreen),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localizations.signUpB002,
                      textAlign: TextAlign.center,
                      style: ThemesFonts.smallBold(color: ThemesColors.black),
                    ),
                    Text(
                      localizations.signUpB003,
                      textAlign: TextAlign.center,
                      style: ThemesFonts.smallBold(
                        color: ThemesColors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
            const PolicyRevenueWidget(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
