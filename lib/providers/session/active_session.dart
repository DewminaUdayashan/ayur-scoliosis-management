import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents an active session (physical or remote)
class ActiveSession {
  final String appointmentId;
  final String appointmentType; // 'Physical' or 'Remote'
  final DateTime startTime;
  final String notes;

  ActiveSession({
    required this.appointmentId,
    required this.appointmentType,
    required this.startTime,
    this.notes = '',
  });

  ActiveSession copyWith({
    String? appointmentId,
    String? appointmentType,
    DateTime? startTime,
    String? notes,
  }) {
    return ActiveSession(
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentType: appointmentType ?? this.appointmentType,
      startTime: startTime ?? this.startTime,
      notes: notes ?? this.notes,
    );
  }
}

class ActiveSessionNotifier extends StateNotifier<ActiveSession?> {
  ActiveSessionNotifier() : super(null);

  void startSession(String appointmentId, String appointmentType) {
    state = ActiveSession(
      appointmentId: appointmentId,
      appointmentType: appointmentType,
      startTime: DateTime.now(),
    );
  }

  void updateNotes(String notes) {
    if (state != null) {
      state = state!.copyWith(notes: notes);
    }
  }

  void endSession() {
    state = null;
  }

  bool isSessionActive(String appointmentId) {
    return state?.appointmentId == appointmentId;
  }
}

final activeSessionProvider =
    StateNotifierProvider<ActiveSessionNotifier, ActiveSession?>((ref) {
      return ActiveSessionNotifier();
    });
