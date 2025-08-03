import 'package:ayur_scoliosis_management/screens/appointment_details/appointment_details_screen.dart';
import 'package:ayur_scoliosis_management/screens/auth/registration_screen.dart';
import 'package:flutter/material.dart' show NavigatorState, GlobalKey;
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/patient_details/patient_details_screen.dart';
import '../screens/splash/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const splash = '/';

  static const login = '/login';
  static const registration = '/registration';
  static const otpVerification = '/otp-verification';

  static const home = '/home';

  static const patientDetails = '$home/patients/patient-details';
  static const _patientDetailsPath = 'patients/patient-details';

  static const appointmentDetails = '$home/appointment-details';
  static const _appointmentDetailsPath = 'appointment-details';

  static final routes = GoRouter(
    initialLocation: login,
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
        path: registration,
        builder: (context, state) {
          return const PractitionerRegistrationScreen();
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
          GoRoute(
            path: _appointmentDetailsPath,
            builder: (context, state) {
              final id = (state.extra as Map?)?['id'];
              return AppointmentDetailsScreen(appointmentId: id);
            },
          ),
        ],
      ),
    ],
  );
}
