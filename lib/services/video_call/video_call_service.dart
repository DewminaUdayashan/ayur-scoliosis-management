import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/video_call/video_call_room.dart';
import 'package:dio/dio.dart';

abstract class VideoCallService {
  /// Get video call room by appointment ID
  Future<VideoCallRoomWithAppointment> getRoomByAppointment(
    String appointmentId,
  );

  /// Create a video call room for an appointment
  Future<String> createRoomForAppointment(String appointmentId);
}

class VideoCallServiceImpl extends VideoCallService {
  VideoCallServiceImpl({required this.api, required this.client});

  final Api api;
  final Dio client;

  @override
  Future<VideoCallRoomWithAppointment> getRoomByAppointment(
    String appointmentId,
  ) async {
    try {
      final response = await client.get(
        api.videoCallRoomByAppointment(appointmentId),
      );

      if (response.statusCode == 200) {
        return VideoCallRoomWithAppointment.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to get video call room');
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<String> createRoomForAppointment(String appointmentId) async {
    try {
      final response = await client.post(
        api.createVideoCallRoom(appointmentId),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['roomId'] as String;
      }

      throw Exception('Failed to create video call room');
    } on DioException catch (e) {
      throw e.processException();
    }
  }
}
