import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'practitioner_register_model.g.dart';

/// DTO for practitioner registration with a flattened structure for clinic data.
/// This structure is optimized for multipart/form-data and provides a better
/// experience in API requests by showing each field individually.
@JsonSerializable(createFactory: false)
class PractitionerRegisterModel {
  const PractitionerRegisterModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.specialty,
    required this.medicalLicense,
    required this.clinicName,
    required this.clinicAddressLine1,
    this.clinicAddressLine2,
    required this.clinicCity,
    required this.clinicEmail,
    required this.clinicPhone,
    this.profileImage,
    this.clinicImage,
  });
  // --- Practitioner Fields ---
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String specialty;
  final String medicalLicense;

  // --- Clinic Fields (Flattened) ---
  final String clinicName;
  final String clinicAddressLine1;
  final String? clinicAddressLine2;
  final String clinicCity;
  final String clinicEmail;
  final String clinicPhone;

  // --- File Upload Fields ---
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? profileImage;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? clinicImage;

  /// Convert the DTO to a JSON map for API requests.
  Map<String, dynamic> toJson() => _$PractitionerRegisterModelToJson(this);

  @override
  String toString() {
    return 'CreatePractitionerDto('
        'email: $email, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'phone: $phone, '
        'specialty: $specialty, '
        'medicalLicense: $medicalLicense, '
        'clinicName: $clinicName, '
        'clinicAddressLine1: $clinicAddressLine1, '
        'clinicAddressLine2: $clinicAddressLine2, '
        'clinicCity: $clinicCity, '
        'clinicEmail: $clinicEmail, '
        'clinicPhone: $clinicPhone, '
        'profileImage: ${profileImage?.path}, '
        'clinicImage: ${clinicImage?.path}'
        ')';
  }
}
