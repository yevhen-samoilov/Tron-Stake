
import 'package:tron_stake/domain/routes/routing_data.dart';

extension StringExtensions on String {
  RoutingData get getRoutingData {
    Uri uriData = Uri.parse(this);
    return RoutingData(
        route: uriData.path, queryParameters: uriData.queryParameters);
  }
}