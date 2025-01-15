import 'dart:async';
import 'dart:developer';

import 'package:tron_stake/constants/url_constants.dart';
import 'package:tron_stake/domain/services/tron_service.dart';
import 'package:tron_stake/presentation/screens/auth_screens/controllers/auth_controller.dart';
import 'package:tron_stake/presentation/screens/default_screen/default_screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tron_stake/domain/services/setup_service.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tron_stake/domain/routes/routes_services.dart';
import 'package:tron_stake/domain/services/telegram_service.dart';
import 'package:tron_stake/l10n/l10n.dart';
import 'package:tron_stake/presentation/controllers/init_controller.dart';
import 'package:tron_stake/presentation/controllers/loading_controller.dart';
import 'package:tron_stake/presentation/screens/webview_screen/controller/webview_controller.dart';
import 'package:tron_stake/presentation/screens/welcome_screen/controller/welcome_controller.dart';
import 'package:tron_stake/themes/app_themes.dart';

bool isInit = false;
Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!isInit) {
      isInit = true;
      try {
        await _initializeTimeZones();
        bool setupSuccess = false;
        int attempts = 0;
        while (!setupSuccess && attempts < 3) {
          try {
            await SetupService().setupLocator();
            setupSuccess = true;
          } catch (e) {
            attempts++;
            await Future.delayed(Duration(milliseconds: 100 * attempts));
          }
        }
        if (!setupSuccess) {
          await TelegramService.sendErrorNotification(
              'Не удалось инициализировать SetupService после $attempts попыток');
          throw Exception(
              'Не удалось инициализировать SetupService после $attempts попыток');
        }
        setPathUrlStrategy();
      } catch (e) {
        log("Ошибка при инициализации: $e");
        await TelegramService.sendErrorNotification('Ошибка инициализации: $e');
      }
      OpenAI.baseUrl = UrlConstants.openai;
    }
    runApp(const _StartSession());
  }, (error, stackTrace) async {
    await TelegramService.sendErrorNotification('Unhandled Error:\n$error\n'
        'StackTrace:\n$stackTrace\n');
  });
}

Future<void> _initializeTimeZones() async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
}

bool isDev = false;

class _StartSession extends StatefulWidget {
  const _StartSession();

  @override
  State<_StartSession> createState() => _StartSessionState();
}

class _StartSessionState extends State<_StartSession>
    with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  void _sendSessionStartEvent(String message) async {
    try {
      await TelegramService.sendManualNotification('Начало сессии: $message',
          eventType: EventType.sessionStarted);
    } catch (e) {
      log('Ошибка при отправке события session_started: $e');
    }
  }

  void _sendSessionEndEvent(String message) async {
    try {
      await TelegramService.sendManualNotification('Сессия завершена: $message',
          eventType: EventType.sessionEnded);
    } catch (e) {
      log('Ошибка при отправке события session_ended: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sendSessionStartEvent('Start');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sendSessionEndEvent('Dispose');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('AppLifecycleState: $state');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if ((_lastLifecycleState == AppLifecycleState.resumed)) {
        _sendSessionEndEvent('Paused');
      }
    } else if (state == AppLifecycleState.resumed) {
      if ((_lastLifecycleState == AppLifecycleState.paused ||
          _lastLifecycleState == AppLifecycleState.detached ||
          _lastLifecycleState == AppLifecycleState.inactive ||
          _lastLifecycleState == AppLifecycleState.hidden)) {
        _sendSessionStartEvent('Resumed');
      }
    }
    _lastLifecycleState = state;
  }

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Добавляем проверку инициализации
    Future<bool> ensureInitialized() async {
      if (!SetupService().locator.isRegistered<NavigationService>()) {
        await SetupService().setupLocator();
      }
      return true;
    }

    return FutureBuilder<bool>(
      future: ensureInitialized(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Builder(
            builder: (context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<LoadingController>(
                      create: (_) => LoadingController()),
                  ChangeNotifierProvider<WalletProvider>(
                      create: (_) => WalletProvider()),
                ],
                child: Builder(
                  builder: (context) {
                    context.watch<WalletProvider>();
                    final loadingController =
                        context.watch<LoadingController>();
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<InitController>(
                            create: (_) => InitController()),
                      ],
                      child: Builder(
                        builder: (context) {
                          context.watch<InitController>();
                          return Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
                                child: MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<AuthController>(
                                        create: (_) =>
                                            AuthController(loadingController)),
                                    ChangeNotifierProvider<WelcomeController>(
                                        create: (_) => WelcomeController()),
                                    ChangeNotifierProvider<WebviewController>(
                                        create: (_) => WebviewController()),
                                  ],
                                  child: MaterialApp(
                                    debugShowCheckedModeBanner: false,
                                    onGenerateRoute: RouteService.generateRoute,
                                    initialRoute: defaultScreen,
                                    supportedLocales: L10n.all,
                                    localizationsDelegates: const [
                                      AppLocalizations.delegate,
                                      GlobalMaterialLocalizations.delegate,
                                      GlobalWidgetsLocalizations.delegate,
                                      GlobalCupertinoLocalizations.delegate,
                                    ],
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            textScaler:
                                                const TextScaler.linear(1.0)),
                                        child: child!,
                                      );
                                    },
                                    navigatorKey: SetupService()
                                        .locator<NavigationService>()
                                        .navigatorKey,
                                    theme: ThemesStyle.lightTheme(context),
                                    darkTheme: ThemesStyle.lightTheme(context),
                                    home: const DefaultScreen(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
