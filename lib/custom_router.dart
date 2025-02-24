import 'package:flutter/material.dart';
import 'package:go_perak/screens/login_page.dart';
import 'package:go_perak/screens/splash_page.dart';

class CustomRouter {
  static const String splash = '/';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    //final query = uri.quesryParameters;

    switch (uri.path) {
      case splash:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
