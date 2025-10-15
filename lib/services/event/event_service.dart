import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/patient/patient_event.dart';

abstract class EventService {
  Future<Paginated<PatientEvent>> getEvents(String? patientId);
}
