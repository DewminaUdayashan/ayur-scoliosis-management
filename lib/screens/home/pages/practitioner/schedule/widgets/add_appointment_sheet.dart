import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/enums.dart';
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../models/patient/patient.dart';

class AddAppointmentSheet extends HookWidget {
  const AddAppointmentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // --- FORM STATE & CONTROLLERS ---
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final dateController = useTextEditingController();
    final timeController = useTextEditingController();
    final searchController = useMemoized(
      () => SearchController(),
    ); // For SearchAnchor
    final selectedPatient = useState<Patient?>(null);
    final sessionType = useState<SessionType>(SessionType.physical);

    // --- DUMMY DATA ---
    final List<Patient> patients = [
      Patient(
        profileImageUrl: 'https://i.pravatar.cc/150?img=5',
        dateOfBirth: DateTime(1998, 5, 12),
        gender: Gender.female,
      ),
      Patient(
        profileImageUrl: 'https://i.pravatar.cc/150?img=12',
        dateOfBirth: DateTime(2001, 9, 23),
        gender: Gender.male,
      ),
      Patient(
        profileImageUrl: 'https://i.pravatar.cc/150?img=32',
        dateOfBirth: DateTime(1995, 2, 8),
        gender: Gender.female,
      ),
      Patient(
        profileImageUrl: null, // Example with no profile image
        dateOfBirth: DateTime(2003, 11, 30),
        gender: Gender.male,
      ),
    ];

    // --- FORM SUBMISSION LOGIC (Unchanged) ---
    void submitForm() {
      if (formKey.currentState?.validate() ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment Saved!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
            // --- HEADER (Unchanged) ---
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
              'New Appointment',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // --- PATIENT SEARCH ANCHOR ---
            // We wrap the SearchAnchor in a FormField for validation.
            FormField<Patient>(
              initialValue: selectedPatient.value,
              validator: (value) {
                if (value == null) {
                  return 'Please select a patient';
                }
                return null;
              },
              builder: (formFieldState) {
                return SearchAnchor(
                  searchController: searchController,
                  // This builder creates the clickable field that opens the search view.
                  builder: (context, controller) {
                    return TextFormField(
                      controller: controller,
                      readOnly: true,
                      decoration: _inputDecoration(
                        label: 'Patient',
                        icon: CupertinoIcons.person_fill,
                        // Show an error border if validation fails
                        errorText: formFieldState.errorText,
                      ).copyWith(hintText: 'Select Patient'),
                      onTap: () => controller.openView(),
                      // We use the controller's text, which is set when a suggestion is tapped.
                    );
                  },
                  // This builder creates the list of suggestions in the search view.
                  suggestionsBuilder: (context, controller) {
                    final query = controller.text.toLowerCase();
                    // final filteredPatients = patients.where(
                    //   (patient) =>
                    //       patient.firstName.toLowerCase().contains(query),
                    // );

                    return patients.map((patient) {
                      return ListTile(
                        title: Text("Name"),
                        onTap: () {
                          // When a patient is tapped:
                          selectedPatient.value = patient;
                          formFieldState.didChange(
                            patient,
                          ); // Update the FormField
                          ////TODO: close with real resutl value
                          controller.closeView(
                            "RESULT",
                          ); // Close search and set text
                        },
                      );
                    }).toList();
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // --- DATE & TIME PICKERS (Unchanged) ---
            Row(
              children: [
                Expanded(
                  child: _buildDateTimePickerField(
                    context: context,
                    controller: dateController,
                    label: 'Date',
                    icon: CupertinoIcons.calendar,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        dateController.text = DateFormat.yMMMMd().format(
                          pickedDate,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateTimePickerField(
                    context: context,
                    controller: timeController,
                    label: 'Time',
                    icon: CupertinoIcons.clock_fill,
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        timeController.text = pickedTime.format(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- SESSION TYPE (Unchanged) ---
            Text('Session Type', style: context.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<SessionType>(
                segments: const [
                  ButtonSegment(
                    value: SessionType.physical,
                    label: Text('Physical'),
                    icon: Icon(CupertinoIcons.building_2_fill),
                  ),
                  ButtonSegment(
                    value: SessionType.remote,
                    label: Text('Remote'),
                    icon: Icon(CupertinoIcons.video_camera_solid),
                  ),
                ],
                selected: {sessionType.value},
                onSelectionChanged: (newSelection) =>
                    sessionType.value = newSelection.first,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppTheme.accent.withOpacity(0.2),
                  selectedForegroundColor: AppTheme.accent,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- SAVE BUTTON (Unchanged) ---
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
                child: const Text('Save Appointment'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- HELPER METHODS (Unchanged) ---
  Widget _buildDateTimePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _inputDecoration(label: label, icon: icon),
      onTap: onTap,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a $label' : null,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? errorText,
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
      errorText: errorText,
    );
  }
}
