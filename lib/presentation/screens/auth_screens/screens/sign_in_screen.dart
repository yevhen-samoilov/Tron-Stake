import 'package:flutter/cupertino.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/presentation/screens/default_screen/default_screen.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/l10n/local.dart';
import 'package:tron_stake/presentation/screens/auth_screens/controllers/auth_controller.dart';
import 'package:tron_stake/presentation/screens/auth_screens/widgets/image_widget.dart';
import 'package:tron_stake/presentation/widgets/policy_revenue_widget.dart';
import 'package:tron_stake/templates/default_templates.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
      // isScroll: false,
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
                localizations.signIn001,
                style: ThemesFonts.headlineMedium(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                localizations.signIn002,
                style: ThemesFonts.small(),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: authController.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CupertinoTextField(
                      // fillColor: ThemesColors.white,
                      controller: authController.login,
                      placeholder: localizations.signIn003,
                      textInputAction: TextInputAction.done,
                      // validator: (value) => mnemonicValidator(value),
                      onEditingComplete: () async =>
                          await authController.signIn(context, walletProvider),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CupertinoButton.filled(
                      onPressed: () async =>
                          await authController.signIn(context, walletProvider),
                      child: Center(
                        child: Text(
                          localizations.signInB001,
                          textAlign: TextAlign.center,
                          style:
                              ThemesFonts.bodyMedium(color: ThemesColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CupertinoButton(
                color: ThemesColors.error.withOpacity(.7),
                onPressed: () => Nav.navigationService.goBack(),
                child: Center(
                  child: Text(
                    localizations.signInB002,
                    textAlign: TextAlign.center,
                    style: ThemesFonts.bodyMedium(color: ThemesColors.white),
                  ),
                ),
              ),
            ),
            const PolicyRevenueWidget(),
          ],
        ),
      ),
    );
  }
}
