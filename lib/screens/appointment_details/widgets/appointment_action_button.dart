import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/providers/session/active_session.dart';
import 'package:ayur_scoliosis_management/providers/video_call/video_call.dart';
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
    final activeSession = ref.watch(activeSessionProvider);

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
          // For remote appointments, show video call button and complete button
          if (appointment.type == AppointmentType.remote) {
            final canJoin = canJoinCall();

            // Check if there's already an active call for this appointment
            final videoCallState = ref.watch(videoCallProvider);
            final isCallActive =
                videoCallState.callState == CallState.connected &&
                videoCallState.room?.appointmentId == appointment.id;

            final isAnySessionActive = activeSession != null;
            final isDifferentSessionActive =
                isAnySessionActive &&
                activeSession.appointmentId != appointment.id;

            // If call is active or has been joined, show both join and complete buttons
            if (isCallActive || canJoin) {
              return Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: isCallActive
                          ? 'Return to Call'
                          : (isDifferentSessionActive
                                ? 'Join (End other session first)'
                                : 'Join Call'),
                      isLoading: isLoading.value,
                      backgroundColor: isCallActive
                          ? Colors.green
                          : (isDifferentSessionActive
                                ? Colors.grey
                                : AppTheme.primary),
                      onPressed: isDifferentSessionActive
                          ? null
                          : () async {
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
                                  await videoCallService
                                      .createRoomForAppointment(appointment.id);
                                }

                                // Start the remote session
                                ref
                                    .read(activeSessionProvider.notifier)
                                    .startSession(appointment.id, 'Remote');

                                // Navigate to video call screen
                                if (context.mounted) {
                                  context.push(
                                    AppRouter.videoCall(appointment.id),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                            },
                    ),
                  ),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Complete',
                      isLoading: isLoading.value,
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        // Show confirmation dialog
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Complete Appointment'),
                            content: const Text(
                              'Mark this appointment as completed? This will notify the patient.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => ctx.pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => ctx.pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Complete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          isLoading.value = true;
                          try {
                            await ref
                                .read(
                                  appointmentDetailsProvider(
                                    appointment.id,
                                  ).notifier,
                                )
                                .complete();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Appointment completed successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to complete appointment: $e',
                                  ),
                                  backgroundColor: AppTheme.error,
                                ),
                              );
                            }
                          } finally {
                            isLoading.value = false;
                          }
                        }
                      },
                    ),
                  ),
                ],
              );
            }

            // Before the join time, show only disabled join button
            return PrimaryButton(
              label: 'Video Call (Not Yet Available)',
              isLoading: isLoading.value,
              backgroundColor: Colors.grey,
              onPressed: null,
            );
          }

          // For physical appointments
          final isThisSessionActive =
              activeSession?.appointmentId == appointment.id;
          final isAnySessionActive = activeSession != null;

          // If this appointment's session is active, show complete button
          if (isThisSessionActive) {
            return PrimaryButton(
              label: 'Complete Session',
              isLoading: isLoading.value,
              backgroundColor: Colors.green,
              onPressed: () async {
                // Check if there are notes
                final hasNotes = activeSession!.notes.isNotEmpty;

                if (hasNotes) {
                  // Ask if they want to save notes
                  final saveNotes = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Complete Session'),
                      content: const Text(
                        'You have unsaved notes. Would you like to save them with this appointment?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => ctx.pop(false),
                          child: const Text('Discard Notes'),
                        ),
                        ElevatedButton(
                          onPressed: () => ctx.pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Save Notes'),
                        ),
                      ],
                    ),
                  );

                  if (saveNotes == null) return; // User cancelled

                  isLoading.value = true;
                  try {
                    if (saveNotes) {
                      await ref
                          .read(
                            appointmentDetailsProvider(appointment.id).notifier,
                          )
                          .completeWithNotes(activeSession.notes);
                    } else {
                      await ref
                          .read(
                            appointmentDetailsProvider(appointment.id).notifier,
                          )
                          .complete();
                    }

                    // End the session
                    ref.read(activeSessionProvider.notifier).endSession();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Session completed successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to complete session: $e'),
                          backgroundColor: AppTheme.error,
                        ),
                      );
                    }
                  } finally {
                    isLoading.value = false;
                  }
                } else {
                  // No notes, just complete
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Complete Session'),
                      content: const Text(
                        'Mark this appointment as completed?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => ctx.pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => ctx.pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    isLoading.value = true;
                    try {
                      await ref
                          .read(
                            appointmentDetailsProvider(appointment.id).notifier,
                          )
                          .complete();

                      // End the session
                      ref.read(activeSessionProvider.notifier).endSession();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Session completed successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to complete session: $e'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                      }
                    } finally {
                      isLoading.value = false;
                    }
                  }
                }
              },
            );
          }

          // If another session is active, disable this button
          if (isAnySessionActive) {
            return PrimaryButton(
              label: 'Start Session (Another session active)',
              isLoading: false,
              backgroundColor: Colors.grey,
              onPressed: null,
            );
          }

          // Show start session button
          return PrimaryButton(
            label: 'Start Session',
            isLoading: isLoading.value,
            onPressed: () {
              // Start the physical session with the session state
              ref
                  .read(activeSessionProvider.notifier)
                  .startSession(appointment.id, 'Physical');

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Physical session started. Tap the floating icon to add notes.',
                  ),
                  backgroundColor: Colors.blue,
                  duration: Duration(seconds: 3),
                ),
              );
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
