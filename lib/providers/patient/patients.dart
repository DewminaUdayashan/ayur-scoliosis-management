import 'package:ayur_scoliosis_management/core/utils/snacks.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated_request.dart';
import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';
import 'package:ayur_scoliosis_management/providers/patient/patient_service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patients.g.dart';

@riverpod
class Patients extends _$Patients {
  final int _page = 1;
  final int _pageSize = 10;

  @override
  Future<List<Paginated<AppUser>>> build(String? searchQuery) async {
    final patients = await ref
        .read(patientServiceProvider)
        .getPatients(
          PaginatedRequest(page: _page, pageSize: _pageSize),
          search: searchQuery,
        );
    return [patients];
  }

  Future<void> loadMore(String? searchQuery) async {
    final service = ref.watch(patientServiceProvider);
    final currentPages = state.value ?? [];
    final nextPage = currentPages.isEmpty
        ? 2
        : currentPages.last.meta.currentPage + 1;

    final patients = await service.getPatients(
      PaginatedRequest(page: nextPage, pageSize: _pageSize),
      search: searchQuery,
    );
    state = AsyncData([...currentPages, patients]);
  }

  Future<void> invitePatient(
    InvitePatientPayload payload, {
    required VoidCallback onSuccess,
    required ValueChanged<String?> onError,
  }) async {
    try {
      await ref.read(patientServiceProvider).invitePatient(payload);
      ref.invalidateSelf();
      showSuccessSnack('Invitation to the ${payload.email} sent successfully!');
      onSuccess();
    } catch (e) {
      onError(e.toString());
      showErrorSnack(e.toString());
    }
  }

  bool hasMore() {
    final currentState = state;
    if (currentState is AsyncData && currentState.value != null) {
      final pages = currentState.value!;
      if (pages.isNotEmpty) {
        final lastPage = pages.last;
        return lastPage.meta.currentPage < lastPage.meta.totalPages;
      }
    }
    return false;
  }
}
