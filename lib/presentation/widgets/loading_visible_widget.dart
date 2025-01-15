import 'dart:ui';

import 'package:tron_stake/themes/theme_colors.dart';
import 'package:flutter/cupertino.dart';

class LoadingVisibleWidget extends StatelessWidget {
  const LoadingVisibleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: ThemesColors.background.withOpacity(0.8),
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemesColors.white.withOpacity(.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: ThemesColors.background.withOpacity(0.8),
                  child: const Center(child: CupertinoActivityIndicator()),
                ),
              ),
            ),
          ),
        ));
  }
}
