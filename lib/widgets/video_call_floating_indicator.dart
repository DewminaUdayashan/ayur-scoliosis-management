import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/providers/video_call/is_in_call.dart';
import 'package:ayur_scoliosis_management/providers/video_call/video_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A floating indicator that appears when a video call is active
/// Allows users to return to the call from anywhere in the app
class VideoCallFloatingIndicator extends HookConsumerWidget {
  const VideoCallFloatingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoCallState = ref.watch(videoCallProvider);
    final isInCall = ref.watch(isInCallProvider);

    // State for draggable position
    final position = useState<Offset?>(null);

    // Initialize default position on first build
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (position.value == null && context.mounted) {
          final screenSize = MediaQuery.of(context).size;
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          // Default position: bottom-right
          position.value = Offset(
            screenSize.width -
                16 -
                150, // 16px from right edge, 150px button width
            screenSize.height -
                bottomPadding -
                70 -
                56, // 70px from bottom, 56px button height
          );
        }
      });
      return null;
    }, []);

    if (videoCallState.callState != CallState.connected ||
        videoCallState.room == null ||
        isInCall ||
        position.value == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: position.value!.dx,
      top: position.value!.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          final screenSize = MediaQuery.of(context).size;
          final newPosition = position.value! + details.delta;

          // Constrain to screen bounds (with some padding)
          final buttonWidth = 150.0;
          final buttonHeight = 56.0;

          final constrainedX = newPosition.dx.clamp(
            0.0,
            screenSize.width - buttonWidth,
          );
          final constrainedY = newPosition.dy.clamp(
            MediaQuery.of(context).padding.top,
            screenSize.height -
                buttonHeight -
                MediaQuery.of(context).padding.bottom,
          );

          position.value = Offset(constrainedX, constrainedY);
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              navigatorKey.currentContext?.push(
                AppRouter.videoCall(videoCallState.room!.appointmentId),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated pulsing icon
                  const _PulsingIcon(),
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// _PulsingIcon remains unchanged
class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon();

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.videocam_fill,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
