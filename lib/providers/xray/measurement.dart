import 'package:ayur_scoliosis_management/core/utils/snacks.dart';
import 'package:ayur_scoliosis_management/models/xray/measurement.dart';
import 'package:ayur_scoliosis_management/providers/xray/xray_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'measurement.g.dart';

@riverpod
class MeasurementById extends _$MeasurementById {
  @override
  Future<List<Measurement>> build(String xrayId) {
    final service = ref.watch(xrayServiceProvider);
    return service.getMeasurement(xrayId);
  }

  Future<void> saveMeasurements(
    String xrayId,
    List<Measurement> measurements,
  ) async {
    try {
      final service = ref.watch(xrayServiceProvider);
      final saved = await service.measureXray(xrayId, measurements);
      ref.invalidateSelf();
      if (saved) {
        showSuccessSnack("Measurements saved successfully");
      } else {
        showErrorSnack("Failed to save measurements");
      }
    } catch (e) {
      showErrorSnack("Failed to save measurements");
    }
  }
}
