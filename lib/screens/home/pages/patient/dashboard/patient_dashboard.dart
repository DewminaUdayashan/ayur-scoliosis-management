import 'package:ayur_scoliosis_management/screens/home/pages/patient/dashboard/widgets/next_appointment_card.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/patient/dashboard/widgets/recent_instruction_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/constants/size.dart';
import '../../../../../core/extensions/widgets.dart';
import '../../../../../widgets/page_title.dart';
import '../../../../../widgets/sliver_sized_box.dart';
import 'widgets/patient_app_bar.dart';

class PatientDashboard extends HookConsumerWidget {
  const PatientDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: horizontalPadding,
      child: CustomScrollView(
        slivers: [
          PatientAppBar(),
          SliverSizedBox(height: 20),
          PageTitle(title: 'Your Next Appointment'),
          NextAppointmentCard(isRemote: true).sliverToBoxAdapter,
          NextAppointmentCard().sliverToBoxAdapter,
          SliverSizedBox(height: 20),
          PageTitle(title: 'Recent Instructions'),
          RecentInstructionCard().sliverToBoxAdapter,
        ],
      ),
    );
  }
}
