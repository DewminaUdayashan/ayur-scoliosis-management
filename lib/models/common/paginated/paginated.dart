import 'package:ayur_scoliosis_management/models/common/paginated/paginated.meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Paginated<T> {
  Paginated({required this.data, required this.meta});
  final List<T> data;
  final PaginatedMeta meta;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(T Function(T) toJsonT) =>
      _$PaginatedToJson(this, toJsonT);
}
