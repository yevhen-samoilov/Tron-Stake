import 'package:tron_stake/constants/url_constants.dart';
import 'package:tron_stake/l10n/local.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyRevenueWidget extends StatelessWidget {
  const PolicyRevenueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.string(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, bottom: 18),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                    text: localizations.policy2,
                    style: ThemesFonts.smallX2(
                        decoration: TextDecoration.underline)),
                TextSpan(
                  text: localizations.policy6,
                  style:
                      ThemesFonts.smallX2(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrl(Uri.parse(UrlConstants.e));
                    },
                ),
                TextSpan(text: ' & ', style: ThemesFonts.smallX2()),
                TextSpan(
                  text: localizations.policy3,
                  style:
                      ThemesFonts.smallX2(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrl(Uri.parse(UrlConstants.terms));
                    },
                ),
                TextSpan(text: ' ', style: ThemesFonts.smallX2()),
                TextSpan(
                  text: localizations.policy4,
                  style:
                      ThemesFonts.smallX2(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrl(Uri.parse(UrlConstants.policy));
                    },
                ),
                TextSpan(
                    text: localizations.policy5, style: ThemesFonts.smallX2()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
