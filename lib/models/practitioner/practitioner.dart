import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'practitioner.g.dart';

@JsonSerializable()
class Practitioner {
  final String phone;
  final String specialty;
  final String medicalLicense;
  final AccountStatus status;
  final String clinicId;

  const Practitioner({
    required this.phone,
    required this.specialty,
    required this.medicalLicense,
    required this.status,
    required this.clinicId,
  });

  factory Practitioner.fromJson(Map<String, dynamic> json) =>
      _$PractitionerFromJson(json);
  Map<String, dynamic> toJson() => _$PractitionerToJson(this);
}
