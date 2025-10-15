import 'package:ayur_scoliosis_management/models/events/ai_classification_result.dart';
import 'package:ayur_scoliosis_management/models/events/xray_image.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/enums.dart' show EventType;

part 'patient_event.g.dart';

@JsonSerializable()
class PatientEvent extends Equatable {
  const PatientEvent({
    required this.id,
    required this.patientId,
    required this.createdByPractitionerId,
    this.appointmentId,
    required this.eventType,
    required this.eventDateTime,
    required this.isSharedWithPatient,
    this.aiClassificationResult,
    this.xrayImages,
  });
  final String id;
  final String patientId;
  final String createdByPractitionerId;
  final String? appointmentId;
  final EventType eventType;
  final DateTime eventDateTime;
  final bool isSharedWithPatient;
  final List<XRayImage>? xrayImages;
  final AIClassificationResult? aiClassificationResult;

  factory PatientEvent.fromJson(Map<String, dynamic> json) =>
      _$PatientEventFromJson(json);
  Map<String, dynamic> toJson() => _$PatientEventToJson(this);

  @override
  List<Object?> get props => [id];
}
