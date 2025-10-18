import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/page/active_page.dart';
import '../../providers/page/page.dart';
import '../../widgets/video_call_floating_indicator.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(pageProvider);
    return Scaffold(
      body: Stack(
        children: [
          pages[ref.watch(activePageProvider)].page,
          // Floating indicator for active video calls
          const VideoCallFloatingIndicator(),
        ],
      ),
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
