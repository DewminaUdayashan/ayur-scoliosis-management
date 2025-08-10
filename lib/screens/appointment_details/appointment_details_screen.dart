import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/widgets/patient_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme.dart';
import '../../../../core/theme.dart';

class AppointmentDetailsScreen extends HookConsumerWidget {
  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, you would use the appointmentId to fetch the appointment
    // from a provider. For now, we'll use a dummy object.
    final appointment = Appointment(
      id: appointmentId,
      patientId: 'patient_123',
      practitionerId: 'practitioner_abc',
      appointmentDateTime: DateTime.now().add(
        const Duration(days: 2, hours: 3),
      ),
      durationInMinutes: 45,
      type: AppointmentType.remote,
      status: AppointmentStatus.scheduled,
      notes:
          'Follow-up session to review the patient\'s progress and discuss the next phase of the treatment plan. Patient has reported reduced pain in the lower back.',
    );

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
                _buildParticipantInfo(context),
                const SizedBox(height: 24),
                _buildDetailsCard(context, appointment),
                const SizedBox(height: 24),
                _buildNotesCard(context, appointment),
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
        child: _buildActionButton(context, appointment.status),
      ),
    );
  }

  /// Builds the header section with patient and practitioner info.
  Widget _buildParticipantInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const PatientProfileAvatar(
              size: 60,
              // Dummy image for practitioner
            ),
            const SizedBox(height: 8),
            Text(
              'Dr. John Doe', // Dummy practitioner name
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Practitioner',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(
            CupertinoIcons.arrow_right_arrow_left,
            color: AppTheme.textSecondary,
          ),
        ),
        Column(
          children: [
            const PatientProfileAvatar(
              size: 60,
              // Dummy image for patient
            ),
            const SizedBox(height: 8),
            Text(
              'Anusha Perera', // Dummy patient name
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Patient',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the card displaying the core details of the appointment.
  Widget _buildDetailsCard(BuildContext context, Appointment appointment) {
    return _InfoCard(
      title: 'Session Details',
      children: [
        _InfoRow(
          icon: CupertinoIcons.calendar,
          label: 'Date',
          value: DateFormat.yMMMMd().format(appointment.appointmentDateTime),
        ),
        _InfoRow(
          icon: CupertinoIcons.clock,
          label: 'Time',
          value: DateFormat.jm().format(appointment.appointmentDateTime),
        ),
        _InfoRow(
          icon: CupertinoIcons.hourglass,
          label: 'Duration',
          value: '${appointment.durationInMinutes} minutes',
        ),
        _InfoRow(
          icon: appointment.type == AppointmentType.remote
              ? CupertinoIcons.video_camera_solid
              : CupertinoIcons.building_2_fill,
          label: 'Type',
          value: appointment.type.name,
        ),
        _InfoRow(
          icon: CupertinoIcons.check_mark_circled,
          label: 'Status',
          valueWidget: Chip(
            label: Text(
              appointment.status.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppTheme.primary,
            side: BorderSide.none,
          ),
        ),
      ],
    );
  }

  /// Builds the card displaying the appointment notes.
  Widget _buildNotesCard(BuildContext context, Appointment appointment) {
    return _InfoCard(
      title: 'Notes',
      children: [
        Text(
          appointment.notes,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Builds the main action button based on the appointment's status.
  Widget _buildActionButton(BuildContext context, AppointmentStatus status) {
    if (status == AppointmentStatus.scheduled) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(CupertinoIcons.video_camera_solid, size: 20),
          label: const Text('Start Session'),
          onPressed: () {
            // TODO: Implement logic to start the video call or session
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
    // If completed or cancelled, show a disabled button or nothing.
    return const SizedBox.shrink();
  }
}

/// A reusable card widget for displaying sections of information.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(8),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

/// A reusable row widget for displaying an icon, label, and value.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  }) : assert(value != null || valueWidget != null);

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 16),
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          valueWidget ??
              Text(
                value!,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        ],
      ),
    );
  }
}
