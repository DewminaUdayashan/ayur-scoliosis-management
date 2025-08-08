import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinic.g.dart';

@JsonSerializable()
class Clinic extends Equatable {
  const Clinic({
    required this.id,
    required this.registrationId,
    required this.name,
    this.imageUrl,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.email,
    required this.phone,
  });
  final String id;
  final String registrationId;
  final String name;
  final String? imageUrl;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String email;
  final String phone;

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicToJson(this);

  @override
  List<Object?> get props => [id, registrationId];
}
