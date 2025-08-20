import 'package:ayur_scoliosis_management/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/app_router.dart';
import '../../../../../core/constants/size.dart';
import '../../../../../core/extensions/size.dart';
import '../../../../../core/extensions/theme.dart';
import '../../../../../core/extensions/widgets.dart';
import '../../../../../core/theme.dart';
import '../../../../../providers/patient/patients.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/patient_profile_avatar.dart';
import 'widgets/invite_patient_sheet.dart';

class PractitionerPatients extends HookConsumerWidget {
  const PractitionerPatients({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String?>(null);
    final patientsAsync = ref.watch(patientsProvider(searchQuery.value));
    final scrollController = useScrollController();
    final isLoadingMore = useState(false);

    // Pagination logic
    void loadMorePatients() async {
      if (isLoadingMore.value) return;

      final hasMore = ref
          .read(patientsProvider(searchQuery.value).notifier)
          .hasMore();
      if (hasMore) {
        isLoadingMore.value = true;
        try {
          await ref
              .read(patientsProvider(searchQuery.value).notifier)
              .loadMore(searchQuery.value);
        } catch (e) {
          // Handle error if needed
          debugPrint('Error loading more patients: $e');
        } finally {
          isLoadingMore.value = false;
        }
      }
    }

    // Scroll listener for pagination
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          loadMorePatients();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return SizedBox(
      width: context.width,
      height: context.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  centerTitle: false,
                  title: Text(
                    'Patients',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  floating: true,
                  snap: true,
                  pinned: true,
                ),
                Padding(
                  padding: horizontalPadding,
                  child: AppTextField(
                    hintText: 'Search patients...',
                    onChanged: (value) => searchQuery.value = value,
                  ),
                ).sliverToBoxAdapter,
                patientsAsync.when(
                  data: (data) {
                    final patients = data
                        .map((page) => page.data)
                        .toList()
                        .expand((x) => x)
                        .toList();
                    return SliverList.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return ListTile(
                          leading: PatientProfileAvatar(url: patient.imageUrl),
                          title: Text(patient.firstName),
                          subtitle: Text('Condition: '),
                          trailing: Text('Last Visit: '),
                          onTap: () => context.push(
                            AppRouter.patientDetails,
                            extra: {'id': patient.id},
                          ),
                        );
                      },
                    );
                  },
                  error: (e, _) => Center(
                    child: Text('Error loading patients $e'),
                  ).sliverToBoxAdapter,
                  loading: () => SliverList.builder(
                    itemCount: 5, // Show skeleton for 5 items
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Skeleton(
                        builder: (decoration) => Container(
                          decoration: decoration,
                          height: 72,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),

                // Loading indicator for pagination
                if (isLoadingMore.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),

                // Add some bottom padding for the FAB
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Important for keyboard handling
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: const InvitePatientSheet(),
                    );
                  },
                );
              },
              backgroundColor: AppTheme.accent,
              child: Icon(CupertinoIcons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
