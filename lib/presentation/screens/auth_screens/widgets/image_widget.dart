import 'package:flutter/material.dart';
import 'package:tron_stake/constants/image_constants.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Image.asset(ImageConstants.twoOnboarding,
        width: width > 350 ? 300 : double.infinity);
  }
}
