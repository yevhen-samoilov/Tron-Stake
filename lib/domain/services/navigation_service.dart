import 'package:tron_stake/domain/routes/routes_services.dart';
import 'package:tron_stake/domain/services/setup_service.dart';

class Nav {
  static NavigationService navigationService =
      SetupService().locator<NavigationService>();
}
