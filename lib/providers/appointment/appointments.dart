import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated_request.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointments.g.dart';

@riverpod
class Appointments extends _$Appointments {
  final int _page = 1;
  final int _pageSize = 10;
  String _sortBy = 'appointmentDateTime';
  SortOrder _sortOrder = SortOrder.ascending;

  @override
  Future<List<Paginated<Appointment>>> build() async {
    final service = ref.watch(appointmentServiceProvider);
    final appointments = await service.getAppointments(
      PaginatedRequest(
        page: _page,
        pageSize: _pageSize,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
      null,
    );
    return [appointments];
  }

  Future<void> loadMore() async {
    final service = ref.watch(appointmentServiceProvider);
    final appointments = await service.getAppointments(
      PaginatedRequest(
        page: _page + 1,
        pageSize: _pageSize,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
      null,
    );
    state = AsyncData([...state.value ?? [], appointments]);
  }

  bool hasMore() {
    final currentState = state;
    if (currentState is AsyncData) {
      return currentState.value?.length == _pageSize;
    }
    return false;
  }

  void sortBy(String sortBy) {
    _sortBy = sortBy;
    ref.invalidateSelf();
  }

  void sortOrder(SortOrder sortOrder) {
    _sortOrder = sortOrder;
    ref.invalidateSelf();
  }
}
