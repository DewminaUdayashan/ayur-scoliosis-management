import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/models/patient/patient_event.dart';
import 'package:ayur_scoliosis_management/providers/event/events.dart';
import 'package:ayur_scoliosis_management/widgets/sliver_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/api.dart';

class PatientTimelineTab extends HookConsumerWidget {
  const PatientTimelineTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider(null));

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No events available',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        return SliverList.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _TimelineItem(
              event: event,
              isLast: index == events.length - 1,
            );
          },
        );
      },
      loading: () {
        return const SliverSizedBox();
      },
      error: (error, stack) {
        return SliverSizedBox();
      },
    );
  }
}

/// A widget that represents a single item in the timeline.
class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});

  final PatientEvent event;
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
            buildGutter(context),
            const SizedBox(width: 16),
            // Content: The main card with information
            Expanded(child: buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget buildGutter(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: Icon(Icons.calendar_month, color: AppTheme.accent, size: 20),
        ),
        // The vertical line connecting the items
        if (!isLast)
          Expanded(
            child: Container(width: 1.5, color: Colors.blueGrey.shade100),
          ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 24.0,
      ), // Space between items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.eventType.value,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            event.eventDateTime.yMMMMd,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          if (event.eventType == EventType.xRayUpload &&
              event.xrayImages?.isNotEmpty == true) ...[
            Image.network(Api.baseUrl + event.xrayImages!.first.imageUrl),
          ],

          if (event.eventType == EventType.aiClassification &&
              event.aiClassificationResult != null) ...[
            Text(
              'Classification: ${event.aiClassificationResult!.classificationResult.value}',
              style: context.textTheme.bodyMedium,
            ),
            // const SizedBox(height: 4),
            // Text(
            //   'Confidence Score: ${event.aiClassificationResult!.confidenceScore}',
            //   style: context.textTheme.bodyMedium,
            // ),
            if (event.aiClassificationResult!.notes != null) ...[
              const SizedBox(height: 4),
              Text(
                'Notes: ${event.aiClassificationResult!.notes}',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ],

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
