import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'practitioner.g.dart';

@JsonSerializable()
class Practitioner extends AppUser {
  final String phone;
  final String specialty;
  final String medicalLicense;
  final AccountStatus status;
  final String clinicId;

  const Practitioner({
    // Common fields passed to the super class
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.passwordHash,
    required super.role,
    // Practitioner-specific fields
    required this.phone,
    required this.specialty,
    required this.medicalLicense,
    required this.status,
    required this.clinicId,
  });

  factory Practitioner.fromJson(Map<String, dynamic> json) =>
      _$PractitionerFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PractitionerToJson(this);
}
