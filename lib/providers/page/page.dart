import 'package:ayur_scoliosis_management/screens/home/pages/patient/dashboard/patient_dashboard.dart';
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
      page: Container(),
    ),
    // Add other patient pages here
  ];
  return patientPages;
}
