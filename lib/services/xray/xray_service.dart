import 'package:ayur_scoliosis_management/models/xray/xray.dart';

abstract class XRayService {
  Future<bool> uploadXRay(XRayModel xray);
}
