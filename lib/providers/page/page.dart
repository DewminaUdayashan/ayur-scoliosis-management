import 'package:ayur_scoliosis_management/models/page/page.dart';
import 'package:ayur_scoliosis_management/pages/practitioner/dashboard/practitioner_dashboard.dart';
import 'package:ayur_scoliosis_management/pages/practitioner/patients/practitioner_patients.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page.g.dart';

@riverpod
List<Page> page(Ref ref) {
  return [
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
      page: Center(child: Text('Schedule Screen')),
    ),
  ];
}
