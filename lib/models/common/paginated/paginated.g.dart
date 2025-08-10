// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paginated<T> _$PaginatedFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => Paginated<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  meta: PaginatedMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedToJson<T>(
  Paginated<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'meta': instance.meta,
};
