import 'package:flutter/material.dart';
import 'package:tron_stake/presentation/widgets/loading_visible_widget.dart';
import 'package:tron_stake/templates/default_templates.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTemplates(
      isScroll: false,
      body: LoadingVisibleWidget(),
    );
  }
}
