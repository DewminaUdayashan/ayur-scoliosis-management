import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Service for handling WebSocket signaling for WebRTC video calls
class SignalingService {
  IO.Socket? _socket;
  final String serverUrl;
  final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  SignalingService({required this.serverUrl});

  /// Stream for listening to all socket events
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  /// Connect to the signaling server
  void connect({String? token}) {
    try {
      _socket = IO.io(
        '$serverUrl/video-call',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'authorization': 'Bearer $token'})
            .build(),
      );

      _socket?.on('connect', (_) {
        debugPrint('Connected to signaling server');
        _eventController.add({'event': 'connect', 'data': null});
      });

      _socket?.on('disconnect', (_) {
        debugPrint('Disconnected from signaling server');
        _eventController.add({'event': 'disconnect', 'data': null});
      });

      _socket?.on('connect_error', (error) {
        debugPrint('Connection error: $error');
        _eventController.add({
          'event': 'connect_error',
          'data': error.toString(),
        });
      });

      _socket?.on('joined-room', (data) {
        debugPrint('Joined room: $data');
        _eventController.add({'event': 'joined-room', 'data': data});
      });

      _socket?.on('user-joined', (data) {
        debugPrint('User joined: $data');
        _eventController.add({'event': 'user-joined', 'data': data});
      });

      _socket?.on('user-left', (data) {
        debugPrint('User left: $data');
        _eventController.add({'event': 'user-left', 'data': data});
      });

      _socket?.on('webrtc-signal', (data) {
        debugPrint('Received WebRTC signal: ${data['signal']['type']}');
        _eventController.add({'event': 'webrtc-signal', 'data': data});
      });

      _socket?.on('screen-share-started', (data) {
        debugPrint('Screen share started: $data');
        _eventController.add({'event': 'screen-share-started', 'data': data});
      });

      _socket?.on('screen-share-stopped', (data) {
        debugPrint('Screen share stopped: $data');
        _eventController.add({'event': 'screen-share-stopped', 'data': data});
      });

      _socket?.on('call-ended', (data) {
        debugPrint('Call ended: $data');
        _eventController.add({'event': 'call-ended', 'data': data});
      });

      _socket?.on('error', (error) {
        debugPrint('Socket error: $error');
        _eventController.add({'event': 'error', 'data': error});
      });

      _socket?.connect();
    } catch (e) {
      debugPrint('Failed to connect: $e');
      _eventController.add({'event': 'error', 'data': e.toString()});
    }
  }

  /// Join a video call room
  void joinRoom(String roomId, String userId) {
    _socket?.emit('join-room', {'roomId': roomId, 'userId': userId});
  }

  /// Leave a video call room
  void leaveRoom(String roomId, String userId) {
    _socket?.emit('leave-room', {'roomId': roomId, 'userId': userId});
  }

  /// Send WebRTC signaling data
  void sendSignal(String roomId, String userId, Map<String, dynamic> signal) {
    _socket?.emit('webrtc-signal', {
      'roomId': roomId,
      'userId': userId,
      'signal': signal,
    });
  }

  /// Start screen sharing
  void startScreenShare(String roomId, String userId) {
    _socket?.emit('screen-share-start', {'roomId': roomId, 'userId': userId});
  }

  /// Stop screen sharing
  void stopScreenShare(String roomId, String userId) {
    _socket?.emit('screen-share-stop', {'roomId': roomId, 'userId': userId});
  }

  /// End the call
  void endCall(String roomId, String userId) {
    _socket?.emit('end-call', {'roomId': roomId, 'userId': userId});
  }

  /// Check if connected
  bool get isConnected => _socket?.connected ?? false;

  /// Disconnect from the signaling server
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _eventController.close();
  }
}
