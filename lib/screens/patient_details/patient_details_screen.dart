import 'dart:io';

import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/providers/auth/auth.dart';
import 'package:ayur_scoliosis_management/providers/patient/patient_details.dart';
import 'package:ayur_scoliosis_management/providers/xray/xray.dart';
import 'package:ayur_scoliosis_management/screens/patient_details/widgets/patient_profile_name.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/size.dart';
import '../../core/extensions/size.dart';
import '../../core/extensions/widgets.dart';
import '../../core/theme.dart';
import '../../widgets/patient_profile_avatar.dart';
import '../../widgets/sliver_sized_box.dart';
import 'widgets/patient_documents_tab.dart';
import 'widgets/patient_profile_tab.dart';
import 'widgets/patient_timeline_tab.dart';

class PatientDetailsScreen extends HookConsumerWidget {
  const PatientDetailsScreen({super.key, required this.patientId});
  final String patientId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final tabController = useTabController(initialLength: 3);
    final activeTab = useState(0);
    final patientAsync = ref.watch(patientDetailsProvider(patientId));
    final patient = patientAsync.valueOrNull;

    useEffect(() {
      void listener() {
        if (tabController.indexIsChanging) {
          activeTab.value = tabController.index;
        }
      }

      tabController.addListener(listener);
      return () {
        tabController.removeListener(listener);
      };
    }, []);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: context.height * 0.25,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (patient?.isPatient == true)
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  tooltip: 'Logout',
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                  },
                ),
            ],
            // This title will appear automatically when the app bar collapses.
            title: PatientProfileName(id: patientId),
            centerTitle: true,
            pinned: true, // Keeps the app bar and TabBar visible
            floating: true,
            snap: true,
            // The flexibleSpace should only contain the background content.
            flexibleSpace: patientAsync.when(
              data: (patient) => FlexibleSpaceBar(
                title: PatientProfileName(id: patientId),
                titlePadding: const EdgeInsets.only(bottom: 50),
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PatientProfileAvatar(size: 70, url: patient.imageUrl),
                    const SizedBox(height: 8),
                    Text(
                      'Joined : ${patient.joinedDate.yMMMMd}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (patient.lastAppointmentDate != null)
                      Text(
                        'Last Visit: ${patient.lastAppointmentDate!.readableTimeAndDate}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),

                    // Add padding at the bottom to create space above the TabBar.
                    const SizedBox(height: 90),
                  ],
                ),
              ),
              error: (error, _) => FlexibleSpaceBar(),
              loading: () => FlexibleSpaceBar(),
            ),

            bottom: TabBar(
              controller: tabController,
              indicatorColor: AppTheme.accent,
              labelColor: AppTheme.accent,
              unselectedLabelColor: AppTheme.textSecondary,
              tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Timeline'),
                Tab(text: 'Documents'),
              ],
            ),
          ),
          if (activeTab.value == 0)
            PatientProfileTab(id: patientId).sliverToBoxAdapter,
          if (activeTab.value == 1) ...[
            SliverSizedBox(height: 20),
            PatientTimelineTab(),
            SliverSizedBox(
              height: context.bottomPadding + 20,
            ), // Space at the bottom
          ],
          if (activeTab.value == 2) ...[
            SliverSizedBox(height: 20),
            Padding(
              padding: horizontalPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'X-Ray Images',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 100),
                  Expanded(
                    child: PrimaryButton(
                      backgroundColor: AppTheme.accent,
                      label: 'Upload',
                      isLoading: isLoading.value,
                      onPressed: () async {
                        isLoading.value = true;
                        try {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image == null) return;
                          await ref
                              .read(xRayProvider.notifier)
                              .uploadXray(File(image.path));
                        } finally {
                          isLoading.value = false;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ).sliverToBoxAdapter,
            SliverSizedBox(height: 20),
            PatientDocumentsTab(),
            SliverSizedBox(
              height: context.bottomPadding + 20,
            ), // Space at the bottom
          ],
        ],
      ),
    );
  }
}
