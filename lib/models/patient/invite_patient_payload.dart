import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite_patient_payload.g.dart';

@JsonSerializable(createFactory: false)
class InvitePatientPayload {
  InvitePatientPayload({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
  });
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final Gender gender;

  Map<String, dynamic> toJson() => _$InvitePatientPayloadToJson(this);
}
