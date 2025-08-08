import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/extensions/snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/size.dart';
import '../../../core/extensions/theme.dart';
import '../../../core/extensions/validators.dart';
import '../../../core/extensions/value_notifier.dart';
import '../../../providers/auth/auth.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../models/auth/practitioner_register_model.dart';

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
    final emailController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final specialtyController = useTextEditingController();
    final medicalLicenseController = useTextEditingController();
    final clinicNameController = useTextEditingController();
    final clinicAddressLine1Controller = useTextEditingController();
    final clinicAddressLine2Controller = useTextEditingController();
    final clinicCityController = useTextEditingController();
    final clinicEmailController = useTextEditingController();
    final clinicPhoneController = useTextEditingController();
    final isLoading = useState(false);

    // Watch auth state for loading and error handling
    // final authState = ref.watch(authProvider);

    void goToNextStep() {
      if (personalInfoFormKey.currentState?.validate() == true) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    Future<void> submitRegistration() async {
      if (clinicInfoFormKey.currentState?.validate() == true) {
        try {
          isLoading.value = true;

          // Create the registration model with all the data
          final registrationModel = PractitionerRegisterModel(
            email: emailController.text.trim(),
            password: passwordController.text,
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            phone: phoneController.text.trim(),
            specialty: specialtyController.text.trim(),
            medicalLicense: medicalLicenseController.text.trim(),
            clinicName: clinicNameController.text.trim(),
            clinicAddressLine1: clinicAddressLine1Controller.text.trim(),
            clinicAddressLine2: clinicAddressLine2Controller.text.trim().isEmpty
                ? null
                : clinicAddressLine2Controller.text.trim(),
            clinicCity: clinicCityController.text.trim(),
            clinicEmail: clinicEmailController.text.trim(),
            clinicPhone: clinicPhoneController.text.trim(),
            // TODO: Add file uploads if needed
            // profileImage: null,
            // clinicImage: null,
          );

          // Call the auth provider's signUp method with the model
          await ref.read(authProvider.notifier).signUp(registrationModel);

          if (context.mounted) {
            // Show success message
            context.showSuccess(
              'Registration successful! Your account is pending activation.',
            );
            context.pop();
          }
        } catch (error) {
          if (context.mounted) {
            // Show error message
            context.showError('Registration failed: ${error.toString()}');
          }
        } finally {
          isLoading.value = false;
        }
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
                    emailController: emailController,
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    phoneController: phoneController,
                    specialtyController: specialtyController,
                    medicalLicenseController: medicalLicenseController,
                    passwordController: passwordController,
                    obscurePassword: obscurePassword,
                    obscureConfirmPassword: obscureConfirmPassword,
                    onNext: goToNextStep,
                  ),
                  // --- Step 2: Clinic Information ---
                  _ClinicInfoForm(
                    formKey: clinicInfoFormKey,
                    clinicNameController: clinicNameController,
                    clinicAddressLine1Controller: clinicAddressLine1Controller,
                    clinicAddressLine2Controller: clinicAddressLine2Controller,
                    clinicCityController: clinicCityController,
                    clinicEmailController: clinicEmailController,
                    clinicPhoneController: clinicPhoneController,
                    onSubmit: submitRegistration,
                    isLoading: isLoading.value,
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
class _PersonalDetailsForm extends HookConsumerWidget {
  const _PersonalDetailsForm({
    required this.formKey,
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.specialtyController,
    required this.medicalLicenseController,
    required this.passwordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController specialtyController;
  final TextEditingController medicalLicenseController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscurePassword;
  final ValueNotifier<bool> obscureConfirmPassword;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).valueOrNull;

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AppTextField(
            labelText: 'First Name',
            hintText: 'Enter your first name',
            controller: firstNameController,
            validator: (v) => v!.isEmpty ? 'First name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            controller: lastNameController,
            validator: (v) => v!.isEmpty ? 'Last name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v!.isValidEmail ? null : 'Enter a valid email',
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Phone number is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Specialty',
            hintText: 'e.g., Ayurvedic Medicine',
            controller: specialtyController,
            validator: (v) => v!.isEmpty ? 'Specialty is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Medical License',
            hintText: 'Enter your medical license number',
            controller: medicalLicenseController,
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
          PrimaryButton(
            label: 'Next',
            onPressed: onNext,
            isLoading: authState == AuthStatus.loading,
          ),
        ],
      ),
    );
  }
}

// --- Helper Widget for Step 2 ---
class _ClinicInfoForm extends HookConsumerWidget {
  const _ClinicInfoForm({
    required this.formKey,
    required this.clinicNameController,
    required this.clinicAddressLine1Controller,
    required this.clinicAddressLine2Controller,
    required this.clinicCityController,
    required this.clinicEmailController,
    required this.clinicPhoneController,
    required this.onSubmit,
    required this.isLoading,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController clinicNameController;
  final TextEditingController clinicAddressLine1Controller;
  final TextEditingController clinicAddressLine2Controller;
  final TextEditingController clinicCityController;
  final TextEditingController clinicEmailController;
  final TextEditingController clinicPhoneController;
  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authState = ref.watch(authProvider).valueOrNull;

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AppTextField(
            labelText: 'Clinic Name',
            hintText: 'Enter your clinic name',
            controller: clinicNameController,
            validator: (v) => v!.isEmpty ? 'Clinic name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Clinic Address Line 1',
            hintText: 'Enter the first line of clinic address',
            controller: clinicAddressLine1Controller,
            validator: (v) =>
                v!.isEmpty ? 'Clinic address line 1 is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Clinic Address Line 2 (Optional)',
            hintText: 'Enter the second line of clinic address',
            controller: clinicAddressLine2Controller,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Clinic City',
            hintText: 'Enter the clinic city',
            controller: clinicCityController,
            validator: (v) => v!.isEmpty ? 'Clinic city is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Clinic Email',
            hintText: 'Enter the clinic email',
            controller: clinicEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v!.isValidEmail ? null : 'Enter a valid clinic email',
          ),
          const SizedBox(height: 16),
          AppTextField(
            labelText: 'Clinic Phone',
            hintText: 'Enter the clinic phone number',
            controller: clinicPhoneController,
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Clinic phone is required' : null,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Submit Registration',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
