import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
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

class _VideoCallScreenState extends ConsumerState<VideoCallScreen>
    with SingleTickerProviderStateMixin {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isInitialized = false;

  // For draggable local video preview - start at bottom right
  Offset? _localVideoPosition;

  // For auto-hiding UI controls
  bool _showControls = true;
  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;

  @override
  void initState() {
    super.initState();
    _initRenderers();

    // Setup animation controller for controls
    _controlsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controlsAnimation = CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    );

    // Show controls initially
    _controlsAnimationController.forward();

    // Auto-hide controls after 3 seconds
    _scheduleControlsAutoHide();

    // Delay joining the call until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _joinCall();
      _setInitialLocalVideoPosition();
    });
  }

  void _setInitialLocalVideoPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final size = renderBox.size;
          // Position at bottom right, above the controls (100px from bottom)
          setState(() {
            _localVideoPosition = Offset(
              size.width - 120 - 20, // 20px from right edge
              size.height - 160 - 120, // 120px from bottom (above controls)
            );
          });
        }
      }
    });
  }

  void _scheduleControlsAutoHide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        _hideControls();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _controlsAnimationController.forward();
        _scheduleControlsAutoHide();
      } else {
        _controlsAnimationController.reverse();
      }
    });
  }

  void _hideControls() {
    if (mounted) {
      setState(() {
        _showControls = false;
        _controlsAnimationController.reverse();
      });
    }
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
    _controlsAnimationController.dispose();
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

    // Get participant name for placeholder
    final participantName = _getParticipantName(videoCallState);

    // Check if remote video is actually available
    // Use the remoteVideoEnabled state that comes from signaling
    final hasRemoteVideo =
        videoCallState.remoteStream != null &&
        videoCallState.callState == CallState.connected &&
        videoCallState
            .remoteVideoEnabled; // Use signaling state instead of track detection

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Remote video (full screen) or placeholder with initials
            // Show placeholder if no stream OR if connected but video is off
            if (hasRemoteVideo)
              SizedBox.expand(
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  placeholderBuilder: (context) =>
                      _buildRemotePlaceholder(videoCallState, participantName),
                ),
              )
            else
              _buildRemotePlaceholder(videoCallState, participantName),

            // Local video (small draggable overlay)
            if (_localVideoPosition != null)
              Positioned(
                left: _localVideoPosition!.dx,
                top: _localVideoPosition!.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final newPosition = _localVideoPosition! + details.delta;
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final size = renderBox.size;

                      // Constrain position to screen bounds
                      double newX = newPosition.dx.clamp(0.0, size.width - 120);
                      double newY = newPosition.dy.clamp(
                        0.0,
                        size.height - 160,
                      );

                      _localVideoPosition = Offset(newX, newY);
                    });
                  },
                  child: _buildLocalVideoPreview(videoCallState),
                ),
              ),

            // Top bar with room info (animated)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controlsAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -80 * (1 - _controlsAnimation.value)),
                    child: Opacity(
                      opacity: _controlsAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
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
                            Text(
                              participantName,
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

            // Bottom control bar (animated)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controlsAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 100 * (1 - _controlsAnimation.value)),
                    child: Opacity(
                      opacity: _controlsAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                  ),
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
                        label: videoCallState.isScreenSharing
                            ? 'Stop'
                            : 'Share',
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
                          await ref
                              .read(videoCallProvider.notifier)
                              .leaveCall();
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

  String _getParticipantName(VideoCallState state) {
    if (state.room?.appointment != null) {
      final appointment = state.room!.appointment!;

      // Get current user to determine which name to show
      final currentUser = ref.read(profileProvider).valueOrNull;
      if (currentUser == null) return 'Participant';

      final currentUserId = currentUser.id;

      // Get practitioner info
      final practitioner = appointment['practitioner'] as Map<String, dynamic>?;
      final practitionerId = practitioner?['id'] as String?;
      final practitionerFirstName = practitioner?['firstName'] ?? '';
      final practitionerLastName = practitioner?['lastName'] ?? '';
      final practitionerFullName =
          'Dr. $practitionerFirstName $practitionerLastName'.trim();

      // Get patient info
      final patient = appointment['patient'] as Map<String, dynamic>?;
      final patientId = patient?['id'] as String?;
      final patientFirstName = patient?['firstName'] ?? '';
      final patientLastName = patient?['lastName'] ?? '';
      final patientFullName = '$patientFirstName $patientLastName'.trim();

      // If current user is the practitioner, show patient's name
      if (currentUserId == practitionerId) {
        return patientFullName.isNotEmpty ? patientFullName : 'Patient';
      }

      // If current user is the patient, show practitioner's name
      if (currentUserId == patientId) {
        return practitionerFullName.isNotEmpty
            ? practitionerFullName
            : 'Practitioner';
      }

      // Fallback: try to determine from role
      if (practitionerFullName.isNotEmpty) {
        return practitionerFullName;
      }
      if (patientFullName.isNotEmpty) {
        return patientFullName;
      }
    }
    return 'Participant';
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }

  Widget _buildRemotePlaceholder(VideoCallState state, String participantName) {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar with initials
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _getInitials(participantName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              participantName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Show "Camera Off" indicator if connected but no active video
            // or show the status text if not connected yet
            if (state.callState == CallState.connected &&
                state.remoteStream != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam_off, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Camera is off',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(
                _getStatusText(state.callState),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalVideoPreview(
    VideoCallState videoCallState, {
    bool isDragging = false,
  }) {
    const double width = 120;
    const double height = 160;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: isDragging ? 3 : 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Show video if camera is on and stream exists
            if (videoCallState.isVideoEnabled &&
                videoCallState.localStream != null &&
                _isInitialized)
              RTCVideoView(
                _localRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              )
            else
              // Show placeholder when camera is off
              Container(
                color: Colors.grey.shade900,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        videoCallState.isVideoEnabled
                            ? Icons.videocam
                            : Icons.videocam_off,
                        color: Colors.white70,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        videoCallState.isVideoEnabled
                            ? 'Loading...'
                            : 'Camera Off',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Drag handle indicator
            if (!isDragging)
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 30,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
