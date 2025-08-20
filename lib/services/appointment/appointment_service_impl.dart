import 'dart:async';

import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment_respond.dart';
import 'package:ayur_scoliosis_management/models/appointment/schedule_appointment_payload.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated_request.dart';
import 'package:ayur_scoliosis_management/services/appointment/appointment_service.dart';
import 'package:dio/dio.dart';

import '../../core/utils/logger.dart';

class AppointmentServiceImpl extends AppointmentService {
  AppointmentServiceImpl({required this.api, required this.client});
  final Api api;
  final Dio client;

  @override
  Future<Paginated<Appointment>> getAppointments(
    PaginatedRequest request,
    String? patientId,
  ) async {
    try {
      final response = await client.get(
        api.appointmentsPath,
        queryParameters: {
          ...request.queryParameters,
          if (patientId != null) 'patientId': patientId,
        },
      );
      return Paginated.fromJson(
        response.data,
        (json) => Appointment.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e, stack) {
      Log.e('Error fetching appointments: ${e.message}');
      Log.e('Stack trace: $stack');
      throw e.processException();
    }
  }

  @override
  Future<Appointment> appointmentDetails(String id) async {
    try {
      final response = await client.get(api.appointmentDetails(id));
      return Appointment.fromJson(response.data);
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<Appointment> scheduleAppointment(
    ScheduleAppointmentPayload payload,
  ) async {
    try {
      final response = await client.post(
        api.scheduleAppointment,
        data: payload.toJson(),
      );
      return Appointment.fromJson(response.data);
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<List<Appointment>> upcomingAppointments() async {
    try {
      final response = await client.get(api.upcomingAppointments);
      return (response.data as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } on DioException catch (e) {
      Log.e('Error fetching upcoming appointments: ${e.message}');
      throw e.processException();
    }
  }

  @override
  Future<void> respondToAppointment(AppointmentRespond respond) async {
    try {
      await client.patch(
        api.respondToAppointment(respond.id),
        data: respond.toJson(),
      );
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<List<DateTime>> getAppointmentDates(DateTime from, DateTime to) async {
    try {
      final response = await client.get(
        api.dates,
        queryParameters: {
          'start': from.toIso8601String(),
          'end': to.toIso8601String(),
        },
      );
      return List<DateTime>.from(
        response.data.map((dateStr) => DateTime.parse(dateStr)),
      );
    } on DioException catch (e) {
      throw e.processException();
    }
  }
}
