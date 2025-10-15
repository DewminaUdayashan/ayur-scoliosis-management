import 'package:ayur_scoliosis_management/models/xray/xray.dart';
import 'package:ayur_scoliosis_management/providers/xray/measurement.dart';
import 'package:ayur_scoliosis_management/screens/measurement/measurement_tool.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/utils/api.dart';
import '../../models/xray/measurement.dart';

class XrayMeasureScreen extends ConsumerWidget {
  const XrayMeasureScreen({
    super.key,
    required this.xray,
    this.initialMeasurements,
    this.readOnly = false,
    this.onSaved,
  });

  final Xray xray;
  final List<Measurement>? initialMeasurements;
  final bool readOnly;
  final void Function(List<Measurement>)? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurement = ref.watch(measurementByIdProvider(xray.id)).valueOrNull;
    return CobbAngleToolScreen(
      imageUrl: Api.baseUrl + xray.imageUrl,
      initialMeasurements: measurement ?? [],
      readOnly: readOnly,
      onSaved: (measurements) {
        ref
            .read(measurementByIdProvider(xray.id).notifier)
            .saveMeasurements(xray.id, measurements);
      },
    );
  }
}
