import 'package:ayur_scoliosis_management/models/auth/practitioner_register_model.dart';

abstract class AuthService {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<void> signUpWithEmailAndPassword(PractitionerRegisterModel data);

  Future<void> signOut();

  Future<bool> isAuthenticated();
}
