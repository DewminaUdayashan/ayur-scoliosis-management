import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/xray/xray.dart'
    show Xray, XRayModel;

import '../../models/xray/measurement.dart';

abstract class XRayService {
  Future<Paginated<Xray>> getXrays({String? patientId});
  Future<bool> validateXray(XRayModel xray);
  Future<bool> uploadXRay(XRayModel xray);
  Future<List<Measurement>> getMeasurement(String xrayId);
  Future<bool> measureXray(String xrayId, List<Measurement> measurements);
}
