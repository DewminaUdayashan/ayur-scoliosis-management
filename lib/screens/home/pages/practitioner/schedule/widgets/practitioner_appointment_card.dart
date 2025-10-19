import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/providers/session/active_session.dart';
import 'package:ayur_scoliosis_management/providers/video_call/video_call.dart';
import 'package:ayur_scoliosis_management/services/video_call/video_call_service.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:ayur_scoliosis_management/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/enums.dart';
import '../../../../../../models/appointment/appointment.dart';
import '../../../../../../providers/appointment/appointment_details.dart';

class PractitionerAppointmentCard extends HookConsumerWidget {
  const PractitionerAppointmentCard({super.key, required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final appointmentDetailsAsync = ref.watch(
      appointmentDetailsProvider(appointment.id),
    );
    return appointmentDetailsAsync.when(
      data: (appointment) {
        // Helper function to check if appointment time is near (within 15 minutes before or anytime after)
        bool canJoinCall() {
          final now = DateTime.now();
          final appointmentTime = appointment.appointmentDateTime.toLocal();
          final difference = appointmentTime.difference(now);
          // Allow joining 15 minutes before the appointment or anytime after
          return difference.inMinutes <= 15;
        }

        final canJoin = canJoinCall();
        final timeUntilText = appointment.timeUntilAppointment;

        return Card(
          color: Colors.white,
          child: InkWell(
            onTap: () =>
                context.push(AppRouter.appointmentDetails(appointment.id)),
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
                            '${appointment.name} - ${appointment.patient?.firstName}',
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

                  if (appointment.status == AppointmentStatus.scheduled &&
                      appointment.type == AppointmentType.remote)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Builder(
                        builder: (context) {
                          // Check if there's already an active call for this appointment
                          final videoCallState = ref.watch(videoCallProvider);
                          final isCallActive =
                              videoCallState.callState == CallState.connected &&
                              videoCallState.room?.appointmentId ==
                                  appointment.id;

                          return PrimaryButton(
                            isLoading: isLoading.value,
                            label: isCallActive
                                ? 'Return to Call'
                                : (canJoin ? 'Join' : 'Join in $timeUntilText'),
                            height: 20,
                            backgroundColor: isCallActive
                                ? Colors.green
                                : (canJoin ? AppTheme.primary : Colors.grey),
                            onPressed: (canJoin || isCallActive)
                                ? () async {
                                    // If call is already active, just navigate back to it
                                    if (isCallActive) {
                                      context.push(
                                        AppRouter.videoCall(appointment.id),
                                      );
                                      return;
                                    }

                                    isLoading.value = true;
                                    try {
                                      // Create or get the video call room
                                      final dio = ref.read(dioProvider);
                                      final videoCallService =
                                          VideoCallServiceImpl(
                                            api: Api(),
                                            client: dio,
                                          );

                                      try {
                                        // Try to get existing room
                                        await videoCallService
                                            .getRoomByAppointment(
                                              appointment.id,
                                            );
                                      } catch (e) {
                                        // If room doesn't exist, create it
                                        await videoCallService
                                            .createRoomForAppointment(
                                              appointment.id,
                                            );
                                      }

                                      // Start the remote session
                                      ref
                                          .read(activeSessionProvider.notifier)
                                          .startSession(
                                            appointment.id,
                                            'Remote',
                                          );

                                      // Navigate to video call screen
                                      if (context.mounted) {
                                        context.push(
                                          AppRouter.videoCall(appointment.id),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to join video call: $e',
                                            ),
                                            backgroundColor: AppTheme.error,
                                          ),
                                        );
                                      }
                                    } finally {
                                      isLoading.value = false;
                                    }
                                  }
                                : null,
                          );
                        },
                      ),
                    ),
                ],
              ),
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
