import 'package:ayur_scoliosis_management/core/enums.dart'
    show AppointmentType, AppointmentStatus;
import 'package:ayur_scoliosis_management/models/common/user_name.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.patientId,
    required this.practitionerId,
    required this.appointmentDateTime,
    required this.durationInMinutes,
    required this.type,
    required this.status,
    required this.notes,
    this.practitioner,
    this.patient,
  });
  final String id;
  final String patientId;
  final String practitionerId;
  final DateTime appointmentDateTime;
  final int durationInMinutes;
  final AppointmentType type;
  final AppointmentStatus status;
  final String notes;
  @JsonKey(includeToJson: false)
  final UserName? practitioner;
  @JsonKey(includeToJson: false)
  final UserName? patient;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);

  @override
  List<Object?> get props => [id];
}
