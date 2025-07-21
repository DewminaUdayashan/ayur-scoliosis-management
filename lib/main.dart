import 'package:ayur_scoliosis_management/core/router.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpineAlign Ayur Scoliosis Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.data,
      routerConfig: AppRouter.routes,
    );
  }
}
