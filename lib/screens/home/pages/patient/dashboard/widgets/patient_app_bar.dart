import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/widgets/default_app_bar.dart';
import 'package:ayur_scoliosis_management/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class PatientAppBar extends HookConsumerWidget {
  const PatientAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    return SliverAppBar(
      backgroundColor: Colors.white,
      title: profileAsync.when(
        data: (profile) => Row(
          children: [
            ProfileAvatar(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  profile.firstName,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Badge.count(
                count: 3, // Example notification count
                child: const Icon(
                  Icons.notifications,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
        error: (_, _) => DefaultAppBar(isPatient: true),
        loading: () =>
            const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
      ),
      floating: true,
      snap: true,
      pinned: true,
    );
  }
}
