import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/practitioner/dashboard/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../providers/appointment/appointments.dart';

class PractitionerTodaysAppointments extends HookConsumerWidget {
  const PractitionerTodaysAppointments({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);

    final appointmentsAsync = ref.watch(
      appointmentsProvider(startDate: startDate.value, endDate: endDate.value),
    );

    useEffect(() {
      startDate.value = DateTime.now();
      endDate.value = DateTime.now().add(Duration(days: 1));
      return null;
    }, []);

    return appointmentsAsync.when(
      data: (data) {
        final appointments = data
            .map((e) => e.data)
            .expand((element) => element)
            .toList();
        if (appointments.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'No appointments for today',
                style: context.textTheme.bodyLarge,
              ),
            ),
          );
        }
        return SliverList.builder(
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return AppointmentCard(appointment: appointment);
          },
          itemCount: appointments.length,
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(child: Text('Error loading appointments')),
      ),
    );
  }
}
