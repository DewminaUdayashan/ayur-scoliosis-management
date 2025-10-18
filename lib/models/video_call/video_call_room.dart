import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_call_room.g.dart';

enum VideoCallStatus {
  @JsonValue('Waiting')
  waiting,
  @JsonValue('InProgress')
  inProgress,
  @JsonValue('Ended')
  ended,
}

@JsonSerializable()
class VideoCallRoom extends Equatable {
  final String id;
  final String appointmentId;
  final String roomId;
  final VideoCallStatus status;
  final bool practitionerJoined;
  final bool patientJoined;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VideoCallRoom({
    required this.id,
    required this.appointmentId,
    required this.roomId,
    required this.status,
    required this.practitionerJoined,
    required this.patientJoined,
    this.startedAt,
    this.endedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoCallRoom.fromJson(Map<String, dynamic> json) =>
      _$VideoCallRoomFromJson(json);

  Map<String, dynamic> toJson() => _$VideoCallRoomToJson(this);

  @override
  List<Object?> get props => [
    id,
    appointmentId,
    roomId,
    status,
    practitionerJoined,
    patientJoined,
    startedAt,
    endedAt,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class VideoCallRoomWithAppointment extends VideoCallRoom {
  final Map<String, dynamic>? appointment;

  const VideoCallRoomWithAppointment({
    required super.id,
    required super.appointmentId,
    required super.roomId,
    required super.status,
    required super.practitionerJoined,
    required super.patientJoined,
    super.startedAt,
    super.endedAt,
    required super.createdAt,
    required super.updatedAt,
    this.appointment,
  });

  factory VideoCallRoomWithAppointment.fromJson(Map<String, dynamic> json) =>
      _$VideoCallRoomWithAppointmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VideoCallRoomWithAppointmentToJson(this);

  @override
  List<Object?> get props => [...super.props, appointment];
}
