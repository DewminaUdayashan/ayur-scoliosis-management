import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Service for managing WebRTC peer connections
class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  MediaStream? _screenStream;

  final StreamController<MediaStream> _localStreamController =
      StreamController<MediaStream>.broadcast();
  final StreamController<MediaStream> _remoteStreamController =
      StreamController<MediaStream>.broadcast();
  final StreamController<RTCIceCandidate> _iceCandidateController =
      StreamController<RTCIceCandidate>.broadcast();

  Stream<MediaStream> get localStream => _localStreamController.stream;
  Stream<MediaStream> get remoteStream => _remoteStreamController.stream;
  Stream<RTCIceCandidate> get iceCandidate => _iceCandidateController.stream;

  MediaStream? get currentLocalStream => _localStream;
  MediaStream? get currentRemoteStream => _remoteStream;

  /// ICE server configuration
  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
    ],
  };

  /// Media constraints
  final Map<String, dynamic> _mediaConstraints = {
    'audio': true,
    'video': {
      'facingMode': 'user',
      'optional': [
        {'minWidth': '640'},
        {'minHeight': '480'},
        {'minFrameRate': '30'},
      ],
    },
  };

  /// Initialize WebRTC with local media
  Future<void> initialize() async {
    try {
      // Get user media
      _localStream = await navigator.mediaDevices.getUserMedia(
        _mediaConstraints,
      );
      _localStreamController.add(_localStream!);

      // Create peer connection
      _peerConnection = await createPeerConnection(_configuration);

      // Add local stream to peer connection
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      // Handle ICE candidates
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        debugPrint('New ICE candidate: ${candidate.candidate}');
        _iceCandidateController.add(candidate);
      };

      // Handle remote stream
      _peerConnection!.onTrack = (RTCTrackEvent event) {
        debugPrint('Got remote track: ${event.track.kind}');
        if (event.streams.isNotEmpty) {
          _remoteStream = event.streams[0];
          _remoteStreamController.add(_remoteStream!);
        }
      };

      // Handle connection state changes
      _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
        debugPrint('Connection state: $state');
      };

      // Handle ICE connection state changes
      _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
        debugPrint('ICE connection state: $state');
      };

      debugPrint('WebRTC initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize WebRTC: $e');
      rethrow;
    }
  }

  /// Create an offer
  Future<RTCSessionDescription> createOffer() async {
    try {
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      return offer;
    } catch (e) {
      debugPrint('Failed to create offer: $e');
      rethrow;
    }
  }

  /// Create an answer
  Future<RTCSessionDescription> createAnswer() async {
    try {
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      return answer;
    } catch (e) {
      debugPrint('Failed to create answer: $e');
      rethrow;
    }
  }

  /// Set remote description
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    try {
      await _peerConnection!.setRemoteDescription(description);
      debugPrint('Set remote description: ${description.type}');
    } catch (e) {
      debugPrint('Failed to set remote description: $e');
      rethrow;
    }
  }

  /// Add ICE candidate
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    try {
      await _peerConnection!.addCandidate(candidate);
      debugPrint('Added ICE candidate');
    } catch (e) {
      debugPrint('Failed to add ICE candidate: $e');
      rethrow;
    }
  }

  /// Toggle audio
  void toggleAudio() {
    if (_localStream != null) {
      final audioTracks = _localStream!.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        final enabled = audioTracks[0].enabled;
        audioTracks[0].enabled = !enabled;
        debugPrint('Audio ${!enabled ? 'enabled' : 'disabled'}');
      }
    }
  }

  /// Toggle video
  void toggleVideo() {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        final enabled = videoTracks[0].enabled;
        videoTracks[0].enabled = !enabled;
        debugPrint('Video ${!enabled ? 'enabled' : 'disabled'}');
      }
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        await Helper.switchCamera(videoTracks[0]);
        debugPrint('Camera switched');
      }
    }
  }

  /// Start screen sharing (for practitioners)
  Future<void> startScreenShare() async {
    try {
      _screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': false,
      });

      // Replace video track with screen share
      final screenTrack = _screenStream!.getVideoTracks()[0];
      final senders = await _peerConnection!.getSenders();
      final sender = senders.firstWhere((s) => s.track?.kind == 'video');
      await sender.replaceTrack(screenTrack);

      // Handle screen share stop
      screenTrack.onEnded = () {
        stopScreenShare();
      };

      debugPrint('Screen sharing started');
    } catch (e) {
      debugPrint('Failed to start screen share: $e');
      rethrow;
    }
  }

  /// Stop screen sharing
  Future<void> stopScreenShare() async {
    try {
      if (_screenStream != null) {
        _screenStream!.getTracks().forEach((track) => track.stop());
        _screenStream = null;

        // Switch back to camera
        final videoTrack = _localStream!.getVideoTracks()[0];
        final senders = await _peerConnection!.getSenders();
        final sender = senders.firstWhere((s) => s.track?.kind == 'video');
        await sender.replaceTrack(videoTrack);

        debugPrint('Screen sharing stopped');
      }
    } catch (e) {
      debugPrint('Failed to stop screen share: $e');
      rethrow;
    }
  }

  /// Check if audio is enabled
  bool get isAudioEnabled {
    if (_localStream != null) {
      final audioTracks = _localStream!.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        return audioTracks[0].enabled;
      }
    }
    return false;
  }

  /// Check if video is enabled
  bool get isVideoEnabled {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        return videoTracks[0].enabled;
      }
    }
    return false;
  }

  /// Check if screen sharing
  bool get isScreenSharing => _screenStream != null;

  /// Close connection and release resources
  Future<void> dispose() async {
    try {
      // Stop all tracks
      _localStream?.getTracks().forEach((track) => track.stop());
      _remoteStream?.getTracks().forEach((track) => track.stop());
      _screenStream?.getTracks().forEach((track) => track.stop());

      // Close peer connection
      await _peerConnection?.close();
      _peerConnection?.dispose();

      // Dispose streams
      await _localStream?.dispose();
      await _remoteStream?.dispose();
      await _screenStream?.dispose();

      // Close controllers
      await _localStreamController.close();
      await _remoteStreamController.close();
      await _iceCandidateController.close();

      _localStream = null;
      _remoteStream = null;
      _screenStream = null;
      _peerConnection = null;

      debugPrint('WebRTC disposed');
    } catch (e) {
      debugPrint('Error disposing WebRTC: $e');
    }
  }
}
