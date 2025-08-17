import 'package:ayur_scoliosis_management/core/enums.dart';

class PaginatedRequest {
  PaginatedRequest({
    required this.page,
    required this.pageSize,
    required this.sortBy,
    required this.sortOrder,
    this.startDate,
    this.endDate,
  });
  final int page;
  final int pageSize;
  final String sortBy;
  final SortOrder sortOrder;
  final DateTime? startDate;
  final DateTime? endDate;

  Map<String, dynamic> get queryParameters {
    final queryParameters = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      'sortBy': sortBy,
      'sortOrder': sortOrder.value,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
    return queryParameters;
  }
}
