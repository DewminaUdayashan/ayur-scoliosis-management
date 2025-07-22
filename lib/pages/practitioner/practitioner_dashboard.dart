import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PractitionerDashboard extends HookConsumerWidget {
  const PractitionerDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Practitioner Dashboard'),
          floating: true,
          snap: true,
          pinned: true,
        ),
      ],
    );
  }
}
