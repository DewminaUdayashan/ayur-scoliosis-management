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
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  phone: json['phone'] as String,
  specialty: json['specialty'] as String,
  medicalLicense: json['medicalLicense'] as String,
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  clinicId: json['clinicId'] as String,
);

Map<String, dynamic> _$PractitionerToJson(Practitioner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'role': _$UserRoleEnumMap[instance.role]!,
      'phone': instance.phone,
      'specialty': instance.specialty,
      'medicalLicense': instance.medicalLicense,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'clinicId': instance.clinicId,
    };

const _$UserRoleEnumMap = {
  UserRole.patient: 'Patient',
  UserRole.practitioner: 'Practitioner',
};

const _$AccountStatusEnumMap = {
  AccountStatus.pending: 'Pending',
  AccountStatus.active: 'Active',
  AccountStatus.inactive: 'Inactive',
  AccountStatus.suspended: 'Suspended',
};
