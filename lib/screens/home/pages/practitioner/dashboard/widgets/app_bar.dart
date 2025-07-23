import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/material.dart';

class PractitionerAppBar extends StatelessWidget {
  const PractitionerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      title: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('SpineCare Clinic', style: context.textTheme.bodySmall),
              Text(
                'Dr. John Doe',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Badge.count(
              count: 2,
              child: Icon(Icons.notifications, color: AppTheme.textSecondary),
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
