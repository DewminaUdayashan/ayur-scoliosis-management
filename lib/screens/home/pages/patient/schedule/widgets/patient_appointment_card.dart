import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/outlined_app_button.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:ayur_scoliosis_management/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/enums.dart';
import '../../../../../../models/appointment/appointment.dart';
import '../../../../../../providers/appointment/appointment_details.dart';

class PatientAppointmentCard extends HookConsumerWidget {
  const PatientAppointmentCard({super.key, required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRequesting = useState(false);
    final isAccepting = useState(false);
    final appointmentDetailsAsync = ref.watch(
      appointmentDetailsProvider(appointment.id),
    );
    return appointmentDetailsAsync.when(
      data: (appointment) {
        final canJoin =
            appointment.type == AppointmentType.remote &&
            (appointment.appointmentDateTime.isAtSameMomentAs(DateTime.now()) ||
                appointment.appointmentDateTime.isBefore(DateTime.now()));

        final timeUntilText = appointment.timeUntilAppointment;

        return Card(
          color: Colors.white,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(8),
                  spreadRadius: 1,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 60,
                      decoration: BoxDecoration(
                        color:
                            appointment.status ==
                                AppointmentStatus.pendingConfirmation
                            ? Colors.grey
                            : appointment.status.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          '${appointment.name} - Dr.${appointment.practitioner?.firstName}',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${appointment.appointmentDateTime.readableTimeAndDate} - ${appointment.type.value}',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          appointment.status.value,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: appointment.status.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(radius: 24),
                  ],
                ),
                // --- Conditional Action Buttons ---
                if (appointment.status == AppointmentStatus.pendingConfirmation)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedAppButton(
                            label: 'Request New Timeslot',
                            isLoading: isRequesting.value,
                            onPressed: () async {
                              isRequesting.value = true;
                              try {
                                await ref
                                    .read(
                                      appointmentDetailsProvider(
                                        appointment.id,
                                      ).notifier,
                                    )
                                    .respond(
                                      AppointmentRespond(
                                        id: appointment.id,
                                        accepted: false,
                                      ),
                                    );
                              } finally {
                                ref.invalidate(
                                  appointmentDetailsProvider(appointment.id),
                                );
                                isRequesting.value = false;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Accept',
                            isLoading: isAccepting.value,
                            height: 20,
                            onPressed: () async {
                              isAccepting.value = true;
                              try {
                                await ref
                                    .read(
                                      appointmentDetailsProvider(
                                        appointment.id,
                                      ).notifier,
                                    )
                                    .respond(
                                      AppointmentRespond(
                                        id: appointment.id,
                                        accepted: true,
                                      ),
                                    );
                              } finally {
                                ref.invalidate(
                                  appointmentDetailsProvider(appointment.id),
                                );
                                isAccepting.value = false;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (appointment.status == AppointmentStatus.scheduled &&
                    appointment.type == AppointmentType.remote)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: PrimaryButton(
                      isLoading: false,
                      label: canJoin ? 'Join' : 'Join in $timeUntilText',
                      height: 20,
                      onPressed: canJoin ? () {} : null,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
      loading: () => Skeleton(
        builder: (decoration) => Container(decoration: decoration, height: 150),
      ),
    );
  }
}
