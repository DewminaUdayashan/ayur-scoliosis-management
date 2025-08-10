import 'package:ayur_scoliosis_management/core/utils/snacks.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_service.dart';
import 'package:ayur_scoliosis_management/providers/appointment/upcoming_appointments.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointment_details.g.dart';

@riverpod
class AppointmentDetails extends _$AppointmentDetails {
  @override
  Future<Appointment> build(String appointmentId) {
    return ref
        .watch(appointmentServiceProvider)
        .appointmentDetails(appointmentId);
  }

  Future<void> respond(AppointmentRespond respond) async {
    try {
      await ref.watch(appointmentServiceProvider).respondToAppointment(respond);
      ref.invalidateSelf();
      ref.invalidate(upcomingAppointmentsProvider);
    } catch (e) {
      showErrorSnack(e.toString());
    }
  }
}
