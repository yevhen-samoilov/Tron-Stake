import 'package:flutter/cupertino.dart';
import 'package:tron_stake/l10n/local.dart';
import 'package:tron_stake/presentation/controllers/init_controller.dart';
import 'package:tron_stake/presentation/screens/welcome_screen/controller/welcome_controller.dart';
import 'package:tron_stake/presentation/screens/welcome_screen/models/onboarding_model.dart';
import 'package:tron_stake/presentation/screens/welcome_screen/widgets/item_onboarding.dart';
import 'package:tron_stake/templates/default_templates.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BodyScreen();
  }
}

class _BodyScreen extends StatelessWidget {
  const _BodyScreen();

  @override
  Widget build(BuildContext context) {
    final localizations = S.string(context);
    final welcomeController = context.watch<WelcomeController>();
    final initController = context.watch<InitController>();
    final initialPage = welcomeController.initialPage;
    final List<OnboardingModel> listOnboarding =
        welcomeController.listOnboarding(localizations);

    return DefaultTemplates(
      isScroll: false,
      body: const _Body(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: _DotsList(),
          ),
          SizedBox(
            width: double.infinity,
            child: BottomAppBar(
              child: CupertinoButton.filled(
                onPressed: () async {
                  if (listOnboarding.length == initialPage + 1) {
                    await initController.skip();
                    return;
                  }
                  await welcomeController.controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: Text(listOnboarding[initialPage].button),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final localizations = S.string(context);
    final welcomeController = context.watch<WelcomeController>();
    final initialPage = welcomeController.initialPage;
    final List<OnboardingModel> listOnboarding =
        welcomeController.listOnboarding(localizations);
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Stack(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: _Skip(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: SizedBox(
            height: height - 200,
            child: PageView.builder(
              pageSnapping: false,
              physics: const NeverScrollableScrollPhysics(),
              controller: welcomeController.controller,
              itemCount: listOnboarding.length,
              itemBuilder: (context, index) {
                context.read<WelcomeController>().setIndex = index;
                return ItemOnboarding(
                    model: listOnboarding[index], index: initialPage);
              },
            ),
          ),
        ),
      ],
    ));
  }
}

class _DotsList extends StatelessWidget {
  const _DotsList();

  @override
  Widget build(BuildContext context) {
    final WelcomeController welcomeController = context.watch();
    final initialPage = welcomeController.initialPage;
    return SizedBox(
      height: 15,
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: index == initialPage
                    ? ThemesColors.primary
                    : ThemesColors.black,
              ),
              color: index == initialPage
                  ? ThemesColors.primary
                  : Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}

class _Skip extends StatelessWidget {
  const _Skip();

  @override
  Widget build(BuildContext context) {
    final localizations = S.string(context);
    final initController = context.watch<InitController>();

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: CupertinoButton(
            onPressed: () async {
              await initController.skip();
            },
            color: ThemesColors.white.withOpacity(0.5),
            child: Text(
              localizations.welcomeB003,
              style: ThemesFonts.bodyMedium(
                  color: ThemesColors.black.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}
