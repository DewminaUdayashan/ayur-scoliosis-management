import 'package:flutter/material.dart';

import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class PatientAppBar extends StatelessWidget {
  const PatientAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const CircleAvatar(
            // In a real app, this would show the patient's profile image
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'Anusha Perera', // Replace with dynamic patient name
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Badge.count(
              count: 3, // Example notification count
              child: const Icon(
                Icons.notifications,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
      floating: true,
      snap: true,
      pinned: true,
    );
  }
}
