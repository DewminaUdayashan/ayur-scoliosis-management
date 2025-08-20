import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/constants/size.dart';
import '../../../../../core/extensions/widgets.dart';
import '../../../../../widgets/page_title.dart';
import '../../../../../widgets/sliver_sized_box.dart';
import 'widgets/activity_card.dart';
import 'widgets/app_bar.dart';
import 'widgets/practitioner_todays_appointments.dart';

class PractitionerDashboard extends HookConsumerWidget {
  const PractitionerDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: horizontalPadding,
      child: CustomScrollView(
        slivers: [
          const PractitionerAppBar(),
          const SliverSizedBox(height: 20),
          const PageTitle(title: 'Today\'s Appointments'),
          const PractitionerTodaysAppointments(),
          const SliverSizedBox(height: 20),
          const PageTitle(title: 'Recent Activities'),
          ActivityCard().sliverToBoxAdapter,
        ],
      ),
    );
  }
}
