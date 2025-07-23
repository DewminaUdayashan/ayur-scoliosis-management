import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatientProfileTab extends HookConsumerWidget {
  const PatientProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The main content is wrapped in a SingleChildScrollView
    // to ensure it can scroll on smaller devices if the content overflows.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // First Card: Personal Information
          _InfoCard(
            title: 'Personal Information',
            children: [
              _InfoRow(label: 'Date of Birth', value: '1995-05-20'),
              _InfoRow(label: 'Gender', value: 'Female'),
              _InfoRow(
                label: 'Diagnosis',
                value: 'Adolescent Idiopathic Scoliosis',
              ),
              _InfoRow(
                label: 'Severity',
                // A custom widget is used for the value to create the chip
                valueWidget: Chip(
                  label: Text(
                    'Moderate',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.amber.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24), // Space between the two cards
          // Second Card: Contact Information
          _InfoCard(
            title: 'Contact Information',
            children: [
              _InfoRow(
                label: 'Phone',
                valueWidget: Text(
                  '(555) 123-4567',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _InfoRow(
                label: 'Email',
                valueWidget: Text(
                  'sophia.carter@email.com',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _InfoRow(label: 'Address', value: '123 Main St, Anytown, USA'),
            ],
          ),
        ],
      ),
    );
  }
}

/// A reusable card widget for displaying sections of information.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(8),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          // Rows of information
          Column(children: children),
        ],
      ),
    );
  }
}

/// A reusable row widget for displaying a key-value pair.
/// It can accept either a String or a custom Widget for the value.
class _InfoRow extends StatelessWidget {
  const _InfoRow({this.label = '', this.value, this.valueWidget})
    : assert(
        value != null || valueWidget != null,
        'Either value or valueWidget must be provided.',
      );

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label on the left
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          // Value on the right. Expanded ensures it wraps if too long.
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child:
                  valueWidget ??
                  Text(
                    value!,
                    textAlign: TextAlign.right,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
