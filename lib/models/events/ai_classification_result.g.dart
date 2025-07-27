// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_classification_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIClassificationResult _$AIClassificationResultFromJson(
  Map<String, dynamic> json,
) => AIClassificationResult(
  id: json['id'] as String,
  patientEventId: json['patientEventId'] as String,
  classificationResult: $enumDecode(
    _$AIClassificationTypeEnumMap,
    json['classificationResult'],
  ),
  confidenceScore: (json['confidenceScore'] as num).toDouble(),
  notes: json['notes'] as String,
);

Map<String, dynamic> _$AIClassificationResultToJson(
  AIClassificationResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'patientEventId': instance.patientEventId,
  'classificationResult':
      _$AIClassificationTypeEnumMap[instance.classificationResult]!,
  'confidenceScore': instance.confidenceScore,
  'notes': instance.notes,
};

const _$AIClassificationTypeEnumMap = {
  AIClassificationType.noScoliosisDetected: 'NoScoliosisDetected',
  AIClassificationType.scoliosisCCurve: 'ScoliosisCCurve',
  AIClassificationType.scoliosisSCurve: 'ScoliosisSCurve',
  AIClassificationType.notASpinalXray: 'NotASpinalXray',
  AIClassificationType.noXrayDetected: 'NoXrayDetected',
  AIClassificationType.analysisFailed: 'AnalysisFailed',
};
