import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/services/video_call/video_call_service.dart';
import 'package:ayur_scoliosis_management/widgets/app_text_field.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/enums.dart';
import '../../../providers/appointment/appointment_details.dart';
import '../../../providers/dio/dio.dart';
import '../../../widgets/skeleton.dart';

class AppointmentActionButton extends HookConsumerWidget {
  const AppointmentActionButton({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final appointmentAsync = ref.watch(
      appointmentDetailsProvider(appointmentId),
    );
    final profile = ref.watch(profileProvider).valueOrNull;
    final isPatient = profile?.isPatient;

    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Function to show change request dialog
    Future showChangeRequestDialog() async {
      final reasonController = TextEditingController();

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Request Appointment Change'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please provide a reason for requesting this change and any preferred timeframe.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Form(
                  key: formKey,
                  child: AppTextField(
                    controller: reasonController,
                    hintText:
                        'e.g., I need to reschedule due to a work commitment. I\'m available next week in the afternoons.',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a reason and preferred timeframe.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final reason = reasonController.text.trim();
                    context.pop(reason);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Request Change'),
              ),
            ],
          );
        },
      );
    }

    if (profile == null) return _LoadingShimmer();

    return appointmentAsync.when(
      data: (appointment) {
        if (isPatient == true) {
          if (appointment.status == AppointmentStatus.pendingConfirmation) {
            return Row(
              spacing: 16,
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Request Change',
                    isLoading: isLoading.value,
                    backgroundColor: AppTheme.error,
                    onPressed: () async {
                      final reason = await showChangeRequestDialog();
                      if (reason == false) return;
                      if (reason != null && reason.isNotEmpty) {
                        isLoading.value = true;
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
                                message: reason,
                              ),
                            );
                        isLoading.value = false;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    label: 'Confirm',
                    isLoading: isLoading.value,
                    onPressed: () async {
                      isLoading.value = true;
                      await ref
                          .read(
                            appointmentDetailsProvider(appointment.id).notifier,
                          )
                          .respond(
                            AppointmentRespond(
                              id: appointment.id,
                              accepted: true,
                            ),
                          );
                      isLoading.value = false;
                    },
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        }

        // Helper function to check if appointment time is near (within 15 minutes before or anytime after)
        bool canJoinCall() {
          final now = DateTime.now();
          final appointmentTime = appointment.appointmentDateTime.toLocal();
          final difference = appointmentTime.difference(now);
          // Allow joining 15 minutes before the appointment or anytime after
          return difference.inMinutes <= 15;
        }

        if (appointment.status == AppointmentStatus.scheduled) {
          // For remote appointments, show video call button
          if (appointment.type == AppointmentType.remote) {
            final canJoin = canJoinCall();
            return PrimaryButton(
              label: canJoin
                  ? 'Join Video Call'
                  : 'Video Call (Not Yet Available)',
              isLoading: isLoading.value,
              backgroundColor: canJoin ? AppTheme.primary : Colors.grey,
              onPressed: canJoin
                  ? () async {
                      isLoading.value = true;
                      try {
                        // Create or get the video call room
                        final dio = ref.read(dioProvider);
                        final videoCallService = VideoCallServiceImpl(
                          api: Api(),
                          client: dio,
                        );

                        try {
                          // Try to get existing room
                          await videoCallService.getRoomByAppointment(
                            appointment.id,
                          );
                        } catch (e) {
                          // If room doesn't exist, create it
                          await videoCallService.createRoomForAppointment(
                            appointment.id,
                          );
                        }

                        // Navigate to video call screen
                        if (context.mounted) {
                          context.push(AppRouter.videoCall(appointment.id));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to join video call: $e'),
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
          }

          // For physical appointments
          return PrimaryButton(
            label: 'Start Session',
            isLoading: isLoading.value,
            onPressed: () {
              // TODO: Implement logic to start session
            },
          );
        }
        // If completed or cancelled, show nothing
        return const SizedBox.shrink();
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => _LoadingShimmer(),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      builder: (decorations) => Container(
        decoration: decorations,
        width: double.infinity,
        height: 50,
      ),
    );
  }
}
