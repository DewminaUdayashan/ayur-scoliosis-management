// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedMeta _$PaginatedMetaFromJson(Map<String, dynamic> json) =>
    PaginatedMeta(
      totalCount: (json['totalCount'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedMetaToJson(PaginatedMeta instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalPages': instance.totalPages,
    };
