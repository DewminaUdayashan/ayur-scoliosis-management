// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  profileImageUrl: json['profileImageUrl'] as String?,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'profileImageUrl': instance.profileImageUrl,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'gender': _$GenderEnumMap[instance.gender]!,
};

const _$GenderEnumMap = {Gender.male: 'Male', Gender.female: 'Female'};
