import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';
import 'package:ayur_scoliosis_management/providers/patient/patients.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/extensions/size.dart';
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/extensions/validators.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../widgets/app_text_form_field.dart';

class InvitePatientSheet extends HookConsumerWidget {
  const InvitePatientSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A key to manage the form's state and validation
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final dateOfBirth = useState<DateTime?>(null);
    final dobController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final selectedGender = useState<Gender?>(null);
    final genderController = useTextEditingController();

    final isLoading = useState(false);

    final errors = useState<String?>(null);

    // Function to show date picker
    Future<void> selectDateOfBirth() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateOfBirth.value ?? DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(
                context,
              ).colorScheme.copyWith(primary: AppTheme.accent),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        dateOfBirth.value = pickedDate;
        dobController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/'
            '${pickedDate.month.toString().padLeft(2, '0')}/'
            '${pickedDate.year}';
      }
    }

    // Function to show gender selection
    Future<void> selectGender() async {
      final Gender? pickedGender = await showDialog<Gender>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Gender'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: Gender.values.map((Gender gender) {
                return ListTile(
                  title: Text(gender.value),
                  onTap: () => Navigator.pop(context, gender),
                );
              }).toList(),
            ),
          );
        },
      );

      if (pickedGender != null) {
        selectedGender.value = pickedGender;
        genderController.text = pickedGender.value;
      }
    }

    // This function handles the form submission
    void submitForm() async {
      errors.value = null;
      // Validate the form. If it's valid, proceed.
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        await ref
            .read(patientsProvider.notifier)
            .invitePatient(
              InvitePatientPayload(
                email: emailController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                dateOfBirth: dateOfBirth.value!,
                gender: selectedGender.value!,
              ),
              onSuccess: () => context.pop(),
              onError: (value) => errors.value = value,
            );
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Invite New Patient',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The patient will receive an email with instructions to create their account.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // --- FORM FIELDS ---
            AppTextFormField(
              controller: firstNameController,
              labelText: 'First Name',
              prefixIcon: CupertinoIcons.person_fill,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a first name'
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: lastNameController,
              labelText: 'Last Name',
              prefixIcon: CupertinoIcons.person_alt,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a last name'
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: dobController,
              labelText: 'Date of Birth',
              prefixIcon: CupertinoIcons.calendar,
              onTap: selectDateOfBirth,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select date of birth'
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: genderController,
              labelText: 'Gender',
              prefixIcon: CupertinoIcons.person_2,
              onTap: selectGender,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select gender'
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: emailController,
              labelText: 'Email Address',
              prefixIcon: CupertinoIcons.mail_solid,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email address';
                }
                if (value.isValidEmail != true) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            if (errors.value != null) ...[
              const SizedBox(height: 16),
              Text(
                errors.value ?? '',
                style: context.textTheme.bodySmall?.copyWith(color: Colors.red),
              ),
            ],
            const SizedBox(height: 32),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: submitForm,
                label: isLoading.value ? 'Sending...' : 'Send Invite',
                isLoading: isLoading.value,
              ),
            ),
            SizedBox(height: context.bottomPadding + 16),
          ],
        ),
      ),
    );
  }
}
