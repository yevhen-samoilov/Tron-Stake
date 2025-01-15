import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionProgress extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;

  const TransactionProgress({
    super.key,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final transactionTxId = walletProvider.transactionTxId;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: ThemesFonts.headlineMedium()),
                  if (isCompleted && title != 'Error' || title == 'Error')
                    const Spacer(),
                  if (isCompleted && title != 'Error' || title == 'Error')
                    GestureDetector(
                      onTap: () => Nav.navigationService.goBack(),
                      child: const Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: ThemesColors.black,
                        size: 32,
                      ),
                    ),
                ],
              ),
            ),
            if (!isCompleted)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (isCompleted && title != 'Error')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.check_circle, color: Colors.green, size: 48),
              ),
            if (title == 'Error')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.error, color: Colors.red, size: 48),
              ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: ThemesFonts.small(),
              textAlign: TextAlign.center,
            ),
            if (transactionTxId != null) ...[
              SizedBox(height: 16),
              Text('TX ID: $transactionTxId', style: ThemesFonts.small()),
              ElevatedButton(
                onPressed: () async {
                  await launchUrl(Uri.parse(
                      'https://tronscan.org/#/transaction/$transactionTxId'));
                },
                style: ElevatedButton.styleFrom(
                  overlayColor: ThemesColors.background,
                  textStyle: ThemesFonts.bodyMedium(color: ThemesColors.white),
                  backgroundColor: ThemesColors.primary,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View on TronScan',
                  style: ThemesFonts.bodyMedium(color: ThemesColors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
