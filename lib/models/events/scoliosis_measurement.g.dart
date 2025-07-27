// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoliosis_measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoliosisMeasurement _$ScoliosisMeasurementFromJson(
  Map<String, dynamic> json,
) => ScoliosisMeasurement(
  id: json['id'] as String,
  patientEventId: json['patientEventId'] as String,
  cobbAngle: (json['cobbAngle'] as num).toDouble(),
  rotationAngle: (json['rotationAngle'] as num).toDouble(),
  notes: json['notes'] as String,
);

Map<String, dynamic> _$ScoliosisMeasurementToJson(
  ScoliosisMeasurement instance,
) => <String, dynamic>{
  'id': instance.id,
  'patientEventId': instance.patientEventId,
  'cobbAngle': instance.cobbAngle,
  'rotationAngle': instance.rotationAngle,
  'notes': instance.notes,
};
