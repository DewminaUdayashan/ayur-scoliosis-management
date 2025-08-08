import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/extensions/snack.dart';

void showSuccessSnack(String message) {
  final context = navigatorKey.currentContext;
  if (context != null && context.mounted) {
    context.showSuccess(message);
  }
}

void showErrorSnack(String message) {
  final context = navigatorKey.currentContext;
  if (context != null && context.mounted) {
    context.showError(message);
  }
}
