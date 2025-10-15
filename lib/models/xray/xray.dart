import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'xray.g.dart';

@JsonSerializable()
class Xray {
  Xray({required this.id, required this.imageUrl, required this.notes});
  final String id;
  final String imageUrl;
  final String? notes;

  factory Xray.fromJson(Map<String, dynamic> json) => _$XrayFromJson(json);
  Map<String, dynamic> toJson() => _$XrayToJson(this);
}

class XRayModel {
  XRayModel({required this.image, this.notes});
  final File image;
  final String? notes;
}
