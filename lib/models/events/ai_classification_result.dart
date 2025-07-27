import 'package:ayur_scoliosis_management/core/enums.dart'
    show AIClassificationType;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_classification_result.g.dart';

@JsonSerializable()
class AIClassificationResult extends Equatable {
  final String id;
  final String patientEventId;
  final AIClassificationType classificationResult;
  final double confidenceScore;
  final String notes;

  const AIClassificationResult({
    required this.id,
    required this.patientEventId,
    required this.classificationResult,
    required this.confidenceScore,
    required this.notes,
  });

  factory AIClassificationResult.fromJson(Map<String, dynamic> json) =>
      _$AIClassificationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AIClassificationResultToJson(this);

  @override
  List<Object?> get props => [id];
}
