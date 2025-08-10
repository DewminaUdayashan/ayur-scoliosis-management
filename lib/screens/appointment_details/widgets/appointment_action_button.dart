import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
                    onPressed: () {
                      // TODO: Implement logic to reject appointment
                    },
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    label: 'Confirm',
                    isLoading: isLoading.value,
                    onPressed: () {
                      // TODO: Implement logic to confirm appointment
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
