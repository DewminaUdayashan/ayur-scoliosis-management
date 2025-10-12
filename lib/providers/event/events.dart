import 'package:ayur_scoliosis_management/providers/event/event_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/patient/patient_event.dart';

part 'events.g.dart';

@riverpod
Future<List<PatientEvent>> events(Ref ref, String? patientId) async {
  final service = ref.watch(eventServiceProvider);
  final events = await service.getEvents(patientId);
  return events.data;
}
