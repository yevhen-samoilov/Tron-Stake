import 'dart:async';

import 'package:tron_stake/domain/mixin/log_mixin.dart';
import 'package:tron_stake/domain/services/telegram_service.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/presentation/controllers/loading_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:tron_stake/constants/string.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/domain/services/validators/validator_mnemonic.dart';
import 'package:tron_stake/l10n/local.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

enum TypeAuth { signup, signin }

class AuthController extends ChangeNotifier with LoggingMixin {
  AuthController(this.loadingController) {
    logCreation();
  }

  LoadingController loadingController;
  TypeAuth _typeAuth = TypeAuth.signup;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _login = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get login => _login;
  TypeAuth get typeAuth => _typeAuth;

  set setTypeAuth(TypeAuth t) {
    _typeAuth = t;
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context, WalletProvider walletProvider) async {
    if (_login.text.isEmpty) return;
    final mnemonic = _login.text;
    if (mnemonicValidator(mnemonic) != null) return;
    await disclaimer(context, walletProvider, mnemonic: mnemonic);
  }

  Future<void> signUp(
      BuildContext context, WalletProvider walletProvider) async {
    await disclaimer(context, walletProvider);
  }

  Future<void> disclaimer(BuildContext context, WalletProvider walletProvider,
      {String? mnemonic}) async {
    final localizations = S.string(context);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          localizations.s0003,
          style: ThemesFonts.smallBold(),
        ),
        message: Text(
          StringConstants.disclaimer,
          style: ThemesFonts.smallS(),
        ),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Nav.navigationService.goBack();
          },
          child: Text(
            localizations.s0002,
            style: ThemesFonts.bodyMedium(color: ThemesColors.error),
          ),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              Nav.navigationService.goBack();

              try {
                if (mnemonic == null) {
                  await walletProvider.createWallet();
                  return;
                } else {
                  await walletProvider.importWallet(mnemonic);
                }
              } catch (e) {
                await TelegramService.sendErrorNotification(
                    'Ошибка при авторизации (auth_controller.dart): \n\n$e');
              }
            },
            child: Text(
              localizations.welcomeB002,
              style: ThemesFonts.bodyMediumBold(color: ThemesColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
