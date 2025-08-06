// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practitioner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Practitioner _$PractitionerFromJson(Map<String, dynamic> json) => Practitioner(
  phone: json['phone'] as String,
  specialty: json['specialty'] as String,
  medicalLicense: json['medicalLicense'] as String,
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  clinicId: json['clinicId'] as String,
);

Map<String, dynamic> _$PractitionerToJson(Practitioner instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'specialty': instance.specialty,
      'medicalLicense': instance.medicalLicense,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'clinicId': instance.clinicId,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.pending: 'Pending',
  AccountStatus.active: 'Active',
  AccountStatus.inactive: 'Inactive',
  AccountStatus.suspended: 'Suspended',
};
