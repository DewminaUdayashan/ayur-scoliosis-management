import 'package:ayur_scoliosis_management/providers/profile/profile.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/patient/dashboard/patient_dashboard.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/patient/schedule/patient_schedule.dart';
import 'package:ayur_scoliosis_management/screens/patient_details/patient_details_screen.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/page/page.dart';
import '../../screens/home/pages/practitioner/dashboard/practitioner_dashboard.dart';
import '../../screens/home/pages/practitioner/patients/practitioner_patients.dart';
import '../../screens/home/pages/practitioner/schedule/practitioner_schedule.dart';

part 'page.g.dart';

@riverpod
List<Page> page(Ref ref) {
  final user = ref.watch(profileProvider).valueOrNull;
  final practitionerPages = [
    Page(
      id: 1,
      label: 'Dashboard',
      icon: Icons.home,
      page: PractitionerDashboard(),
    ),
    Page(
      id: 2,
      label: 'Patients',
      icon: Icons.people_alt_sharp,
      page: PractitionerPatients(),
    ),
    Page(
      id: 3,
      label: 'Schedule',
      icon: Icons.calendar_month,
      page: PractitionerSchedule(),
    ),
  ];
  final patientPages = [
    Page(id: 1, label: 'Dashboard', icon: Icons.home, page: PatientDashboard()),
    Page(
      id: 2,
      label: 'Schedule ',
      icon: Icons.calendar_month,
      page: PatientSchedule(),
    ),
    if (user?.id != null)
      Page(
        id: 3,
        label: 'Profile',
        icon: Icons.person,
        page: PatientDetailsScreen(patientId: user!.id),
      ),
  ];

  return user?.isPractitioner == true ? practitionerPages : patientPages;
}
