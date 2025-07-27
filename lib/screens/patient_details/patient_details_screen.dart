import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  final int patientId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final activeTab = useState(0);

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
            // This title will appear automatically when the app bar collapses.
            title: Text(
              'John Doe',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            pinned: true, // Keeps the app bar and TabBar visible
            floating: true,
            snap: true,
            // The flexibleSpace should only contain the background content.
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'John Doe',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              titlePadding: const EdgeInsets.only(bottom: 50),
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const PatientProfileAvatar(size: 70),
                  const SizedBox(height: 8),
                  Text(
                    'Id # $patientId',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    'Last Visit: 2023-10-01',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  // Add padding at the bottom to create space above the TabBar.
                  const SizedBox(height: 90),
                ],
              ),
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
          if (activeTab.value == 0) PatientProfileTab().sliverToBoxAdapter,
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
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement upload functionality
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
