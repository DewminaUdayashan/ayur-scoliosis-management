import 'package:ayur_scoliosis_management/core/enums.dart'
    show AppointmentType, AppointmentStatus;
import 'package:ayur_scoliosis_management/models/common/user_name.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.patientId,
    required this.practitionerId,
    required this.appointmentDateTime,
    required this.durationInMinutes,
    required this.type,
    required this.status,
    required this.notes,
    this.practitioner,
    this.patient,
  });
  final String id;
  final String patientId;
  final String practitionerId;
  final DateTime appointmentDateTime;
  final int durationInMinutes;
  final AppointmentType type;
  final AppointmentStatus status;
  final String notes;
  @JsonKey(includeToJson: false)
  final UserName? practitioner;
  @JsonKey(includeToJson: false)
  final UserName? patient;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);

  /// Returns a human-readable string representing time until appointment.
  String get timeUntilAppointment {
    final now = DateTime.now();
    final appointmentDateTime = this.appointmentDateTime.toLocal();
    if (appointmentDateTime.isBefore(now)) {
      return "Appointment time has passed";
    }

    final diff = appointmentDateTime.difference(now);
    final totalDays = diff.inDays;
    final totalHours = diff.inHours;
    final totalMinutes = diff.inMinutes;
    print('Now: $now');
    print('Appointment: $appointmentDateTime');
    if (totalDays >= 30) {
      final months = totalDays ~/ 30;
      final weeks = (totalDays % 30) ~/ 7;
      return "$months month${months > 1 ? 's' : ''}"
          "${weeks > 0 ? ' and $weeks week${weeks > 1 ? 's' : ''}' : ''}";
    } else if (totalDays >= 7) {
      final weeks = totalDays ~/ 7;
      final days = totalDays % 7;
      return "$weeks week${weeks > 1 ? 's' : ''}"
          "${days > 0 ? ' and $days day${days > 1 ? 's' : ''}' : ''}";
    } else if (totalDays > 0) {
      final hours = diff.inHours % 24;
      return "$totalDays day${totalDays > 1 ? 's' : ''}"
          "${hours > 0 ? ' and $hours hour${hours > 1 ? 's' : ''}' : ''}";
    } else if (totalHours > 0) {
      final minutes = totalMinutes % 60;
      return "$totalHours hour${totalHours > 1 ? 's' : ''}"
          "${minutes > 0 ? ' and $minutes minute${minutes > 1 ? 's' : ''}' : ''}";
    } else {
      return "$totalMinutes minute${totalMinutes != 1 ? 's' : ''}";
    }
  }

  @override
  List<Object?> get props => [id];
}
