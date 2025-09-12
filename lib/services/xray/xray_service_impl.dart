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
  Future<Paginated<Xray>> getXrays({String? patientId}) async {
    try {
      final response = await client.get(
        api.xrayPath,
        queryParameters: patientId != null ? {'patientId': patientId} : null,
      );
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

  @override
  Future<bool> validateXray(XRayModel xray) async {
    try {
      final dio = Dio();
      dio.options.baseUrl = api.classifyImageType;
      dio.options.headers = {'Content-Type': 'multipart/form-data'};
      final response = await dio.post(
        api.classifyImageType,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(xray.image.path),
        }),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> &&
            data['predicted_class'] == 'spinal_xray') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
