import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../gen/assets.gen.dart';

// Assuming you have this extension from the previous example
extension ThemeContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// Data model to represent a single event on the timeline.
class _TimelineEvent {
  final IconData icon;
  final String title;
  final String date;
  final Widget content;
  final _TagInfo tag;

  _TimelineEvent({
    required this.icon,
    required this.title,
    required this.date,
    required this.content,
    required this.tag,
  });
}

/// Data model for the informational tag at the bottom of a timeline item.
class _TagInfo {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  _TagInfo({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });
}

/// The main widget that builds the sliver list for the timeline.
class PatientTimelineTab extends StatelessWidget {
  const PatientTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    // A sample list of events to populate the timeline, matching the screenshot.
    final List<_TimelineEvent> timelineEvents = [
      _TimelineEvent(
        icon: Icons.calendar_today_outlined,
        title: 'Initial Consultation',
        date: 'Feb 15, 2024',
        content: Text(
          'First meeting to discuss treatment plan.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        tag: _TagInfo(
          text: 'Shared with Patient',
          backgroundColor: Colors.indigo.shade50,
          textColor: Colors.indigo.shade700,
        ),
      ),
      _TimelineEvent(
        icon: Icons.book_outlined,
        title: 'Session Notes',
        date: 'Mar 1, 2024',
        content: Text(
          'Patient reported improvement in posture.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        tag: _TagInfo(
          text: 'Shared with Patient',
          backgroundColor: Colors.indigo.shade50,
          textColor: Colors.indigo.shade700,
        ),
      ),
      _TimelineEvent(
        icon: Icons.layers_outlined,
        title: 'X-Ray Uploaded',
        date: 'Mar 10, 2024',
        content: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(Assets.images.xRay, fit: BoxFit.cover),
        ),
        tag: _TagInfo(
          text: 'Shared with Patient',
          backgroundColor: Colors.indigo.shade50,
          textColor: Colors.indigo.shade700,
        ),
      ),
      _TimelineEvent(
        icon: Icons.edit_outlined,
        title: 'Scoliosis Measurement',
        date: 'Mar 11, 2024',
        content: Text(
          'Cobb Angle: 25 degrees.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        tag: _TagInfo(
          text: 'Shared with Patient',
          backgroundColor: Colors.indigo.shade50,
          textColor: Colors.indigo.shade700,
        ),
      ),
      _TimelineEvent(
        icon: Icons.calendar_today_outlined,
        title: 'Follow-up Appointment',
        date: 'Mar 20, 2024 (Upcoming)',
        content: const SizedBox.shrink(), // No content for this item
        tag: _TagInfo(
          text: 'Scheduled for 10:00 AM.',
          backgroundColor: Colors.cyan.shade50,
          textColor: Colors.cyan.shade800,
        ),
      ),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return _TimelineItem(
          event: timelineEvents[index],
          isLast: index == timelineEvents.length - 1,
        );
      }, childCount: timelineEvents.length),
    );
  }
}

/// A widget that represents a single item in the timeline.
class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});

  final _TimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // IntrinsicHeight ensures the vertical line can connect the items properly.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gutter: The icon and the vertical line
            _buildGutter(context),
            const SizedBox(width: 16),
            // Content: The main card with information
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildGutter(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(child: Icon(event.icon, color: AppTheme.accent, size: 20)),
        // The vertical line connecting the items
        if (!isLast)
          Expanded(
            child: Container(width: 1.5, color: Colors.blueGrey.shade100),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 24.0,
      ), // Space between items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            event.date,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          event.content,
          const SizedBox(height: 12),
          // The tag at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: event.tag.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event.tag.text,
              style: context.textTheme.bodySmall?.copyWith(
                color: event.tag.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
