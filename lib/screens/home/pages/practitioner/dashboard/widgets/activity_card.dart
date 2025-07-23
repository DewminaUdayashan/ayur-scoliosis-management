import 'package:ayur_scoliosis_management/core/constants/size.dart'
    show radius8;
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius8),
      elevation: 0.2,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius8),
        leading: CircleAvatar(
          child: Icon(Icons.document_scanner_outlined, color: AppTheme.primary),
        ),
        title: RichText(
          text: TextSpan(
            text: 'John Doe',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            children: [
              TextSpan(
                text: ' uploaded a new X-ray',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '2 hours ago',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Icon(
          CupertinoIcons.chevron_forward,
          color: AppTheme.textSecondary,
        ),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        onTap: () {
          // Navigate to appointment details
        },
      ),
    );
  }
}
