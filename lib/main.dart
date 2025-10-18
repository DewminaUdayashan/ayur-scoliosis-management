import 'package:ayur_scoliosis_management/core/utils/logger.dart';
import 'package:ayur_scoliosis_management/widgets/app_layout_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/app_router.dart';
import 'core/theme.dart';

void main() {
  Log.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
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
      builder: (context, child) {
        // Wrap all screens with the layout wrapper that includes
        // global UI elements like the video call floating indicator
        return Builder(
          builder: (context) {
            return AppLayoutWrapper(child: child ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
