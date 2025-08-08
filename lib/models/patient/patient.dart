import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient {
  const Patient({
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.clinicId,
  });
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final String clinicId;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
