import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/patient/patient.dart';
import 'package:ayur_scoliosis_management/models/practitioner/practitioner.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.mustChangePassword,
    this.imageUrl,
    this.practitioner,
    this.patient,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final bool mustChangePassword;
  @JsonKey(name: 'profileImageUrl')
  final String? imageUrl;
  final Practitioner? practitioner;
  final Patient? patient;

  bool get isPractitioner => practitioner != null;
  bool get isPatient => patient != null;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  @override
  List<Object?> get props => [id, email];
}
