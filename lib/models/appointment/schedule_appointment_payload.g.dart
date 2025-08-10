// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_appointment_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ScheduleAppointmentPayloadToJson(
  ScheduleAppointmentPayload instance,
) => <String, dynamic>{
  'patientId': instance.patientId,
  'appointmentDateTime': instance.date.toIso8601String(),
  'durationInMinutes': instance.durationMinutes,
  'type': _$SessionTypeEnumMap[instance.type]!,
  'notes': instance.notes,
};

const _$SessionTypeEnumMap = {
  SessionType.physical: 'physical',
  SessionType.remote: 'remote',
};
