// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  id: json['id'] as String,
  name: json['name'] as String,
  patientId: json['patientId'] as String,
  practitionerId: json['practitionerId'] as String,
  appointmentDateTime: DateTime.parse(json['appointmentDateTime'] as String),
  durationInMinutes: (json['durationInMinutes'] as num).toInt(),
  type: $enumDecode(_$AppointmentTypeEnumMap, json['type']),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  notes: json['notes'] as String?,
  practitioner: json['practitioner'] == null
      ? null
      : UserName.fromJson(json['practitioner'] as Map<String, dynamic>),
  patient: json['patient'] == null
      ? null
      : UserName.fromJson(json['patient'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'patientId': instance.patientId,
      'practitionerId': instance.practitionerId,
      'appointmentDateTime': instance.appointmentDateTime.toIso8601String(),
      'durationInMinutes': instance.durationInMinutes,
      'type': _$AppointmentTypeEnumMap[instance.type]!,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'notes': instance.notes,
    };

const _$AppointmentTypeEnumMap = {
  AppointmentType.physical: 'Physical',
  AppointmentType.remote: 'Remote',
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pendingConfirmation: 'PendingPatientConfirmation',
  AppointmentStatus.scheduled: 'Scheduled',
  AppointmentStatus.completed: 'Completed',
  AppointmentStatus.cancelled: 'Cancelled',
  AppointmentStatus.noShow: 'NoShow',
};
