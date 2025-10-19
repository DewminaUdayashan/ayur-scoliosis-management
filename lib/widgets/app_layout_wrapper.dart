import 'package:ayur_scoliosis_management/widgets/session_notes_floating_indicator.dart';
import 'package:ayur_scoliosis_management/widgets/video_call_floating_indicator.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that adds global UI elements like the video call floating indicator
/// to all screens in the app
class AppLayoutWrapper extends StatelessWidget {
  final Widget child;

  const AppLayoutWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The actual screen content
        child,
        // Global floating indicator for active video calls
        const VideoCallFloatingIndicator(),
        // Global floating indicator for active sessions with notes
        const SessionNotesFloatingIndicator(),
      ],
    );
  }
}
