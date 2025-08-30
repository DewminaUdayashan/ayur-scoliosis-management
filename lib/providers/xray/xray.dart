import 'dart:io';

import 'package:ayur_scoliosis_management/core/utils/snacks.dart';
import 'package:ayur_scoliosis_management/providers/xray/xray_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/xray/xray.dart';

part 'xray.g.dart';

@riverpod
class XRay extends _$XRay {
  @override
  void build() {
    return;
  }

  Future<void> uploadXray(File file) async {
    try {
      final service = ref.watch(xrayServiceProvider);
      final uploaded = await service.uploadXRay(XRayModel(image: file));
      if (uploaded) {
        showSuccessSnack("X-Ray uploaded successfully");
      } else {
        showErrorSnack("Failed to upload X-Ray");
      }
    } catch (e) {
      showErrorSnack("Failed to upload X-Ray");
    }
  }
}
