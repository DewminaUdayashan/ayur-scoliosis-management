import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/xray/xray.dart';
import 'package:ayur_scoliosis_management/widgets/sliver_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatientDocumentsTab extends HookConsumerWidget {
  const PatientDocumentsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xRaysAsync = ref.watch(xRayProvider);

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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  Api.baseUrl + xRay.imageUrl,
                  fit: BoxFit.cover,
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
