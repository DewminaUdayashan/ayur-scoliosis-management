// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  mustChangePassword: json['mustChangePassword'] as bool,
  joinedDate: DateTime.parse(json['joinedDate'] as String),
  phone: json['phone'] as String?,
  imageUrl: json['profileImageUrl'] as String?,
  practitioner: json['practitioner'] == null
      ? null
      : Practitioner.fromJson(json['practitioner'] as Map<String, dynamic>),
  patient: json['patient'] == null
      ? null
      : Patient.fromJson(json['patient'] as Map<String, dynamic>),
  lastAppointmentDate: json['lastAppointmentDate'] == null
      ? null
      : DateTime.parse(json['lastAppointmentDate'] as String),
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'role': _$UserRoleEnumMap[instance.role]!,
  'mustChangePassword': instance.mustChangePassword,
  'joinedDate': instance.joinedDate.toIso8601String(),
  'profileImageUrl': instance.imageUrl,
  'practitioner': instance.practitioner,
  'patient': instance.patient,
  'lastAppointmentDate': instance.lastAppointmentDate?.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.patient: 'Patient',
  UserRole.practitioner: 'Practitioner',
};
