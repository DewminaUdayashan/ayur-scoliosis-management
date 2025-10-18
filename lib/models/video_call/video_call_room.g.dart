// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_call_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoCallRoom _$VideoCallRoomFromJson(Map<String, dynamic> json) =>
    VideoCallRoom(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      roomId: json['roomId'] as String,
      status: $enumDecode(_$VideoCallStatusEnumMap, json['status']),
      practitionerJoined: json['practitionerJoined'] as bool,
      patientJoined: json['patientJoined'] as bool,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VideoCallRoomToJson(VideoCallRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointmentId': instance.appointmentId,
      'roomId': instance.roomId,
      'status': _$VideoCallStatusEnumMap[instance.status]!,
      'practitionerJoined': instance.practitionerJoined,
      'patientJoined': instance.patientJoined,
      'startedAt': instance.startedAt?.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$VideoCallStatusEnumMap = {
  VideoCallStatus.waiting: 'Waiting',
  VideoCallStatus.inProgress: 'InProgress',
  VideoCallStatus.ended: 'Ended',
};

VideoCallRoomWithAppointment _$VideoCallRoomWithAppointmentFromJson(
  Map<String, dynamic> json,
) => VideoCallRoomWithAppointment(
  id: json['id'] as String,
  appointmentId: json['appointmentId'] as String,
  roomId: json['roomId'] as String,
  status: $enumDecode(_$VideoCallStatusEnumMap, json['status']),
  practitionerJoined: json['practitionerJoined'] as bool,
  patientJoined: json['patientJoined'] as bool,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  appointment: json['appointment'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$VideoCallRoomWithAppointmentToJson(
  VideoCallRoomWithAppointment instance,
) => <String, dynamic>{
  'id': instance.id,
  'appointmentId': instance.appointmentId,
  'roomId': instance.roomId,
  'status': _$VideoCallStatusEnumMap[instance.status]!,
  'practitionerJoined': instance.practitionerJoined,
  'patientJoined': instance.patientJoined,
  'startedAt': instance.startedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'appointment': instance.appointment,
};
