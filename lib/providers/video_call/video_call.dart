import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/video_call/video_call_room.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/services/storage/secure_storage_service_impl.dart';
import 'package:ayur_scoliosis_management/services/video_call/signaling_service.dart';
import 'package:ayur_scoliosis_management/services/video_call/video_call_service.dart';
import 'package:ayur_scoliosis_management/services/video_call/webrtc_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_call.g.dart';

enum CallState { idle, connecting, connected, disconnected, error }

class VideoCallState {
  final CallState callState;
  final VideoCallRoomWithAppointment? room;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final bool isScreenSharing;
  final String? error;

  const VideoCallState({
    required this.callState,
    this.room,
    this.localStream,
    this.remoteStream,
    required this.isAudioEnabled,
    required this.isVideoEnabled,
    required this.isScreenSharing,
    this.error,
  });

  VideoCallState copyWith({
    CallState? callState,
    VideoCallRoomWithAppointment? room,
    MediaStream? localStream,
    MediaStream? remoteStream,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    bool? isScreenSharing,
    String? error,
  }) {
    return VideoCallState(
      callState: callState ?? this.callState,
      room: room ?? this.room,
      localStream: localStream ?? this.localStream,
      remoteStream: remoteStream ?? this.remoteStream,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      error: error,
    );
  }
}

@riverpod
class VideoCall extends _$VideoCall {
  late final VideoCallService _videoCallService;
  late final SignalingService _signalingService;
  late final WebRTCService _webrtcService;
  String? _currentRoomId;
  String? _currentUserId;

  @override
  VideoCallState build() {
    final dio = ref.watch(dioProvider);
    final api = Api();

    _videoCallService = VideoCallServiceImpl(api: api, client: dio);
    _signalingService = SignalingService(serverUrl: Api.baseUrl);
    _webrtcService = WebRTCService();

    // Listen to signaling events
    _signalingService.events.listen(_handleSignalingEvent);

    // Listen to WebRTC streams
    _webrtcService.localStream.listen((stream) {
      state = state.copyWith(localStream: stream);
    });

    _webrtcService.remoteStream.listen((stream) {
      state = state.copyWith(remoteStream: stream);
    });

    // Listen to ICE candidates
    _webrtcService.iceCandidate.listen((candidate) {
      if (_currentRoomId != null && _currentUserId != null) {
        _signalingService.sendSignal(_currentRoomId!, _currentUserId!, {
          'type': 'candidate',
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    });

    return const VideoCallState(
      callState: CallState.idle,
      isAudioEnabled: true,
      isVideoEnabled: true,
      isScreenSharing: false,
    );
  }

  /// Join a video call by appointment ID
  Future<void> joinCall(String appointmentId) async {
    try {
      // Check if already in a call
      if (state.callState == CallState.connected ||
          state.callState == CallState.connecting) {
        // If already in this appointment's call, just return
        if (state.room?.appointmentId == appointmentId) {
          return;
        }
        // Otherwise, leave current call first
        await leaveCall();
      }

      state = state.copyWith(callState: CallState.connecting);

      // Get room information
      final room = await _videoCallService.getRoomByAppointment(appointmentId);
      state = state.copyWith(room: room);

      _currentRoomId = room.roomId;

      // Get current user ID
      final user = ref.read(profileProvider).valueOrNull;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      _currentUserId = user.id;

      final token = await SecureStorageService.instance.read(
        SecureStorageService.tokenKey,
        (value) => value,
      );
      // Get auth token for signaling

      // Connect to signaling server
      _signalingService.connect(token: token!);

      // Initialize WebRTC
      await _webrtcService.initialize();

      // Join room
      _signalingService.joinRoom(room.roomId, user.id);

      state = state.copyWith(
        callState: CallState.connected,
        isAudioEnabled: _webrtcService.isAudioEnabled,
        isVideoEnabled: _webrtcService.isVideoEnabled,
      );
    } catch (e) {
      debugPrint('Error joining call: $e');
      state = state.copyWith(callState: CallState.error, error: e.toString());
    }
  }

  /// Handle signaling events from the server
  void _handleSignalingEvent(Map<String, dynamic> event) async {
    final eventType = event['event'] as String;
    final data = event['data'];

    debugPrint('Signaling event: $eventType');

    switch (eventType) {
      case 'joined-room':
        debugPrint('Successfully joined room');
        break;

      case 'user-joined':
        debugPrint('Another user joined');
        // Create and send offer
        final offer = await _webrtcService.createOffer();
        _signalingService.sendSignal(_currentRoomId!, _currentUserId!, {
          'type': 'offer',
          'sdp': offer.sdp,
        });
        break;

      case 'webrtc-signal':
        await _handleWebRTCSignal(data);
        break;

      case 'screen-share-started':
        debugPrint('Remote user started screen sharing');
        break;

      case 'screen-share-stopped':
        debugPrint('Remote user stopped screen sharing');
        break;

      case 'call-ended':
        await leaveCall();
        break;

      case 'user-left':
        debugPrint('User left the call');
        break;

      case 'error':
        state = state.copyWith(
          callState: CallState.error,
          error: data.toString(),
        );
        break;
    }
  }

  /// Handle WebRTC signaling messages
  Future<void> _handleWebRTCSignal(Map<String, dynamic> data) async {
    final signal = data['signal'] as Map<String, dynamic>;
    final signalType = signal['type'] as String;

    debugPrint('Received WebRTC signal: $signalType');

    try {
      if (signalType == 'offer') {
        // Set remote description
        await _webrtcService.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signalType),
        );

        // Create and send answer
        final answer = await _webrtcService.createAnswer();
        _signalingService.sendSignal(_currentRoomId!, _currentUserId!, {
          'type': 'answer',
          'sdp': answer.sdp,
        });
      } else if (signalType == 'answer') {
        // Set remote description
        await _webrtcService.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signalType),
        );
      } else if (signalType == 'candidate') {
        // Add ICE candidate
        await _webrtcService.addIceCandidate(
          RTCIceCandidate(
            signal['candidate'],
            signal['sdpMid'],
            signal['sdpMLineIndex'],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error handling WebRTC signal: $e');
      state = state.copyWith(callState: CallState.error, error: e.toString());
    }
  }

  /// Toggle audio
  void toggleAudio() {
    _webrtcService.toggleAudio();
    state = state.copyWith(isAudioEnabled: _webrtcService.isAudioEnabled);
  }

  /// Toggle video
  void toggleVideo() {
    _webrtcService.toggleVideo();
    state = state.copyWith(isVideoEnabled: _webrtcService.isVideoEnabled);
  }

  /// Switch camera
  Future<void> switchCamera() async {
    await _webrtcService.switchCamera();
  }

  /// Start screen sharing (practitioners only)
  Future<void> startScreenShare() async {
    try {
      await _webrtcService.startScreenShare();
      state = state.copyWith(isScreenSharing: true);

      if (_currentRoomId != null && _currentUserId != null) {
        _signalingService.startScreenShare(_currentRoomId!, _currentUserId!);
      }
    } catch (e) {
      debugPrint('Error starting screen share: $e');
      state = state.copyWith(callState: CallState.error, error: e.toString());
    }
  }

  /// Stop screen sharing
  Future<void> stopScreenShare() async {
    try {
      await _webrtcService.stopScreenShare();
      state = state.copyWith(isScreenSharing: false);

      if (_currentRoomId != null && _currentUserId != null) {
        _signalingService.stopScreenShare(_currentRoomId!, _currentUserId!);
      }
    } catch (e) {
      debugPrint('Error stopping screen share: $e');
    }
  }

  /// Leave the call
  Future<void> leaveCall() async {
    try {
      if (_currentRoomId != null && _currentUserId != null) {
        _signalingService.endCall(_currentRoomId!, _currentUserId!);
        _signalingService.leaveRoom(_currentRoomId!, _currentUserId!);
      }

      await _webrtcService.dispose();
      _signalingService.disconnect();

      _currentRoomId = null;
      _currentUserId = null;

      state = const VideoCallState(
        callState: CallState.disconnected,
        isAudioEnabled: true,
        isVideoEnabled: true,
        isScreenSharing: false,
      );
    } catch (e) {
      debugPrint('Error leaving call: $e');
    }
  }
}

/// Provider to get room by appointment ID
@riverpod
Future<VideoCallRoomWithAppointment> videoCallRoom(
  VideoCallRoomRef ref,
  String appointmentId,
) async {
  final dio = ref.watch(dioProvider);
  final api = Api();
  final service = VideoCallServiceImpl(api: api, client: dio);
  return service.getRoomByAppointment(appointmentId);
}
