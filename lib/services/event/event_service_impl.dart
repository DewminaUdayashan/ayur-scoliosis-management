import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/patient/patient_event.dart';
import 'package:ayur_scoliosis_management/services/event/event_service.dart';
import 'package:dio/dio.dart';

import '../../core/utils/api.dart';

class EventServiceImpl implements EventService {
  EventServiceImpl({required this.client, required this.api});
  final Dio client;
  final Api api;

  @override
  Future<Paginated<PatientEvent>> getEvents(String? patientId) async {
    try {
      final url = api.eventsPath;
      final queryParameters = patientId != null
          ? {'patientId': patientId}
          : null;
      final response = await client.get(url, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return Paginated.fromJson(
          response.data,
          (json) => PatientEvent.fromJson(json as Map<String, dynamic>),
        );
      } else {
        throw Exception('Failed to load events');
      }
    } on DioException catch (e) {
      throw e.processException();
    }
  }
}
