// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_appointment_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ScheduleAppointmentPayloadToJson(
  ScheduleAppointmentPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'patientId': instance.patientId,
  'appointmentDateTime': instance.date.toIso8601String(),
  'durationInMinutes': instance.durationMinutes,
  'type': _$AppointmentTypeEnumMap[instance.type]!,
  'notes': instance.notes,
};

const _$AppointmentTypeEnumMap = {
  AppointmentType.physical: 'Physical',
  AppointmentType.remote: 'Remote',
};
