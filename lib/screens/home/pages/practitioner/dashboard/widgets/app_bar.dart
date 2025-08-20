import 'package:ayur_scoliosis_management/providers/auth/auth.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/app_router.dart';
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../providers/dio/dio.dart';
import '../../../../../../services/storage/secure_storage_service_impl.dart';
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
                ProfileAvatar(),
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
            onPressed: () async {
              ///TODO: Remove this test code
              await SecureStorageService.instance.deleteAll();
              ref.invalidate(dioProvider);
              ref.invalidate(authProvider);
              if (context.mounted) context.pushReplacement(AppRouter.login);
            },
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
