import 'package:ayur_scoliosis_management/core/extensions/size.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/extensions/validators.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/widgets/app_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InvitePatientSheet extends HookWidget {
  const InvitePatientSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // A key to manage the form's state and validation
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // This function handles the form submission
    void submitForm() {
      // Validate the form. If it's valid, proceed.
      if (formKey.currentState?.validate() ?? false) {
        // TODO: Implement API call to send the invitation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invitation sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Close the bottom sheet
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
              labelText: 'First Name',
              prefixIcon: CupertinoIcons.person_fill,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a first name'
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              labelText: 'Last Name',
              prefixIcon: CupertinoIcons.person_alt,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a last name'
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextFormField(
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
            const SizedBox(height: 32),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Send Invite'),
              ),
            ),
            SizedBox(height: context.bottomPadding + 16),
          ],
        ),
      ),
    );
  }

  // Helper method for consistent input field styling
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
