import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_details.dart';
import 'package:ayur_scoliosis_management/providers/session/active_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A floating indicator for active sessions that allows note-taking
/// Positioned to not conflict with VideoCallFloatingIndicator
class SessionNotesFloatingIndicator extends HookConsumerWidget {
  const SessionNotesFloatingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);

    // State for draggable position
    final position = useState<Offset?>(null);

    // Initialize default position on first build
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (position.value == null && context.mounted) {
          final screenSize = MediaQuery.of(context).size;
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          // Default position: bottom-left (opposite of video call indicator)
          position.value = Offset(
            16, // 16px from left edge
            screenSize.height -
                bottomPadding -
                70 -
                56, // 70px from bottom, 56px button height
          );
        }
      });
      return null;
    }, []);

    if (activeSession == null || position.value == null) {
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
              _showNotesDialog(
                navigatorKey.currentContext!,
                ref,
                activeSession,
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: activeSession.appointmentType == 'Physical'
                      ? [const Color(0xFF1565C0), const Color(0xFF2196F3)]
                      : [const Color(0xFFE65100), const Color(0xFFFF9800)],
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
                  _PulsingNotesIcon(hasNotes: activeSession.notes.isNotEmpty),
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.doc_text_fill,
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

  void _showNotesDialog(
    BuildContext context,
    WidgetRef ref,
    ActiveSession session,
  ) {
    final notesController = TextEditingController(text: session.notes);
    final sessionDuration = DateTime.now().difference(session.startTime);
    final hours = sessionDuration.inHours;
    final minutes = sessionDuration.inMinutes.remainder(60);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              session.appointmentType == 'Physical'
                  ? CupertinoIcons.briefcase_fill
                  : CupertinoIcons.videocam_fill,
              color: session.appointmentType == 'Physical'
                  ? const Color(0xFF2196F3)
                  : const Color(0xFFFF9800),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('${session.appointmentType} Session Notes')),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duration: ${hours}h ${minutes}m',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Enter session notes here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (value) {
                    ref.read(activeSessionProvider.notifier).updateNotes(value);
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showEndSessionDialog(context, ref, session);
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('End Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showEndSessionDialog(
    BuildContext context,
    WidgetRef ref,
    ActiveSession session,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('End Session'),
        content: const Text(
          'Would you like to save the session notes and complete this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(activeSessionProvider.notifier).endSession();
              Navigator.of(ctx).pop();
            },
            child: const Text('End Without Saving'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _completeSessionWithNotes(context, ref, session);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Save & Complete'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeSessionWithNotes(
    BuildContext context,
    WidgetRef ref,
    ActiveSession session,
  ) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      // Call the complete appointment endpoint with notes
      await ref
          .read(appointmentDetailsProvider(session.appointmentId).notifier)
          .completeWithNotes(session.notes);

      // End the session
      ref.read(activeSessionProvider.notifier).endSession();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session completed and notes saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _PulsingNotesIcon extends StatefulWidget {
  final bool hasNotes;

  const _PulsingNotesIcon({required this.hasNotes});

  @override
  State<_PulsingNotesIcon> createState() => _PulsingNotesIconState();
}

class _PulsingNotesIconState extends State<_PulsingNotesIcon>
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
            child: widget.hasNotes
                ? const Icon(
                    CupertinoIcons.pencil_circle_fill,
                    color: Colors.white,
                    size: 24,
                  )
                : const Icon(
                    CupertinoIcons.pencil_circle,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        );
      },
    );
  }
}
