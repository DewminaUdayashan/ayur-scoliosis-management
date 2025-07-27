import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification extends Equatable {
  final String id;
  final String? patientId;
  final String? practitionerId;
  final String? relatedEventId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const Notification({
    required this.id,
    this.patientId,
    this.practitionerId,
    this.relatedEventId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  List<Object?> get props => [id];
}
