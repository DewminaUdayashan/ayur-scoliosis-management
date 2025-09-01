import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/xray/xray.dart';
import 'package:ayur_scoliosis_management/services/xray/xray_service.dart';
import 'package:dio/dio.dart';

import '../../models/common/paginated/paginated.dart';

class XRayServiceImpl extends XRayService {
  XRayServiceImpl({required this.api, required this.client});
  final Api api;
  final Dio client;

  @override
  Future<Paginated<Xray>> getXrays() async {
    try {
      final response = await client.get(api.xrayPath);
      if (response.statusCode == 200) {
        return Paginated<Xray>.fromJson(
          response.data,
          (data) => Xray.fromJson(data as Map<String, dynamic>),
        );
      }
      throw Exception('Failed to load X-rays');
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<bool> uploadXRay(XRayModel xray) async {
    try {
      final response = await client.post(
        api.uploadXRay,
        data: FormData.fromMap({
          'xrayImage': await MultipartFile.fromFile(xray.image.path),
          'notes': xray.notes,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
