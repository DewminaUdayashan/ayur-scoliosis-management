import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'xray_image.g.dart';

@JsonSerializable()
class XRayImage extends Equatable {
  final String id;
  final String patientEventId;
  final String imageUrl;
  final String notes;

  const XRayImage({
    required this.id,
    required this.patientEventId,
    required this.imageUrl,
    required this.notes,
  });

  factory XRayImage.fromJson(Map<String, dynamic> json) =>
      _$XRayImageFromJson(json);
  Map<String, dynamic> toJson() => _$XRayImageToJson(this);

  @override
  List<Object?> get props => [id];
}
