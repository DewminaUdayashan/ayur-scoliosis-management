import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinic.g.dart';

@JsonSerializable()
class Clinic extends Equatable {
  final String id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String email;
  final String phone;

  const Clinic({
    required this.id,
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.email,
    required this.phone,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicToJson(this);

  @override
  List<Object?> get props => [id];
}
