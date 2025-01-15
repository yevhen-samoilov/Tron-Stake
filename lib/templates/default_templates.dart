import 'package:tron_stake/presentation/widgets/error_visible_widget.dart';
import 'package:tron_stake/presentation/widgets/info_visible_widget.dart';
import 'package:flutter/material.dart';
import 'package:tron_stake/presentation/controllers/loading_controller.dart';
import 'package:tron_stake/presentation/widgets/loading_visible_widget.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:provider/provider.dart';

class DefaultTemplates extends StatelessWidget {
  const DefaultTemplates(
      {super.key,
      required this.body,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.isScroll = true});
  final Widget body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    final loadingController = context.watch<LoadingController>();
    final visibleLoading = loadingController.visibleLoading;
    final visibleError = loadingController.visibleError;
    final visibleInfo = loadingController.visibleInfo;

    return Stack(
      children: [
        _Body(
            body: body,
            bottomNavigationBar: bottomNavigationBar,
            backgroundColor: backgroundColor,
            isScroll: isScroll),
        Visibility(
          visible: visibleLoading,
          child: const LoadingVisibleWidget(),
        ),
        Visibility(
          visible: visibleError,
          child: const ErrorVisibleWidget(),
        ),
        Visibility(
          visible: visibleInfo,
          child: const InfoVisibleWidget(),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(
      {required this.body,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.isScroll = true});
  final Widget body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    // final revenueController = context.read<RevenueController>();
    // final userController = context.watch<UserController>();
    // final initController = context.watch<InitController>();
    // final authController = context.watch<AuthController>();

    // final predictionController = context.read<PredictionController>();
    // final listPredictionPurchased = userController.listPredictionPurchased;
    // final showWelcome = initController.showWelcome;
    // final showAuth = authController.showAuth;
    // final isPremium = revenueController.isPremium;

    // DateTime? lastUpdate;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // floatingActionButton: (showWelcome == ShowWelcome.noshow &&
      //         showAuth == ShowAuth.noshow)
      //     ? Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(right: 16),
      //             child: ClickButton(
      //               onTap: () async {

      //               },
      //               borderRadius: 13,
      //               border: Border.all(
      //                 color: ThemesColors.warning,
      //                 width: 3,
      //               ),
      //               color: Colors.transparent,
      //               child: ClipRRect(
      //                 borderRadius: BorderRadius.circular(10),
      //                 child: ColorNoPulseAnimationWidget(
      //                   child: SizedBox(
      //                     height: 50,
      //                     child: Container(
      //                       margin: const EdgeInsets.symmetric(horizontal: 16),
      //                       child: Row(
      //                         crossAxisAlignment: CrossAxisAlignment.center,
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         children: [
      //                           Container(
      //                             margin: const EdgeInsets.only(right: 4),
      //                             padding: const EdgeInsets.symmetric(
      //                                 horizontal: 4, vertical: 0),
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(3),
      //                                 color: ThemesColors.warning),
      //                             child: Text(
      //                               'AI',
      //                               style: ThemesFonts.smallBold(
      //                                   color: ThemesColors.black),
      //                             ),
      //                           ),
      //                           Text(
      //                             'Accumulators',
      //                             style: ThemesFonts.smallBold(
      //                                 color: ThemesColors.white),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),

      //         ],
      //       )
      //     : null,
      backgroundColor: backgroundColor ?? ThemesColors.background,
      body: isScroll ? SingleChildScrollView(child: body) : body,

      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
