import 'package:ayur_scoliosis_management/core/utils/logger.dart';
import 'package:ayur_scoliosis_management/models/appointment/schedule_appointment_payload.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointments.dart';
import 'package:ayur_scoliosis_management/providers/patient/patients.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/enums.dart';
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class AddAppointmentSheet extends HookConsumerWidget {
  const AddAppointmentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final appointmentNameController = useTextEditingController();
    final dateController = useTextEditingController();
    final timeController = useTextEditingController();
    final durationController = useTextEditingController();
    final notesController = useTextEditingController();
    final searchController = useMemoized(() => SearchController());
    final selectedPatient = useState<AppUser?>(null);
    final sessionType = useState<AppointmentType>(AppointmentType.physical);
    final isSubmitting = useState<bool>(false);
    final selectedTime = useState<TimeOfDay?>(null);
    final errorText = useState<String?>(null);

    // --- FORM SUBMISSION LOGIC ---
    Future<void> submitForm() async {
      if (formKey.currentState?.validate() ?? false) {
        isSubmitting.value = true;

        try {
          // Parse date and time
          final dateStr = dateController.text;
          final timeOfDay = selectedTime.value;

          if (dateStr.isEmpty || timeOfDay == null) {
            throw Exception('Please select both date and time');
          }

          // Parse the date
          final parsedDate = DateFormat.yMMMMd().parse(dateStr);

          // Combine date and time using the actual TimeOfDay object
          final appointmentDateTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );

          // Parse duration
          final duration = int.parse(durationController.text);

          // Create appointment payload
          final payload = ScheduleAppointmentPayload(
            name: appointmentNameController.text,
            patientId: selectedPatient.value!.id,
            date: appointmentDateTime,
            durationMinutes: duration,
            type: sessionType.value,
            notes: notesController.text.isEmpty ? null : notesController.text,
          );

          // Schedule appointment using the provider
          await ref
              .read(appointmentsProvider().notifier)
              .scheduleAppointment(payload);

          // Close the sheet on success
          if (context.mounted) {
            context.pop();
          }
        } catch (e) {
          Log.e(e);
          errorText.value = e.toString();
        } finally {
          isSubmitting.value = false;
        }
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

            // --- APPOINTMENT NAME ---
            TextFormField(
              controller: appointmentNameController,
              decoration: _inputDecoration(
                label: 'Appointment Name',
                icon: CupertinoIcons.text_cursor,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter an appointment name'
                  : null,
            ),
            const SizedBox(height: 16),

            // --- PATIENT SEARCH ANCHOR ---
            FormField<AppUser>(
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
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    final searchText = controller.text.toLowerCase();

                    // Update search query when text changes
                    if (searchQuery.value != searchText) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        searchQuery.value = searchText;
                      });
                    }

                    // Use StatefulBuilder to manage local state and trigger rebuilds
                    return [
                      StatefulBuilder(
                        builder: (context, setState) {
                          // Use a Consumer to watch the provider
                          return Consumer(
                            builder: (context, ref, child) {
                              final patientsAsyncValue = ref.watch(
                                patientsProvider(searchText),
                              );

                              return patientsAsyncValue.when(
                                data: (pages) {
                                  final patientsList = pages
                                      .map((page) => page.data)
                                      .expand((patient) => patient)
                                      .toList();

                                  if (patientsList.isEmpty) {
                                    return const ListTile(
                                      title: Text('No patients found'),
                                      enabled: false,
                                    );
                                  }

                                  // Return a Column containing all patient tiles
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: patientsList.map((patient) {
                                      return ListTile(
                                        title: Text(patient.fullName),
                                        subtitle: Text(patient.email),
                                        onTap: () {
                                          selectedPatient.value = patient;
                                          formFieldState.didChange(patient);
                                          controller.closeView(
                                            patient.fullName,
                                          );
                                        },
                                      );
                                    }).toList(),
                                  );
                                },
                                loading: () => const ListTile(
                                  title: Text('Searching patients...'),
                                  leading: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  enabled: false,
                                ),
                                error: (error, stackTrace) => ListTile(
                                  title: const Text('Error loading patients'),
                                  subtitle: Text(error.toString()),
                                  enabled: false,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ];
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
                      if (pickedTime != null && context.mounted) {
                        selectedTime.value =
                            pickedTime; // Store the actual TimeOfDay
                        timeController.text = pickedTime.format(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- DURATION ---
            TextFormField(
              controller: durationController,
              decoration: _inputDecoration(
                label: 'Duration (minutes)',
                icon: CupertinoIcons.hourglass,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                final duration = int.tryParse(value);
                if (duration == null || duration <= 0) {
                  return 'Please enter a valid duration';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // --- SESSION TYPE (Unchanged) ---
            Text('Session Type', style: context.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AppointmentType>(
                segments: const [
                  ButtonSegment(
                    value: AppointmentType.physical,
                    label: Text('Physical'),
                    icon: Icon(CupertinoIcons.building_2_fill),
                  ),
                  ButtonSegment(
                    value: AppointmentType.remote,
                    label: Text('Remote'),
                    icon: Icon(CupertinoIcons.video_camera_solid),
                  ),
                ],
                selected: {sessionType.value},
                onSelectionChanged: (newSelection) =>
                    sessionType.value = newSelection.first,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppTheme.accent.withAlpha(50),
                  selectedForegroundColor: AppTheme.accent,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- NOTES (Optional) ---
            TextFormField(
              controller: notesController,
              decoration: _inputDecoration(
                label: 'Notes (Optional)',
                icon: CupertinoIcons.doc_text,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            if (errorText.value != null) ...[
              SizedBox(height: 12),
              Text(errorText.value!, style: TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 32),

            // --- SAVE BUTTON ---
            PrimaryButton(
              isLoading: isSubmitting.value,
              label: 'Save Appointment',
              onPressed: isSubmitting.value ? null : submitForm,
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
