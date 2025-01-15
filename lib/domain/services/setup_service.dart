import 'package:tron_stake/domain/routes/routes_services.dart';
import 'package:tron_stake/domain/services/telegram_service.dart';
// import 'package:tron_stake/presentation/widgets/paywall_subscribe_widget.dart';
import 'package:get_it/get_it.dart';

class SetupService {
  final GetIt locator = GetIt.instance;
  static bool _isInitialized = false;

  Future<void> setupLocator() async {
    if (_isInitialized) return;

    try {
      if (!locator.isRegistered<NavigationService>()) {
        locator.registerLazySingleton(() => NavigationService());
      }
      _isInitialized = true;
    } catch (e) {
      await TelegramService.sendErrorNotification(
          'Ошибка при инициализации SetupService: $e');
      // Повторная попытка регистрации
      await Future.delayed(const Duration(milliseconds: 100));
      if (!locator.isRegistered<NavigationService>()) {
        locator.registerLazySingleton(() => NavigationService());
      }
    }
  }
}
