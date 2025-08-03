import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/size.dart';
import '../../../core/extensions/theme.dart';
import '../../../core/extensions/validators.dart';
import '../../../core/extensions/value_notifier.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/buttons/primary_button.dart';

class PractitionerRegistrationScreen extends HookConsumerWidget {
  const PractitionerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for managing state
    final pageController = usePageController();
    final currentStep = useState(0);
    final personalInfoFormKey = useMemoized(() => GlobalKey<FormState>());
    final clinicInfoFormKey = useMemoized(() => GlobalKey<FormState>());
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final passwordController = useTextEditingController();

    void goToNextStep() {
      if (personalInfoFormKey.currentState?.validate() == true) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    void submitRegistration() {
      if (clinicInfoFormKey.currentState?.validate() == true) {
        // TODO: Implement registration API call

        // Show success message and pop back to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration request sent! Your account will be reviewed.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Practitioner Registration'),
        centerTitle: true,
      ),
      body: Padding(
        padding: horizontalPadding,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Step ${currentStep.value + 1} of 2: ${currentStep.value == 0 ? "Personal Details" : "Clinic Information"}',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => currentStep.value = index,
                children: [
                  // --- Step 1: Personal Details ---
                  _PersonalDetailsForm(
                    formKey: personalInfoFormKey,
                    passwordController: passwordController,
                    obscurePassword: obscurePassword,
                    obscureConfirmPassword: obscureConfirmPassword,
                    onNext: goToNextStep,
                  ),
                  // --- Step 2: Clinic Information ---
                  _ClinicInfoForm(
                    formKey: clinicInfoFormKey,
                    onSubmit: submitRegistration,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widget for Step 1 ---
class _PersonalDetailsForm extends StatelessWidget {
  const _PersonalDetailsForm({
    required this.formKey,
    required this.passwordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscurePassword;
  final ValueNotifier<bool> obscureConfirmPassword;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AppTextField(
            labelText: 'First Name',
            hintText: 'Enter your first name',
            validator: (v) => v!.isEmpty ? 'First name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            validator: (v) => v!.isEmpty ? 'Last name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v!.isValidEmail ? null : 'Enter a valid email',
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Phone number is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Specialty',
            hintText: 'e.g., Ayurvedic Medicine',
            validator: (v) => v!.isEmpty ? 'Specialty is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Medical License',
            hintText: 'Enter your medical license number',
            validator: (v) => v!.isEmpty ? 'Medical license is required' : null,
          ),
          const SizedBox(height: 16),
          obscurePassword.build(
            (obscure) => AppTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              controller: passwordController,
              obscureText: obscure,
              suffix: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => obscurePassword.value = !obscure,
              ),
              // validator: (v) => v!.passwordLengthValidator,
            ),
          ),
          const SizedBox(height: 16),
          obscureConfirmPassword.build(
            (obscure) => AppTextField(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              obscureText: obscure,
              suffix: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => obscureConfirmPassword.value = !obscure,
              ),
              // validator: (v) =>
              //     v!.confirmPasswordValidator(passwordController.text),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(label: 'Next', onPressed: onNext, isLoading: false),
        ],
      ),
    );
  }
}

// --- Helper Widget for Step 2 ---
class _ClinicInfoForm extends StatelessWidget {
  const _ClinicInfoForm({required this.formKey, required this.onSubmit});
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AppTextField(
            labelText: 'Clinic Registration ID',
            hintText: 'Enter the ID provided to your clinic',
            validator: (v) => v!.isEmpty ? 'Clinic ID is required' : null,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Submit Registration',
            onPressed: onSubmit,
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
