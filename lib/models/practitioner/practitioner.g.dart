// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practitioner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Practitioner _$PractitionerFromJson(Map<String, dynamic> json) => Practitioner(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  passwordHash: json['passwordHash'] as String,
  phone: json['phone'] as String,
  specialty: json['specialty'] as String,
  clinicId: json['clinicId'] as String,
);

Map<String, dynamic> _$PractitionerToJson(Practitioner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'phone': instance.phone,
      'specialty': instance.specialty,
      'clinicId': instance.clinicId,
    };
