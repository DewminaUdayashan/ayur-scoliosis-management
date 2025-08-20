import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_appointment_payload.g.dart';

@JsonSerializable(createFactory: false)
class ScheduleAppointmentPayload {
  ScheduleAppointmentPayload({
    required this.name,
    required this.patientId,
    required this.date,
    required this.durationMinutes,
    required this.type,
    required this.notes,
  });
  final String name;
  final String patientId;
  @JsonKey(name: 'appointmentDateTime')
  final DateTime date;
  @JsonKey(name: 'durationInMinutes')
  final int durationMinutes;
  final AppointmentType type;
  final String? notes;

  Map<String, dynamic> toJson() => _$ScheduleAppointmentPayloadToJson(this);
}
