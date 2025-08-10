import 'package:ayur_scoliosis_management/providers/appointment/appointment_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointment_dates.g.dart';

@riverpod
Future<List<DateTime>> appointmentDates(
  Ref ref,
  DateTime? startDate,
  DateTime? endDate,
) async {
  final appointmentService = ref.watch(appointmentServiceProvider);

  // If dates are null, use current month's first and last dates
  final now = DateTime.now();
  final defaultStartDate = DateTime(now.year, now.month, 1);
  final defaultEndDate = DateTime(now.year, now.month + 1, 0);

  return appointmentService.getAppointmentDates(
    startDate ?? defaultStartDate,
    endDate ?? defaultEndDate,
  );
}
