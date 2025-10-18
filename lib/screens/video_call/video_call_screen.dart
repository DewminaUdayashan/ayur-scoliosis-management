import 'package:ayur_scoliosis_management/providers/video_call/video_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final String appointmentId;

  const VideoCallScreen({super.key, required this.appointmentId});

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    // Delay joining the call until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _joinCall();
    });
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _joinCall() async {
    try {
      await ref.read(videoCallProvider.notifier).joinCall(widget.appointmentId);
    } catch (e) {
      print('Error joining call: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    // Don't automatically leave the call - user must explicitly end it
    // This allows them to navigate away and come back
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoCallState = ref.watch(videoCallProvider);

    // Set streams to renderers
    if (_isInitialized) {
      if (videoCallState.localStream != null) {
        _localRenderer.srcObject = videoCallState.localStream;
      }
      if (videoCallState.remoteStream != null) {
        _remoteRenderer.srcObject = videoCallState.remoteStream;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video (full screen)
            if (videoCallState.remoteStream != null)
              SizedBox.expand(
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.person_circle,
                      size: 100,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getStatusText(videoCallState.callState),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

            // Local video (small overlay)
            if (videoCallState.localStream != null)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),
              ),

            // Top bar with room info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withAlpha(178), Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.videocam_fill,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Video Call',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (videoCallState.room != null)
                            Text(
                              'Room: ${videoCallState.room!.roomId}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Error message
            if (videoCallState.callState == CallState.error)
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    videoCallState.error ?? 'An error occurred',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Bottom control bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withAlpha(178), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Toggle Audio
                    _buildControlButton(
                      icon: videoCallState.isAudioEnabled
                          ? CupertinoIcons.mic_fill
                          : CupertinoIcons.mic_slash_fill,
                      label: 'Mic',
                      onPressed: () {
                        ref.read(videoCallProvider.notifier).toggleAudio();
                      },
                      isActive: videoCallState.isAudioEnabled,
                    ),

                    // Toggle Video
                    _buildControlButton(
                      icon: videoCallState.isVideoEnabled
                          ? CupertinoIcons.video_camera_solid
                          : CupertinoIcons.video_camera_solid,
                      label: 'Camera',
                      onPressed: () {
                        ref.read(videoCallProvider.notifier).toggleVideo();
                      },
                      isActive: videoCallState.isVideoEnabled,
                    ),

                    // Switch Camera
                    _buildControlButton(
                      icon: CupertinoIcons.camera_rotate,
                      label: 'Flip',
                      onPressed: () {
                        ref.read(videoCallProvider.notifier).switchCamera();
                      },
                    ),

                    // Screen Share (if practitioner)
                    // TODO: Check if user is practitioner
                    _buildControlButton(
                      icon: videoCallState.isScreenSharing
                          ? CupertinoIcons.stop_circle
                          : CupertinoIcons.device_desktop,
                      label: videoCallState.isScreenSharing ? 'Stop' : 'Share',
                      onPressed: () async {
                        if (videoCallState.isScreenSharing) {
                          await ref
                              .read(videoCallProvider.notifier)
                              .stopScreenShare();
                        } else {
                          await ref
                              .read(videoCallProvider.notifier)
                              .startScreenShare();
                        }
                      },
                      isActive: videoCallState.isScreenSharing,
                    ),

                    // End Call
                    _buildControlButton(
                      icon: CupertinoIcons.phone_down_fill,
                      label: 'End',
                      onPressed: () async {
                        await ref.read(videoCallProvider.notifier).leaveCall();
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = true,
    Color? backgroundColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                (isActive ? Colors.white.withAlpha(51) : Colors.white24),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            iconSize: 28,
            onPressed: onPressed,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  String _getStatusText(CallState state) {
    switch (state) {
      case CallState.idle:
        return 'Initializing...';
      case CallState.connecting:
        return 'Connecting...';
      case CallState.connected:
        return 'Waiting for other participant...';
      case CallState.disconnected:
        return 'Call ended';
      case CallState.error:
        return 'Connection error';
    }
  }
}
