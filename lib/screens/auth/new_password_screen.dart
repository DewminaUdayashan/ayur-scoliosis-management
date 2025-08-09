import 'package:ayur_scoliosis_management/core/extensions/snack.dart';
import 'package:ayur_scoliosis_management/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/app_router.dart';
import '../../core/constants/size.dart';
import '../../core/extensions/size.dart';
import '../../core/extensions/theme.dart';
import '../../core/extensions/value_notifier.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/primary_button.dart';

class NewPasswordScreen extends HookConsumerWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A key to uniquely identify the Form widget and allow validation.
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Controllers to manage the text being entered.
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // State notifiers for UI changes.
    final newPasswordObscure = useState(true);
    final confirmPasswordObscure = useState(true);
    final isLoading = useState(false);

    /// Handles the logic for setting a new password.
    /// It validates the form, calls the auth provider, and handles navigation.
    void setNewPassword() async {
      // Don't proceed if the form is not valid.
      if (formKey.currentState?.validate() != true) {
        return;
      }
      isLoading.value = true;
      try {
        await ref
            .read(authProvider.notifier)
            .setNewPassword(newPasswordController.text);

        if (context.mounted) {
          context.showSuccess(
            'Password has been set successfully. Please log in again.',
          );
          context.pushReplacement(AppRouter.login);
        }
      } on Exception catch (e) {
        // Show an error message if the password update fails.
        if (context.mounted) {
          context.showError('Failed to set password: ${e.toString()}');
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      body: Padding(
        padding: horizontalPadding,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              // App Logo
              Center(
                child: Image.asset(
                  Assets.images.logo,
                  width: context.width * 0.6,
                ),
              ),
              // Screen Title
              Text(
                'Create New Password',
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Instructional Text
              Text(
                'Your new password must be different from previously used passwords.',
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // New Password Field
              newPasswordObscure.build(
                (obscure) => AppTextField(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  controller: newPasswordController,
                  obscureText: obscure,
                  textInputAction: TextInputAction.next,
                  suffix: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      newPasswordObscure.value = !newPasswordObscure.value;
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
              ),
              // Confirm Password Field
              confirmPasswordObscure.build(
                (obscure) => AppTextField(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your new password',
                  controller: confirmPasswordController,
                  obscureText: obscure,
                  textInputAction: TextInputAction.done,
                  // onFieldSubmitted: (_) => setNewPassword(),
                  suffix: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      confirmPasswordObscure.value =
                          !confirmPasswordObscure.value;
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Submit Button
              PrimaryButton(
                isLoading: isLoading.value,
                label: 'Set New Password',
                onPressed: setNewPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
