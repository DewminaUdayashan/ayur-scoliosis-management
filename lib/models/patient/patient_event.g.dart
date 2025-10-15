// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientEvent _$PatientEventFromJson(Map<String, dynamic> json) => PatientEvent(
  id: json['id'] as String,
  patientId: json['patientId'] as String,
  createdByPractitionerId: json['createdByPractitionerId'] as String,
  appointmentId: json['appointmentId'] as String?,
  eventType: $enumDecode(_$EventTypeEnumMap, json['eventType']),
  eventDateTime: DateTime.parse(json['eventDateTime'] as String),
  isSharedWithPatient: json['isSharedWithPatient'] as bool,
  aiClassificationResult: json['aiClassificationResult'] == null
      ? null
      : AIClassificationResult.fromJson(
          json['aiClassificationResult'] as Map<String, dynamic>,
        ),
  xrayImages: (json['xrayImages'] as List<dynamic>?)
      ?.map((e) => XRayImage.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PatientEventToJson(PatientEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'createdByPractitionerId': instance.createdByPractitionerId,
      'appointmentId': instance.appointmentId,
      'eventType': _$EventTypeEnumMap[instance.eventType]!,
      'eventDateTime': instance.eventDateTime.toIso8601String(),
      'isSharedWithPatient': instance.isSharedWithPatient,
      'xrayImages': instance.xrayImages,
      'aiClassificationResult': instance.aiClassificationResult,
    };

const _$EventTypeEnumMap = {
  EventType.appointmentCompleted: 'AppointmentCompleted',
  EventType.xRayUpload: 'XRayUpload',
  EventType.aiClassification: 'AIClassification',
  EventType.cobbAngleMeasurement: 'CobbAngleMeasurement',
  EventType.sessionNote: 'SessionNote',
};
