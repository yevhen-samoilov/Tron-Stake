import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/presentation/widgets/transaction_progress.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class StakeScreen extends StatelessWidget {
  const StakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final chechBlance =
        walletProvider.energyLimit > 0 || walletProvider.netLimit > 0;

    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 235),
      children: [
        _Stake(),
        if (!chechBlance) _NoBalance(),
        _ActionButton(),
        _InfoSection(),
      ],
    );
  }
}

class _Stake extends StatelessWidget {
  const _Stake();

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    final selectedWitness = walletProvider.selectedWitness!;

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
                      'Stake',
                      style: ThemesFonts.headlineMedium(),
                    ),
                    Text(
                      'Stake TRX to earn rewards',
                      style: ThemesFonts.small(),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        '${num.parse(selectedWitness.annualizedRate!).toStringAsFixed(2)}%',
                        style: ThemesFonts.bodyMedium(
                            color: ThemesColors.primary)),
                    Row(
                      children: [
                        Text(
                          'APR ',
                          style: ThemesFonts.small(),
                        ),
                        Icon(
                          CupertinoIcons.question_circle,
                          size: 15,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _RewardsSection(),
          _StakeSection(),
          _ValidatorSection(),
        ],
      ),
    );
  }
}

class _RewardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    const energyPerUsdtTransfer = 121370; // 10000 TRX = 1 USDT transfer
    const bandwidthPerTrxTransfer = 272; // 10000 TRX = 57 TRX transfers

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rewards in', style: ThemesFonts.small()),
          _ResourceCard(
            icon: Icons.rocket_launch,
            title:
                '${walletProvider.calculatedEnergy.toStringAsFixed(0)} energy/day',
            subtitle:
                'Enough for about ${(walletProvider.calculatedEnergy / energyPerUsdtTransfer).toStringAsFixed(1)} USDT (TRC20) transfers',
            isEnergy: true,
            rIn: RewardsIn.energy,
          ),
          _ResourceCard(
            icon: Icons.directions_car,
            title:
                '${walletProvider.calculatedBandwidth.toStringAsFixed(0)} bandwidth/day',
            subtitle:
                'Enough for about ${(walletProvider.calculatedBandwidth / bandwidthPerTrxTransfer).toStringAsFixed(0)} TRX transfers',
            isEnergy: false,
            rIn: RewardsIn.bandwidth,
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isEnergy;
  final RewardsIn rIn;

  const _ResourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isEnergy,
    required this.rIn,
  });

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    return GestureDetector(
      onTap: () => walletProvider.toggleRewardsIn(),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ThemesColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ThemesColors.background,
              width: 1,
            )),
        child: Row(
          children: [
            Icon(icon, color: ThemesColors.black),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: ThemesFonts.small()),
                  Text(subtitle,
                      style: ThemesFonts.small(color: ThemesColors.grey)),
                ],
              ),
            ),
            Radio<RewardsIn>(
                activeColor: ThemesColors.primary,
                value: rIn,
                groupValue: walletProvider.rewardsIn,
                onChanged: (r) => walletProvider.setRewardsIn = r),
          ],
        ),
      ),
    );
  }
}

class _StakeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount to stake', style: ThemesFonts.small()),
          TextField(
            controller: walletProvider.controller,
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
              hintText: 'TRX Amount',
              hintStyle: ThemesFonts.bodyMedium(color: ThemesColors.grey),
              suffixStyle: ThemesFonts.bodyMedium(color: ThemesColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ThemesColors.onBackground),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  if (walletProvider.wallet != null) {
                    final maxAmount = walletProvider.wallet!.balance;
                    walletProvider.controller.text = maxAmount.toString();
                    walletProvider.calculateResources(maxAmount);
                    walletProvider.setStakeAmount(maxAmount);
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
                        style:
                            ThemesFonts.bodyMedium(color: ThemesColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidatorSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    final selectedWitness = walletProvider.selectedWitness;
    if (selectedWitness == null) return Container();
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Validator', style: ThemesFonts.small()),
          GestureDetector(
            onTap: () async {
              await _showWitnessSelector(context);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemesColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ThemesColors.primary,
                    child: Text(
                        selectedWitness.name!.substring(0, 1).toUpperCase(),
                        style:
                            ThemesFonts.bodyMedium(color: ThemesColors.white)),
                  ),
                  SizedBox(width: 8),
                  Text('${selectedWitness.name}',
                      style: ThemesFonts.bodyMedium()),
                  Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          '${num.parse(selectedWitness.annualizedRate!).toStringAsFixed(2)}% APR',
                          style: ThemesFonts.bodyMedium(
                              color: ThemesColors.primary)),
                      Text('Fee ${100 - selectedWitness.lowestBrokerage!}%',
                          style:
                              ThemesFonts.small(color: ThemesColors.primary)),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: ThemesColors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showWitnessSelector(BuildContext context) async {
    final walletProvider = context.read<WalletProvider>();

    await showBarModalBottomSheet(
      context: context,
      backgroundColor: ThemesColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Select Validator', style: ThemesFonts.headlineMedium()),
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
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: walletProvider.witnesses.length,
                itemBuilder: (context, index) {
                  final witness = walletProvider.witnesses[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ThemesColors.primary,
                      child: Text(
                        witness.name!.substring(0, 1).toUpperCase(),
                        style:
                            ThemesFonts.bodyMedium(color: ThemesColors.white),
                      ),
                    ),
                    title: Text(
                      witness.name!,
                      style: ThemesFonts.bodyMedium(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      witness.url!,
                      style: ThemesFonts.small(color: ThemesColors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            '${num.parse(witness.annualizedRate!).toStringAsFixed(2)}% APR',
                            style: ThemesFonts.bodyMedium(
                                color: ThemesColors.primary)),
                        Text('Fee ${witness.brokerage!}%',
                            style:
                                ThemesFonts.small(color: ThemesColors.primary)),
                      ],
                    ),
                    onTap: () {
                      walletProvider.setSelectedWitness = witness;
                      Nav.navigationService.goBack();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      decoration: BoxDecoration(
        color: ThemesColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('• Earning starts one day after staking.',
                    style: ThemesFonts.small(color: ThemesColors.warning)),
                Text('• Staked funds are accessible 14 days after unstaking.',
                    style: ThemesFonts.small(color: ThemesColors.warning)),
              ],
            ),
          ),
          // Spacer(),
          Icon(Icons.warning, color: ThemesColors.warning),
        ],
      ),
    );
  }
}

class _NoBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      decoration: BoxDecoration(
        color: ThemesColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('• No TRX balance.',
                    style: ThemesFonts.small(color: ThemesColors.error)),
                Text('• You need to Top Up TRX first.',
                    style: ThemesFonts.small(color: ThemesColors.error)),
              ],
            ),
          ),
          Icon(Icons.warning, color: ThemesColors.error),
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
    final stakeAmount = walletProvider.stakeAmount;

    // Проверяем все условия
    bool isEnabled = false;
    String buttonText = 'Continue';

    if (wallet != null && stakeAmount > 0) {
      if (stakeAmount > wallet.balance) {
        buttonText = 'Insufficient Balance';
      } else if (stakeAmount < 1) {
        // Минимальная сумма стейкинга
        buttonText = 'Minimum 1 TRX';
      } else {
        isEnabled = true;
      }
    }

    final chechBalance =
        walletProvider.energyLimit > 0 || walletProvider.netLimit > 0;
    if (!chechBalance) {
      buttonText = 'Top Up';
    }
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: ElevatedButton(
        onPressed: !chechBalance
            ? () async {
                await walletProvider.showMenu(context);
              }
            : isEnabled
                ? () async {
                    showBarModalBottomSheet(
                      context: context,
                      backgroundColor: ThemesColors.surface,
                      isDismissible: false,
                      enableDrag: false,
                      builder: (context) => Consumer<WalletProvider>(
                        builder: (context, provider, child) {
                          if (provider.transactionError != null) {
                            return TransactionProgress(
                              title: provider.transactionTitle,
                              subtitle: provider.transactionSubtitle,
                              isCompleted: true,
                            );
                          }

                          return TransactionProgress(
                            title: provider.transactionTitle,
                            subtitle: provider.transactionSubtitle,
                            isCompleted: provider.isTransactionCompleted,
                          );
                        },
                      ),
                    );

                    try {
                      await walletProvider.voteWitness();
                    } catch (e) {
                      // Ошибка уже обработана в провайдере
                    }
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
