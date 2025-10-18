import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/providers/video_call/is_in_call.dart';
import 'package:ayur_scoliosis_management/providers/video_call/video_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoCallScreen extends HookConsumerWidget {
  final String appointmentId;

  const VideoCallScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize video renderers
    final localRenderer = useMemoized(() => RTCVideoRenderer());
    final remoteRenderer = useMemoized(() => RTCVideoRenderer());
    final isInitialized = useState(false);

    // State for draggable local video preview
    final localVideoPosition = useState<Offset?>(null);

    // State for auto-hiding UI controls
    final showControls = useState(true);

    // Animation controller for controls
    final controlsAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final controlsAnimation = useMemoized(
      () => CurvedAnimation(
        parent: controlsAnimationController,
        curve: Curves.easeInOut,
      ),
      [controlsAnimationController],
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(isInCallProvider.notifier).setInCall(true);
      });
      return () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(isInCallProvider.notifier).setInCall(false);
        });
      };
    }, [controlsAnimationController]);

    // Initialize renderers
    useEffect(() {
      Future<void> initRenderers() async {
        await localRenderer.initialize();
        await remoteRenderer.initialize();
        isInitialized.value = true;
      }

      initRenderers();

      // Cleanup
      return () {
        localRenderer.dispose();
        remoteRenderer.dispose();
      };
    }, []);

    // Join call on mount
    useEffect(() {
      Future<void> joinCall() async {
        try {
          await ref.read(videoCallProvider.notifier).joinCall(appointmentId);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to join call: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        joinCall();
      });

      return null;
    }, []);

    // Set initial local video position
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final size = renderBox.size;
            localVideoPosition.value = Offset(
              size.width - 120 - 20, // 20px from right edge
              size.height - 160 - 120, // 120px from bottom (above controls)
            );
          }
        }
      });
      return null;
    }, []);

    // Show controls initially and setup animation
    useEffect(() {
      controlsAnimationController.forward();
      return null;
    }, []);

    // Auto-hide controls after 3 seconds
    useEffect(() {
      Future<void> scheduleAutoHide() async {
        await Future.delayed(const Duration(seconds: 3));
        if (context.mounted && showControls.value) {
          showControls.value = false;
          controlsAnimationController.reverse();
        }
      }

      scheduleAutoHide();
      return null;
    }, [showControls.value]);

    // Toggle controls function
    void toggleControls() {
      showControls.value = !showControls.value;
      if (showControls.value) {
        controlsAnimationController.forward();
      } else {
        controlsAnimationController.reverse();
      }
    }

    // Watch video call state
    final videoCallState = ref.watch(videoCallProvider);

    // Set streams to renderers
    useEffect(
      () {
        if (isInitialized.value) {
          if (videoCallState.localStream != null) {
            localRenderer.srcObject = videoCallState.localStream;
          }
          if (videoCallState.remoteStream != null) {
            remoteRenderer.srcObject = videoCallState.remoteStream;
          }
        }
        return null;
      },
      [
        isInitialized.value,
        videoCallState.localStream,
        videoCallState.remoteStream,
      ],
    );

    // Helper function to get participant name
    String getParticipantName(VideoCallState state) {
      if (state.room?.appointment != null) {
        final appointment = state.room!.appointment!;

        // Get current user to determine which name to show
        final currentUser = ref.read(profileProvider).valueOrNull;
        if (currentUser == null) return 'Participant';

        final currentUserId = currentUser.id;

        // Get practitioner info
        final practitioner =
            appointment['practitioner'] as Map<String, dynamic>?;
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

    // Get participant name for placeholder
    final participantName = getParticipantName(videoCallState);

    // Check if remote video is actually available
    // Use the remoteVideoEnabled state that comes from signaling
    final hasRemoteVideo =
        videoCallState.remoteStream != null &&
        videoCallState.callState == CallState.connected &&
        videoCallState.remoteVideoEnabled;

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref.read(isInCallProvider.notifier).setInCall(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: toggleControls,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              // Remote video (full screen) or placeholder with initials
              // Show placeholder if no stream OR if connected but video is off
              if (hasRemoteVideo)
                SizedBox.expand(
                  child: RTCVideoView(
                    remoteRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    placeholderBuilder: (context) => _buildRemotePlaceholder(
                      videoCallState,
                      participantName,
                    ),
                  ),
                )
              else
                _buildRemotePlaceholder(videoCallState, participantName),

              // Local video (small draggable overlay)
              if (localVideoPosition.value != null)
                Positioned(
                  left: localVideoPosition.value!.dx,
                  top: localVideoPosition.value!.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final newPosition =
                          localVideoPosition.value! + details.delta;
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final size = renderBox.size;

                      // Constrain position to screen bounds
                      double newX = newPosition.dx.clamp(0.0, size.width - 120);
                      double newY = newPosition.dy.clamp(
                        0.0,
                        size.height - 160,
                      );

                      localVideoPosition.value = Offset(newX, newY);
                    },
                    child: _buildLocalVideoPreview(
                      videoCallState,
                      localRenderer,
                      isInitialized.value,
                    ),
                  ),
                ),

              // Top bar with room info (animated)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: controlsAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -80 * (1 - controlsAnimation.value)),
                      child: Opacity(
                        opacity: controlsAnimation.value,
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
                        colors: [
                          Colors.black.withAlpha(178),
                          Colors.transparent,
                        ],
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
                  animation: controlsAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 100 * (1 - controlsAnimation.value)),
                      child: Opacity(
                        opacity: controlsAnimation.value,
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
                        colors: [
                          Colors.black.withAlpha(178),
                          Colors.transparent,
                        ],
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
                              ? Icons.videocam
                              : Icons.videocam_off,
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
                          onPressed: videoCallState.isVideoEnabled
                              ? () {
                                  ref
                                      .read(videoCallProvider.notifier)
                                      .switchCamera();
                                }
                              : () {}, // Disabled when camera is off
                          isEnabled: videoCallState.isVideoEnabled,
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
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = true,
    bool isEnabled = true, // New parameter to disable button
    Color? backgroundColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                (isEnabled
                    ? (isActive ? Colors.white.withAlpha(51) : Colors.white24)
                    : Colors.white.withAlpha(
                        25,
                      )), // More transparent when disabled
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            color: isEnabled
                ? Colors.white
                : Colors.white38, // Dimmed when disabled
            iconSize: 28,
            onPressed: isEnabled
                ? onPressed
                : null, // Disable when isEnabled is false
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isEnabled
                ? Colors.white
                : Colors.white38, // Dimmed when disabled
            fontSize: 12,
          ),
        ),
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
    VideoCallState videoCallState,
    RTCVideoRenderer localRenderer,
    bool isInitialized, {
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
                isInitialized)
              RTCVideoView(
                localRenderer,
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
