import 'package:ayur_scoliosis_management/core/enums.dart' show EventType;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_event.g.dart';

@JsonSerializable()
class PatientEvent extends Equatable {
  final String id;
  final String patientId;
  final String createdByPractitionerId;
  final String? appointmentId;
  final EventType eventType;
  final DateTime eventDateTime;
  final bool isSharedWithPatient;

  const PatientEvent({
    required this.id,
    required this.patientId,
    required this.createdByPractitionerId,
    this.appointmentId,
    required this.eventType,
    required this.eventDateTime,
    required this.isSharedWithPatient,
  });

  factory PatientEvent.fromJson(Map<String, dynamic> json) =>
      _$PatientEventFromJson(json);
  Map<String, dynamic> toJson() => _$PatientEventToJson(this);

  @override
  List<Object?> get props => [id];
}
