import 'dart:async';
import 'dart:developer';

import 'package:tron_stake/domain/services/check_platform_service.dart';
import 'package:tron_stake/domain/services/telegram_service.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class AppsflyerService {
  static Future<void> init() async {
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: 'xSY2KUfocRDwFL3UUpv3pM',
      appId: isIOS ? 'betting.tips.livescore' : 'livescore.betting.tips',
      showDebug: true,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
      appInviteOneLink: 'oneLinkID', // Optional field
      disableAdvertisingIdentifier: false, // Optional field
      disableCollectASA: false, //Optional field
      manualStart: true,
    ); // Optional field

    String notification = '';
    AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    await appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    appsflyerSdk.onInstallConversionData((res) {
      final String r = 'onInstallConversionData: $res';
      notification = '$notification\n\n$r';
      log(r);
    });
    appsflyerSdk.onAppOpenAttribution((res) {
      final String r = 'onAppOpenAttribution: $res';
      notification = '$notification\n\n$r';
      log(r);
    });
    appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          final String r = 'deep link value: ${dp.deepLink?.deepLinkValue}';
          notification = '$notification\n\n$r';
          log(r);
          break;
        case Status.NOT_FOUND:
          const String r = 'deep link not found';
          notification = '$notification\n\n$r';
          log(r);
          break;
        case Status.ERROR:
          final String r = 'deep link error: ${dp.error}';
          notification = '$notification\n\n$r';
          log(r);
          break;
        case Status.PARSE_ERROR:
          const String r = 'deep link status parsing error';
          notification = '$notification\n\n$r';
          log(r);
          break;
      }
    });

    try {
      notification = 'Открыл приложение\n\n$notification';
      await TelegramService.sendManualNotification(notification,
          eventType: EventType.appOpened);
      log('Уведомление успешно отправлено');
    } catch (e) {
      log('Ошибка при отправке уведомления: $e');
    }
  }
}
