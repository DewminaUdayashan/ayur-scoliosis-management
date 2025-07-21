import 'package:ayur_scoliosis_management/screens/auth/login_screen.dart';
import 'package:ayur_scoliosis_management/screens/home/home_screen.dart';
import 'package:ayur_scoliosis_management/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart' show NavigatorState, GlobalKey;
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const splash = '/';

  static const login = '/login';

  static const home = '/home';

  static final routes = GoRouter(
    initialLocation: splash,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
