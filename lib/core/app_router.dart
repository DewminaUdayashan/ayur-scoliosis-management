import 'package:ayur_scoliosis_management/screens/auth/login_screen.dart';
import 'package:ayur_scoliosis_management/screens/auth/otp_verification_screen.dart';
import 'package:ayur_scoliosis_management/screens/home/home_screen.dart';
import 'package:ayur_scoliosis_management/screens/patient_details/patient_details_screen.dart';
import 'package:ayur_scoliosis_management/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart' show NavigatorState, GlobalKey;
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const splash = '/';

  static const login = '/login';
  static const otpVerification = '/otp-verification';

  static const home = '/home';

  static const patientDetails = '$home/patients/patient-details';
  static const _patientDetailsPath = 'patients/patient-details';

  static final routes = GoRouter(
    initialLocation: home,
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
        path: otpVerification,
        builder: (context, state) {
          return const OtpVerificationScreen();
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: _patientDetailsPath,
            builder: (context, state) {
              final id = (state.extra as Map?)?['id'];
              return PatientDetailsScreen(patientId: id);
            },
          ),
        ],
      ),
    ],
  );
}
