import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/providers/xray/xray.dart';
import 'package:ayur_scoliosis_management/widgets/sliver_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatientDocumentsTab extends HookConsumerWidget {
  const PatientDocumentsTab({super.key, required this.patientId});
  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).valueOrNull;

    final xRaysAsync = ref.watch(
      xRayProvider(
        patientId: profile?.isPractitioner == true ? patientId : null,
      ),
    );

    return xRaysAsync.when(
      data: (data) {
        final xRays = data
            .map((page) => page.data)
            .toList()
            .expand((x) => x)
            .toList();
        return SliverGrid.builder(
          // We use NeverScrollableScrollPhysics because the parent is a SingleChildScrollView.
          // This makes the grid expand to its full height.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 0, // Horizontal space between items
            mainAxisSpacing: 16, // Vertical space between items
            childAspectRatio: 1.0, // Make items square
          ),
          itemCount: xRays.length,
          itemBuilder: (context, index) {
            final xRay = xRays[index];
            return InkWell(
              onTap: () => context.push(
                AppRouter.measurementTool,
                extra: {'xray': xRay, 'readOnly': profile?.isPatient},
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    Api.baseUrl + xRay.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
      error: (_, _) => SliverSizedBox(),
      loading: () => SliverSizedBox(),
    );
  }
}
