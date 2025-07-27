// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  passwordHash: json['passwordHash'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String,
  clinicId: json['clinicId'] as String,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'passwordHash': instance.passwordHash,
  'profileImageUrl': instance.profileImageUrl,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'gender': instance.gender,
  'clinicId': instance.clinicId,
};
