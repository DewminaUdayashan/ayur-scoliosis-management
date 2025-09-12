import 'dart:io';

import 'package:ayur_scoliosis_management/core/utils/snacks.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/providers/xray/xray_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/xray/xray.dart' as xray;
import '../../models/xray/xray.dart';

part 'xray.g.dart';

@riverpod
class XRay extends _$XRay {
  @override
  Future<List<Paginated<xray.Xray>>> build({String? patientId}) async {
    final service = ref.watch(xrayServiceProvider);
    return [await service.getXrays(patientId: patientId)];
  }

  Future<void> uploadXray(File file) async {
    try {
      final service = ref.watch(xrayServiceProvider);
      final isValid = await service.validateXray(XRayModel(image: file));
      if (!isValid) {
        showErrorSnack("The uploaded file is not a valid X-Ray image.");
        return;
      }
      final uploaded = await service.uploadXRay(XRayModel(image: file));
      if (uploaded) {
        showSuccessSnack("X-Ray uploaded successfully");
      } else {
        showErrorSnack("Failed to upload X-Ray");
      }
      ref.invalidateSelf();
    } catch (e) {
      showErrorSnack("Failed to upload X-Ray");
    }
  }
}
