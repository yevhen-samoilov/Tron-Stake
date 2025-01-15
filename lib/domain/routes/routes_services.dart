import 'package:tron_stake/presentation/screens/auth_screens/screens/sign_in_screen.dart';
import 'package:tron_stake/presentation/screens/default_screen/default_screen.dart';
import 'package:flutter/material.dart';
import 'package:tron_stake/domain/extensions/string_extensions.dart';
import 'package:tron_stake/presentation/screens/success_screen/success_screen.dart';

const String defaultScreen = '';
const String matchScreen = '/match';
const String signInScreen = '/signin';
const String successScreen = '/success';
const String cancelScreen = '/cancel';

class RouteService {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var routingData = settings.name!.getRoutingData;
    switch (routingData.route) {
      case defaultScreen:
        return _getPageRoute(const DefaultScreen(), settings);
      case cancelScreen:
        return _getPageRoute(const ErrorScreen(), settings);
      case signInScreen:
        return _getPageRoute(const SignInScreen(), settings);
      case successScreen:
        if (routingData['session_id'] == null) {
          return _getPageRoute(const ErrorScreen(), settings);
        }
        final sessionId = routingData['session_id'].toString();
        return _getPageRoute(SuccessScreen(sessionId: sessionId), settings);
      default:
        return _getPageRoute(const DefaultScreen(), settings);
    }
  }

  static PageRoute _getPageRoute(Widget child, RouteSettings settings) {
    return _FadeRoute(child: child, routeName: settings.name!);
  }

  // static Route<void> loginShowDialog(BuildContext context, Object? object) {
  //   return MaterialPageRoute<void>(
  //     builder: (context) => const LoginDialog(),
  //     fullscreenDialog: true,
  //   );
  // }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          transitionDuration: const Duration(milliseconds: 0),
          settings: RouteSettings(name: routeName),
          reverseTransitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(animation),
            // opacity: animation,
            child: child,
          ),
        );
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName,
      {Map<String, String>? queryParams}) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> navigateRemoveUntil(String routeName,
      {Map<String, String>? queryParams}) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }

    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
