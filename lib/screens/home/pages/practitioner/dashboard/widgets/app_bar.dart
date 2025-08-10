import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../widgets/default_app_bar.dart';

class PractitionerAppBar extends HookConsumerWidget {
  const PractitionerAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    return SliverAppBar(
      backgroundColor: Colors.white,
      title: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profileAsync.when(
            data: (profile) => Row(
              spacing: 8,
              children: [
                CircleAvatar(
                  backgroundImage: profile.imageUrl != null
                      ? CachedNetworkImageProvider(profile.imageUrl!)
                      : null,
                  child: profile.imageUrl == null
                      ? const Icon(
                          CupertinoIcons.person_fill,
                          color: AppTheme.accent,
                        )
                      : null,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'SpineCare Clinic',
                      style: context.textTheme.bodySmall,
                    ),
                    Text(
                      'Dr. John Doe',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            error: (_, _) => DefaultAppBar(),
            loading: () =>
                const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Badge.count(
              count: 2,
              child: Icon(Icons.notifications, color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
      floating: true,
      snap: true,
      pinned: true,
    );
  }
}
