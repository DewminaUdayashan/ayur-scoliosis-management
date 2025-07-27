// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
  id: json['id'] as String,
  patientId: json['patientId'] as String?,
  practitionerId: json['practitionerId'] as String?,
  relatedEventId: json['relatedEventId'] as String?,
  title: json['title'] as String,
  message: json['message'] as String,
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'practitionerId': instance.practitionerId,
      'relatedEventId': instance.relatedEventId,
      'title': instance.title,
      'message': instance.message,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };
