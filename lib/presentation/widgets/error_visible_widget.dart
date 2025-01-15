import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tron_stake/presentation/controllers/loading_controller.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:provider/provider.dart';

class ErrorVisibleWidget extends StatelessWidget {
  const ErrorVisibleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loadingController = context.watch<LoadingController>();
    final String errorTitle = loadingController.titleError;
    final String errorDescription = loadingController.descriptionError;
    return Material(
      color: Colors.transparent,
      child: Container(
        color: ThemesColors.error.withOpacity(.7),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 250, minWidth: 250),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: ThemesColors.background.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: Text(
                          errorTitle,
                          style: ThemesFonts.titleMedium(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(errorDescription,
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
