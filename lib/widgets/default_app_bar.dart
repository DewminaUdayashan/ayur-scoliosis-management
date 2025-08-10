import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({super.key, this.isPatient = false});
  final bool isPatient;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const CircleAvatar(
          radius: 20,
          child: Icon(Icons.person, color: Colors.black),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('SpineAlign', style: context.textTheme.bodySmall),
            Text(
              'Welcome ${isPatient ? '' : 'Doctor'}!',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
