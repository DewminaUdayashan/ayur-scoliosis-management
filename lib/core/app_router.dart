import 'package:ayur_scoliosis_management/screens/appointment_details/appointment_details_screen.dart';
import 'package:ayur_scoliosis_management/screens/auth/new_password_screen.dart';
import 'package:ayur_scoliosis_management/screens/auth/registration_screen.dart';
import 'package:ayur_scoliosis_management/screens/measurement/measurement_tool.dart';
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
  static const newPassword = '$login/new-password';
  static const _newPasswordPath = 'new-password';
  static const registration = '/registration';
  static const otpVerification = '/otp-verification';

  static const home = '/home';

  static const patientDetails = '$home/patients/patient-details';
  static const _patientDetailsPath = 'patients/patient-details';

  static String appointmentDetails(String id) =>
      '$home/appointment-details/$id';
  static const _appointmentDetailsPath = 'appointment-details/:id';

  static const measurementTool = '/measurement-tool';

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
        routes: [
          GoRoute(
            path: _newPasswordPath,
            builder: (context, state) {
              return const NewPasswordScreen();
            },
          ),
        ],
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
              final id = state.pathParameters['id']!;
              return AppointmentDetailsScreen(appointmentId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: measurementTool,
        builder: (context, state) {
          final imageUrl = (state.extra as Map)['imageUrl'] as String;
          return CobbAngleToolScreen(
            imageUrl: imageUrl,
            // initialMeasurement: null,
            // onSave: (measurement) {
            //   // Handle the saved measurement
            // },
          );
        },
      ),
    ],
  );
}
