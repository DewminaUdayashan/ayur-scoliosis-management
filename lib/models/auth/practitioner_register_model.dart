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

  /// Validate the DTO fields
  List<String> validate() {
    final errors = <String>[];

    // Email validation
    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Email format is invalid');
    }

    // Password validation
    if (password.isEmpty) {
      errors.add('Password is required');
    } else if (password.length < 8) {
      errors.add('Password must be at least 8 characters long');
    }

    // Required fields validation
    if (firstName.isEmpty) errors.add('First name is required');
    if (lastName.isEmpty) errors.add('Last name is required');
    if (phone.isEmpty) errors.add('Phone is required');
    if (specialty.isEmpty) errors.add('Specialty is required');
    if (medicalLicense.isEmpty) errors.add('Medical license is required');
    if (clinicName.isEmpty) errors.add('Clinic name is required');
    if (clinicAddressLine1.isEmpty)
      errors.add('Clinic address line 1 is required');
    if (clinicCity.isEmpty) errors.add('Clinic city is required');

    // Clinic email validation
    if (clinicEmail.isEmpty) {
      errors.add('Clinic email is required');
    } else if (!_isValidEmail(clinicEmail)) {
      errors.add('Clinic email format is invalid');
    }

    if (clinicPhone.isEmpty) errors.add('Clinic phone is required');

    return errors;
  }

  /// Check if the DTO is valid
  bool get isValid => validate().isEmpty;

  /// Helper method to validate email format
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

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
