import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, this.body, this.appBarTitle});
  final Widget? body;
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: appBarTitle != null ? Text(appBarTitle!) : null,
      ),
      body: body,
    );
  }
}
