import 'package:ayur_scoliosis_management/core/enums.dart';

class PaginatedRequest {
  PaginatedRequest({
    required this.page,
    required this.pageSize,
    required this.sortBy,
    required this.sortOrder,
  });
  final int page;
  final int pageSize;
  final String sortBy;
  final SortOrder sortOrder;

  Map<String, dynamic> get queryParameters {
    final queryParameters = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      'sortBy': sortBy,
      'sortOrder': sortOrder.value,
    };
    return queryParameters;
  }
}
