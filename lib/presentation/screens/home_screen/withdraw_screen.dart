import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class WithdrawWidget extends StatelessWidget {
  const WithdrawWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Withdraw(),
        _ActionButton(),
      ],
    );
  }
}

class _Withdraw extends StatelessWidget {
  const _Withdraw();

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final reward = walletProvider.reward / 1000000; // Конвертация в TRX

    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemesColors.grey,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ThemesColors.grey,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Withdraw',
                      style: ThemesFonts.headlineMedium(),
                    ),
                    Text(
                      'Withdraw TRX to your wallet',
                      style: ThemesFonts.small(),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available rewards', style: ThemesFonts.small()),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemesColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemesColors.background,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rewards', style: ThemesFonts.bodyMedium()),
                      Text(
                        '${reward.toStringAsFixed(6)} TRX',
                        style:
                            ThemesFonts.bodyMedium(color: ThemesColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final wallet = walletProvider.wallet;
    final rewardInTrx = walletProvider.reward / 1000000; // Конвертация в TRX

    // Проверяем все условия
    bool isEnabled = false;
    String buttonText = 'No rewards';
    if (wallet != null) {
      if (rewardInTrx <= 0) {
        buttonText = 'No rewards';
      } else if (rewardInTrx < 1) {
        buttonText = 'Minimum 1 TRX';
      } else {
        isEnabled = true;
        buttonText = 'Claim ${rewardInTrx.toStringAsFixed(6)} TRX';
      }
    }

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () async {
                await walletProvider.withdraw();
              }
            : null,
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
          buttonText,
          style: ThemesFonts.bodyMedium(color: ThemesColors.white),
        ),
      ),
    );
  }
}
