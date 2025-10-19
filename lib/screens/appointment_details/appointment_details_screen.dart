import 'package:ayur_scoliosis_management/screens/appointment_details/widgets/details_card_widget.dart';
import 'package:ayur_scoliosis_management/screens/appointment_details/widgets/notes_card_widget.dart';
import 'package:ayur_scoliosis_management/screens/appointment_details/widgets/participant_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extensions/theme.dart';
import 'widgets/appointment_action_button.dart';

class AppointmentDetailsScreen extends HookConsumerWidget {
  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Appointment Details',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            pinned: true,
            floating: true,
            snap: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ParticipantInfoWidget(appointmentId: appointmentId),
                const SizedBox(height: 24),
                DetailsCardWidget(appointmentId: appointmentId),
                const SizedBox(height: 24),
                NotesCardWidget(appointmentId: appointmentId),
                const SizedBox(height: 90), // Space for the action button
              ]),
            ),
          ),
        ],
      ),
      // Floating action button at the bottom
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AppointmentActionButton(appointmentId: appointmentId),
      ),
    );
  }
}
