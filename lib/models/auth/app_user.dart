import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/patient/patient.dart';
import 'package:ayur_scoliosis_management/models/practitioner/practitioner.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.mustChangePassword,
    required this.joinedDate,
    this.phone,
    this.imageUrl,
    this.practitioner,
    this.patient,
    this.lastAppointmentDate,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final UserRole role;
  final bool mustChangePassword;
  final DateTime joinedDate;
  @JsonKey(name: 'profileImageUrl')
  final String? imageUrl;
  final Practitioner? practitioner;
  final Patient? patient;
  final DateTime? lastAppointmentDate;

  bool get isPractitioner => practitioner != null;
  bool get isPatient => patient != null;
  String get fullName => '$firstName $lastName';

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  @override
  List<Object?> get props => [id, email];
}
