import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tron_stake/presentation/controllers/loading_controller.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoVisibleWidget extends StatelessWidget {
  const InfoVisibleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loadingController = context.watch<LoadingController>();
    final String titleInfo = loadingController.titleInfo;
    return Material(
      color: Colors.transparent,
      child: Container(
        color: ThemesColors.background.withOpacity(.7),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200, minWidth: 250),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: ThemesColors.white.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(titleInfo,
                            style: ThemesFonts.bodyMedium(), maxLines: 3),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22.0),
                        child: CupertinoButton(
                          onPressed: () async =>
                              await loadingController.close(),
                          child: Text(
                            'Close',
                            style: ThemesFonts.small(
                                color: ThemesColors.background),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
