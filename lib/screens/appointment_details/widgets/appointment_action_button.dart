import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/widgets/app_text_field.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/enums.dart';
import '../../../providers/appointment/appointment_details.dart';
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
    Future<String?> showChangeRequestDialog() async {
      final reasonController = TextEditingController();

      return showDialog<String>(
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
                onPressed: () => Navigator.of(context).pop(),
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
                      final String? reason = await showChangeRequestDialog();
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
        if (appointment.status == AppointmentStatus.scheduled) {
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
