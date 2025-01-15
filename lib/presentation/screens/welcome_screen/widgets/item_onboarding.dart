import 'package:tron_stake/presentation/screens/welcome_screen/models/onboarding_model.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:flutter/material.dart';

class ItemOnboarding extends StatelessWidget {
  const ItemOnboarding({
    super.key,
    required this.model,
    required this.index,
  });
  final OnboardingModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    final String title = model.title;
    final String body = model.body;
    final String image = model.image;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Image.asset(image, width: 200)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(title,
                style: ThemesFonts.headlineMedium(),
                textAlign: TextAlign.center),
          ),
          Text(body,
              style: ThemesFonts.bodyMedium(), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
