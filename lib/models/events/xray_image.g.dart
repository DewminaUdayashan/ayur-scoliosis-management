// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xray_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XRayImage _$XRayImageFromJson(Map<String, dynamic> json) => XRayImage(
  id: json['id'] as String,
  patientEventId: json['patientEventId'] as String,
  imageUrl: json['imageUrl'] as String,
  notes: json['notes'] as String,
);

Map<String, dynamic> _$XRayImageToJson(XRayImage instance) => <String, dynamic>{
  'id': instance.id,
  'patientEventId': instance.patientEventId,
  'imageUrl': instance.imageUrl,
  'notes': instance.notes,
};
