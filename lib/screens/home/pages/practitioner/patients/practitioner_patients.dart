import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/app_router.dart';
import '../../../../../core/constants/size.dart';
import '../../../../../core/extensions/size.dart';
import '../../../../../core/extensions/theme.dart';
import '../../../../../core/extensions/widgets.dart';
import '../../../../../core/theme.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/patient_profile_avatar.dart';
import 'widgets/invite_patient_sheet.dart';

class PractitionerPatients extends HookConsumerWidget {
  const PractitionerPatients({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: context.width,
      height: context.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: false,
                  title: Text(
                    'Patients',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  floating: true,
                  snap: true,
                  pinned: true,
                ),
                Padding(
                  padding: horizontalPadding,
                  child: AppTextField(hintText: 'Search patients...'),
                ).sliverToBoxAdapter,
                SliverList.builder(
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: PatientProfileAvatar(),
                      title: Text('Patient 1'),
                      subtitle: Text('Condition: Scoliosis'),
                      trailing: Text('Last Visit: 2023-10-01'),
                      onTap: () => context.push(
                        AppRouter.patientDetails,
                        extra: {'id': index + 1},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Important for keyboard handling
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: const InvitePatientSheet(),
                    );
                  },
                );
              },
              backgroundColor: AppTheme.accent,
              child: Icon(CupertinoIcons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
