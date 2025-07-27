import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scoliosis_measurement.g.dart';

@JsonSerializable()
class ScoliosisMeasurement extends Equatable {
  final String id;
  final String patientEventId;
  final double cobbAngle;
  final double rotationAngle;
  final String notes;

  const ScoliosisMeasurement({
    required this.id,
    required this.patientEventId,
    required this.cobbAngle,
    required this.rotationAngle,
    required this.notes,
  });

  factory ScoliosisMeasurement.fromJson(Map<String, dynamic> json) =>
      _$ScoliosisMeasurementFromJson(json);
  Map<String, dynamic> toJson() => _$ScoliosisMeasurementToJson(this);

  @override
  List<Object?> get props => [id];
}
