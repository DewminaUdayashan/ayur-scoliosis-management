import 'package:json_annotation/json_annotation.dart';

part 'paginated.meta.g.dart';

@JsonSerializable()
class PaginatedMeta {
  PaginatedMeta({
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
  });
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final int totalPages;

  factory PaginatedMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginatedMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedMetaToJson(this);
}
