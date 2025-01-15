import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:tron_stake/data/local/services/database_local.dart';
import 'package:tron_stake/domain/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

import 'package:uuid/uuid.dart';

enum EventType {
  firstOpen('first_open'),
  pushOpened('push_opened'),
  sessionStarted('session_started'),
  sessionEnded('session_ended'),
  appOpened('app_opened'),
  subscriptionError('subscription_error'),
  subscriptionClicked('subscription_clicked'),
  subscriptionCancelled('subscription_cancelled'),
  subscriptionPurchased('subscription_purchased');

  final String value;
  const EventType(this.value);

  @override
  String toString() => value;
}

class TelegramService {
  static const List<String> botTokens = [
    '7194346850:AAEURR_cp0_S8WULQHw3qBR1tlxmAYt6qAQ',
    '8054330350:AAEBkEdM2VXxDvqOLq0B46jH0-iwQmDaYjY',
    '7089266324:AAFANRBMS7iN8xlEEZzC52RjlPQMy2BkGjk'
  ];

  static const String chatId = '5441126857';
  static const String chatNId = '-1002390205272';

  static Future<String> _getOrCreateTempUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? tempUserId = prefs.getString('temp_user_id');

    if (tempUserId == null) {
      // Создаем новый временный ID
      tempUserId = 'temp_${const Uuid().v4()}';
      await prefs.setString('temp_user_id', tempUserId);
    }

    return tempUserId;
  }

  static Future<String> getUserID() async {
    // Проверяем наличие постоянного ID
    if (await DataBaseService.check('userID')) {
      final u = await DataBaseService.read('userID');
      final id = u['id'];
      return '$id';
    }

    // Если постоянного ID нет, используем или создаем временный ID
    return await _getOrCreateTempUserId();
  }

  // Отправка уведомления об ошибке
  static Future<void> sendErrorNotification(String message) async {
    try {
      final userID = await getUserID();

      await _sendNotification(
        {
          'chat_id': chatId,
          'text': "User ID: $userID\n\nError: $message",
        },
      );
      // log('Telegram: ${res.body}');
    } catch (e) {
      // Обработка ошибок при отправке сообщения
      log('sendErrorNotification Ошибка при отправке уведомления в Telegram: $e');
    }
  }

  // Отправка уведомления Telegram
  static Future<void> _sendNotification(Map<String, String> body) async {
    for (String token in botTokens) {
      final url = 'https://api.telegram.org/bot$token/sendMessage';
      try {
        final response = await http.post(
          Uri.parse(url),
          body: body,
        );
        if (response.statusCode == 200) {
          log('Уведомление успешно отправлено с токеном');
          return; // Успешно отправлено, выходим из функции
        } else {
          log('Ошибка при отправке уведомления с токеном ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        log('Ошибка при отправке уведомления с токеном $e');
      }
    }
    log('Не удалось отправить уведомление ни с одним из токенов');
  }

  // Отправка ручного уведомления

  static Future<void> sendManualNotification(String message,
      {EventType? eventType}) async {
    try {
      final isPremium = await DataBaseService.getPremiumStatus();
      final userID = await getUserID();
      final isFirstLaunch = await isFirstAppLaunch();
      final subscriptionStatus = isPremium ? '✅' : '❌';
      final deviceInfo = await getDeviceInfo();
      final networkInfo = await getNetworkInfo();
      final localeInfo = getUserLocaleInfo();
      final appVersion = await getAppVersion();
      final m = message.isNotEmpty ? message : '';
      final timestamp = DateTime.now().toUtc();
      final isPushOpening = eventType == EventType.pushOpened;

      final country = localeInfo['country'] ?? 'Unknown';

      final analyticsMessage = '''
🔔 *Уведомление о действии пользователя* 🔔

👤 *Информация о пользователе:*
• ID: `$userID`
• Первый запуск: ${isFirstLaunch == '✅' ? '🆕' : '🔄'}
• Статус подписки: ${subscriptionStatus == '✅' ? '💎' : '🆓'}
• Push-уведомления: ${'❌'}

📱 *Информация об устройстве:*
• Устройство: ${deviceInfo['type']} ${deviceInfo['version']}
• Сеть: ${networkInfo == 'WiFi' ? '📶' : '📡'} $networkInfo
• Версия приложения: `$appVersion`

🌍 *Локализация:*
• Язык: ${localeInfo['language']?.toUpperCase() ?? 'Unknown'}
• Страна: $country ${_getFlagEmoji(country)}

📝 *Сообщение:*
$m

⏰ _${timestamp.toString()}_
''';

      // Отправка события в AnalyticsService
      if (eventType != null) {
        await AnalyticsService.sendEvent(
            isFirstLaunch == '✅' ? 'first_open' : eventType.value, {
          'userId': userID,
          'isFirstLaunch': isFirstLaunch == '✅',
          'isPushEnabled': '❌',
          'subscriptionStatus':
              subscriptionStatus == '✅' ? 'subscribed' : 'not_subscribed',
          'deviceType': deviceInfo['type'],
          'deviceVersion': deviceInfo['version'],
          'networkType': networkInfo,
          'appVersion': appVersion,
          'language': localeInfo['language'],
          'country': country,
          'message': m,
          'isPushOpening': isPushOpening,
          'timestamp': timestamp.toIso8601String(),
        });
      }

      await _sendNotification(
        {
          'chat_id': chatNId,
          'text': analyticsMessage,
          'parse_mode': 'Markdown',
          'disable_notification': eventType == EventType.sessionStarted ||
                  eventType == EventType.sessionEnded
              ? 'true'
              : 'false',
        },
      );
    } catch (e) {
      log('sendManualNotification Ошибка при отправке уведомления в Telegram: $e');
    }
  }

  static Future<void> updateUserId(String permanentId) async {
    final String oldId = await _getOrCreateTempUserId();
    await DataBaseService.save('userID', {'id': permanentId});

    // Удаляем временный ID, если он существовал
    final prefs = await SharedPreferences.getInstance();
    final hadTempId = await prefs.remove('temp_user_id');

    // Отправляем событие об обновлении ID
    await sendManualNotification(
        'Новый пользователь зарегистрирован успешно!\nID пользователя обновлен:\nСтарый ID: $oldId\nНовый ID: $permanentId');

    // Отправляем событие в аналитику
    await AnalyticsService.sendEvent('user_id_updated', {
      'oldId': oldId,
      'newId': permanentId,
      'hadTempId': hadTempId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static String _getFlagEmoji(String countryCode) {
    // Преобразование кода страны в эмодзи флага
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  static Future<String> isFirstAppLaunch() async {
    const key = 'first_launch';
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(key) ?? true;
    if (isFirstLaunch) {
      await prefs.setBool(key, false);
    }
    return isFirstLaunch ? '✅' : '❌';
  }

  static Future<Map<String, String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return {
        'type': 'Android',
        'version': androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return {
        'type': 'iOS',
        'version': iosInfo.systemVersion,
      };
    }
    return {
      'type': 'Unknown',
      'version': 'Unknown',
    };
  }

  static Future<String> getNetworkInfo() async {
    final connectivity = Connectivity();
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return 'Mobile';
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else {
      return 'Unknown';
    }
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Map<String, String> getUserLocaleInfo() {
    final locale = PlatformDispatcher.instance.locale;
    return {
      'language': locale.languageCode,
      'country': locale.countryCode ?? 'Unknown',
    };
  }
}

class CheckError {
  static final TelegramService telegramService = TelegramService();

  static check() {
    // Переопределение обработчика ошибок Flutter
    FlutterError.onError = (FlutterErrorDetails details) async {
      // Вывод ошибки в консоль
      FlutterError.dumpErrorToConsole(details);

      // Отправка уведомления в Telegram
      await TelegramService.sendErrorNotification(
          'Flutter Error:\n${details.exceptionAsString()}\n'
          'StackTrace:\n${details.stack}\n'
          // 'User ID: ${userService.userID ?? 'неизвестный'}',
          );
    };
  }
}
