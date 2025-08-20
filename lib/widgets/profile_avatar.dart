import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileAvatar extends HookConsumerWidget {
  const ProfileAvatar({super.key, this.size = 20});
  final double? size;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) => CircleAvatar(
        radius: size,
        backgroundImage: profile.imageUrl != null
            ? CachedNetworkImageProvider(profile.imageUrl!)
            : null,
        child: profile.imageUrl == null
            ? const Icon(CupertinoIcons.person_fill, color: AppTheme.accent)
            : null,
      ),
      error: (error, stackTrace) {
        return CircleAvatar(
          radius: size,
          backgroundColor: AppTheme.accent,
          child: Icon(CupertinoIcons.person_fill, color: AppTheme.accent),
        );
      },
      loading: () {
        return CircleAvatar(
          radius: size,
          backgroundColor: AppTheme.accent,
          child: Icon(CupertinoIcons.person_fill, color: AppTheme.accent),
        );
      },
    );
  }
}
