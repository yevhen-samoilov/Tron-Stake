import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/presentation/screens/home_screen/stake_screen.dart';
import 'package:tron_stake/presentation/screens/home_screen/unstake_screen.dart';
import 'package:tron_stake/presentation/screens/home_screen/withdraw_screen.dart';
import 'package:tron_stake/templates/default_templates.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    return DefaultTemplates(
      // isScroll: false,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<MenuItem>(
                  groupValue: walletProvider.menuItem,
                  onValueChanged: (value) async {
                    walletProvider.setMenuItem = value;
                  },
                  backgroundColor: ThemesColors.onPrimary,
                  children: const {
                    MenuItem.stake: Text('Stake', textAlign: TextAlign.center),
                    MenuItem.unstake:
                        Text('Unstake', textAlign: TextAlign.center),
                    MenuItem.withdraw:
                        Text('Withdraw', textAlign: TextAlign.center),
                  },
                ),
              ),
            ),
            if (walletProvider.menuItem == MenuItem.stake) StakeScreen(),
            if (walletProvider.menuItem == MenuItem.unstake) UnstakeWidget(),
            if (walletProvider.menuItem == MenuItem.withdraw) WithdrawWidget(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final wallet = walletProvider.wallet;
    if (wallet == null) return Container();
    final balance = wallet.balance;

    return Row(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: CupertinoSlidingSegmentedControl<bool>(
        //     thumbColor: walletProvider.isMainNet
        //         ? ThemesColors.white
        //         : ThemesColors.warning,
        //     groupValue: walletProvider.isMainNet,
        //     onValueChanged: (value) async {
        //       if (value != null) {
        //         walletProvider.switchNetwork(value);
        //       }
        //     },
        //     children: {
        //       true: Text('MainNet', style: ThemesFonts.smallS()),
        //       false: Text('TestNet', style: ThemesFonts.smallS()),
        //     },
        //   ),
        // ),
        Spacer(),
        GestureDetector(
          onTap: () async {
            await walletProvider.showMenu(context);
          },
          child: Container(
            height: 40,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemesColors.primary.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'TRX $balance',
                    style: ThemesFonts.smallBold(),
                  ),
                ),
                Container(
                  width: 40,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                          width: 3,
                          color: ThemesColors.black,
                        ),
                        right: BorderSide.none),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: ThemesColors.primary.withOpacity(0.1),
                  ),
                  child: Icon(
                    UniconsLine.wallet,
                    color: ThemesColors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
