import 'package:ayur_scoliosis_management/providers/page/active_page.dart';
import 'package:ayur_scoliosis_management/providers/page/page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(pageProvider);
    return Scaffold(
      body: pages[ref.watch(activePageProvider)].page,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: ref.read(activePageProvider.notifier).setActivePage,
        currentIndex: ref.watch(activePageProvider),
        items: pages
            .map(
              (page) => BottomNavigationBarItem(
                icon: Icon(page.icon),
                label: page.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
