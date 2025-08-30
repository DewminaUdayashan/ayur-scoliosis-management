import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../services/xray/xray_service.dart';
import '../../services/xray/xray_service_impl.dart';
import '../dio/dio.dart';

part 'xray_service.g.dart';

@riverpod
XRayService xrayService(Ref ref) {
  return XRayServiceImpl(api: Api(), client: ref.watch(dioProvider));
}
