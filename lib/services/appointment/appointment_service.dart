import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/models/appointment/schedule_appointment_payload.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated_request.dart';

abstract class AppointmentService {
  Future<Paginated<Appointment>> getAppointments(
    PaginatedRequest request,
    String? patientId,
  );
  Future<Appointment> appointmentDetails(String id);
  Future<List<Appointment>> upcomingAppointments();
  Future<Appointment> scheduleAppointment(ScheduleAppointmentPayload payload);
  Future<void> respondToAppointment(AppointmentRespond respond);
}
