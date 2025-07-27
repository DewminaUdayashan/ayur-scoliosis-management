import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'practitioner.g.dart';

@JsonSerializable()
class Practitioner extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String passwordHash;
  final String phone;
  final String specialty;
  final String clinicId;

  const Practitioner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passwordHash,
    required this.phone,
    required this.specialty,
    required this.clinicId,
  });

  factory Practitioner.fromJson(Map<String, dynamic> json) =>
      _$PractitionerFromJson(json);
  Map<String, dynamic> toJson() => _$PractitionerToJson(this);

  @override
  List<Object?> get props => [id];
}
