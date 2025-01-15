import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class SendTrxWidget extends StatefulWidget {
  const SendTrxWidget({super.key});

  @override
  State<SendTrxWidget> createState() => _SendTrxWidgetState();
}

class _SendTrxWidgetState extends State<SendTrxWidget> {
  final addressController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final wallet = walletProvider.wallet;

    if (wallet == null) return Container();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Send TRX', style: ThemesFonts.headlineMedium()),
                const Spacer(),
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
            SizedBox(height: 24),
            Text('Recipient Address', style: ThemesFonts.small()),
            TextField(
              controller: addressController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter TRX address',
                hintStyle: ThemesFonts.bodyMedium(color: ThemesColors.grey),
                suffixStyle:
                    ThemesFonts.bodyMedium(color: ThemesColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemesColors.onBackground),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text('Amount', style: ThemesFonts.small()),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isEmpty) {
                  walletProvider.calculateResources(0);
                  walletProvider.setStakeAmount(0);
                } else {
                  try {
                    final amount = double.parse(value);
                    walletProvider.calculateResources(amount);
                    walletProvider.setStakeAmount(amount);
                  } catch (e) {
                    walletProvider.calculateResources(0);
                    walletProvider.setStakeAmount(0);
                  }
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: ThemesFonts.bodyMedium(color: ThemesColors.grey),
                suffixStyle:
                    ThemesFonts.bodyMedium(color: ThemesColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemesColors.onBackground),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (walletProvider.wallet != null) {
                      amountController.text = wallet.balance.toString();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Max',
                          style: ThemesFonts.bodyMedium(
                              color: ThemesColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            _ActionButton(
              addressController: addressController,
              amountController: amountController,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController amountController;

  const _ActionButton({
    required this.addressController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final wallet = walletProvider.wallet;
    final amount = double.tryParse(amountController.text) ?? 0;

    // Проверяем все условия
    bool isEnabled = false;
    String buttonText = 'Continue';

    if (wallet != null) {
      if (addressController.text.isEmpty) {
        buttonText = 'Enter address';
      } else if (amount <= 0) {
        buttonText = 'Enter amount';
      } else if (amount > wallet.balance) {
        buttonText = 'Insufficient Balance';
      } else {
        isEnabled = true;
        buttonText = 'Send ${amount.toStringAsFixed(6)} TRX';
      }
    } else {
      buttonText = 'Wallet not connected';
    }

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () async {
                await walletProvider.sendTrx(
                  toAddress: addressController.text,
                  amount: amount,
                );
                Nav.navigationService.goBack();
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
