import 'package:json_annotation/json_annotation.dart';

part 'appointment_respond.g.dart';

@JsonSerializable(createFactory: false)
class AppointmentRespond {
  AppointmentRespond({required this.id, required this.accepted, this.message});
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;
  final bool accepted;
  final String? message;

  Map<String, dynamic> toJson() => _$AppointmentRespondToJson(this);
}
