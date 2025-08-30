// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_patient_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$InvitePatientPayloadToJson(
  InvitePatientPayload instance,
) => <String, dynamic>{
  'email': instance.email,
  'phone': instance.phone,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'gender': _$GenderEnumMap[instance.gender]!,
};

const _$GenderEnumMap = {Gender.male: 'Male', Gender.female: 'Female'};
