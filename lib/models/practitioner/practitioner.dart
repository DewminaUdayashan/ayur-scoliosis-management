import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/clinic/clinic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'practitioner.g.dart';

@JsonSerializable()
class Practitioner {
  const Practitioner({
    required this.specialty,
    required this.medicalLicense,
    required this.status,
    required this.clinicId,
    this.clinic,
  });
  final String specialty;
  final String medicalLicense;
  final AccountStatus status;
  final String clinicId;
  final Clinic? clinic;

  factory Practitioner.fromJson(Map<String, dynamic> json) =>
      _$PractitionerFromJson(json);
  Map<String, dynamic> toJson() => _$PractitionerToJson(this);
}
