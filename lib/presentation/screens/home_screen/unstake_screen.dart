import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class UnstakeWidget extends StatelessWidget {
  const UnstakeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 235),
      children: [
        _Unstake(),
        _ActionButton(),
        _InfoSection(),
      ],
    );
  }
}

class _Unstake extends StatelessWidget {
  const _Unstake();

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final chechBlance =
        walletProvider.energyLimit > 0 || walletProvider.netLimit > 0;

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
              border: chechBlance
                  ? Border(
                      bottom: BorderSide(
                        color: ThemesColors.grey,
                        width: 2,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Unstake',
                      style: ThemesFonts.headlineMedium(),
                    ),
                    Text(
                      'Unstake TRX to your wallet',
                      style: ThemesFonts.small(),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),

          _RewardsSection(),
          _StakeSection(),
          // _ValidatorSection(),
        ],
      ),
    );
  }
}

class _RewardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final energyLimit = walletProvider.energyLimit;
    final netLimit = walletProvider.netLimit;
    final frozenBalances = walletProvider.frozenBalances;

    // Получаем балансы для каждого типа
    double energyBalance = 0;
    double bandwidthBalance = 0;

    for (var frozen in frozenBalances) {
      final type = frozen['type'] ?? 'BANDWIDTH';
      final amount = (frozen['amount'] as int?) ?? 0;
      final amountInTrx = amount / 1000000;

      if (type == 'ENERGY') {
        energyBalance = amountInTrx;
      } else if (type == 'BANDWIDTH') {
        bandwidthBalance = amountInTrx;
      }
    }
    final chechBlance = energyLimit > 0 || netLimit > 0;
    if (!chechBlance) return Container();
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rewards in', style: ThemesFonts.small()),
          if (energyLimit > 0)
            _ResourceCard(
              icon: Icons.rocket_launch,
              title: 'Energy',
              subtitle:
                  '${energyBalance.toStringAsFixed(0)} TRX (${energyLimit.toStringAsFixed(0)} E)',
              isEnergy: true,
              rIn: RewardsIn.energy,
            ),
          if (netLimit > 0)
            _ResourceCard(
              icon: Icons.directions_car,
              title: 'Bandwidth',
              subtitle:
                  '${bandwidthBalance.toStringAsFixed(0)} TRX (${netLimit.toStringAsFixed(0)} B)',
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
              onChanged: (r) => walletProvider.toggleRewardsIn(),
            ),
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
    // final frozenBalances = walletProvider.frozenBalances;
    final chechBlance =
        walletProvider.energyLimit > 0 || walletProvider.netLimit > 0;
    if (!chechBlance) return Container();
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Frozen Balances', style: ThemesFonts.small()),
          // ...frozenBalances.map((frozen) {
          //   final type = frozen['type'] ?? 'BANDWIDTH';
          //   final amount = (frozen['amount'] as int?) ?? 0;
          //   final amountInTrx = amount / 1000000;
          //   if (amountInTrx == 0) {
          //     return Container();
          //   }
          //   return Container(
          //     margin: EdgeInsets.symmetric(vertical: 4),
          //     padding: EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: ThemesColors.grey),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(type, style: ThemesFonts.bodyMedium()),
          //         Text('${amountInTrx.toStringAsFixed(2)} TRX',
          //             style: ThemesFonts.bodyMedium()),
          //       ],
          //     ),
          //   );
          // }),
          Text('Amount to unstake', style: ThemesFonts.small()),
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
              // suffixText: 'Max',
              hintStyle: ThemesFonts.bodyMedium(color: ThemesColors.grey),
              suffixStyle: ThemesFonts.bodyMedium(color: ThemesColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ThemesColors.onBackground),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  walletProvider.setMaxUnstakeAmount();
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

// class _ValidatorSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final walletProvider = context.watch<WalletProvider>();

//     final selectedWitness = walletProvider.selectedWitness;
//     if (selectedWitness == null) return Container();
//     return Container(
//       padding: EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Validator', style: ThemesFonts.small()),
//           GestureDetector(
//             onTap: () async {
//               _showWitnessSelector(context);
//             },
//             child: Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: ThemesColors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: ThemesColors.primary,
//                     child: Text(
//                         selectedWitness.name!.substring(0, 1).toUpperCase(),
//                         style:
//                             ThemesFonts.bodyMedium(color: ThemesColors.white)),
//                   ),
//                   SizedBox(width: 8),
//                   Text('${selectedWitness.name}',
//                       style: ThemesFonts.bodyMedium()),
//                   Spacer(),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                           '${num.parse(selectedWitness.annualizedRate!).toStringAsFixed(2)}% APR',
//                           style: ThemesFonts.bodyMedium(
//                               color: ThemesColors.primary)),
//                       Text('Fee ${100 - selectedWitness.lowestBrokerage!}%',
//                           style:
//                               ThemesFonts.small(color: ThemesColors.primary)),
//                     ],
//                   ),
//                   Icon(Icons.chevron_right, color: ThemesColors.grey),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showWitnessSelector(BuildContext context) {
//     final walletProvider = context.read<WalletProvider>();

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: ThemesColors.surface,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.symmetric(vertical: 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Select Validator',
//                 style: ThemesFonts.bodyMediumBold(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: walletProvider.witnesses.length,
//                 itemBuilder: (context, index) {
//                   final witness = walletProvider.witnesses[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: ThemesColors.primary,
//                       child: Text(
//                         witness.name!.substring(0, 1).toUpperCase(),
//                         style:
//                             ThemesFonts.bodyMedium(color: ThemesColors.white),
//                       ),
//                     ),
//                     title: Text(
//                       witness.name!,
//                       style: ThemesFonts.bodyMedium(),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     subtitle: Text(
//                       witness.url!,
//                       style: ThemesFonts.small(color: ThemesColors.grey),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                             '${num.parse(witness.annualizedRate!).toStringAsFixed(2)}% APR',
//                             style: ThemesFonts.bodyMedium(
//                                 color: ThemesColors.primary)),
//                         Text('Fee ${witness.brokerage!}%',
//                             style:
//                                 ThemesFonts.small(color: ThemesColors.primary)),
//                       ],
//                     ),
//                     onTap: () {
//                       walletProvider.setSelectedWitness = witness;
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                Text('• Rewards earning stops immediately after you unstake.',
                    style: ThemesFonts.small(color: ThemesColors.warning)),
                Text('• Funds will be available in ~ 14 days.',
                    style: ThemesFonts.small(color: ThemesColors.warning)),
              ],
            ),
          ),
          Icon(Icons.warning, color: ThemesColors.warning),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final stakeAmount = walletProvider.stakeAmount;

    // Проверяем все условия
    bool isEnabled = false;
    String buttonText = 'Continue';

    if (walletProvider.frozenBalances.isNotEmpty) {
      final selectedTypeBalance = walletProvider.getSelectedTypeBalance();
      if (stakeAmount <= 0) {
        buttonText = 'Enter amount';
      } else if (stakeAmount > selectedTypeBalance) {
        buttonText = 'Insufficient Balance';
      } else {
        isEnabled = true;
        buttonText = 'Unstake ${stakeAmount.toStringAsFixed(2)} TRX';
      }
    } else {
      buttonText = 'No frozen balance';
    }

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () async {
                await walletProvider.unstake();
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
