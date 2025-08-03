import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient extends AppUser {
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final String clinicId;

  const Patient({
    // Common fields passed to the super class
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.passwordHash,
    required super.role,
    // Patient-specific fields
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.clinicId,
  });

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
