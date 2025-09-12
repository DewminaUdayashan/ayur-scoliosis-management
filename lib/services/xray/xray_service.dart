import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/xray/xray.dart'
    show Xray, XRayModel;

abstract class XRayService {
  Future<Paginated<Xray>> getXrays({String? patientId});
  Future<bool> validateXray(XRayModel xray);
  Future<bool> uploadXRay(XRayModel xray);
}
