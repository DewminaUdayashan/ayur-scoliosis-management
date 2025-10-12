import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum ApiResponseCode {
  registrationSuccess('REGISTRATION_SUCCESS'),
  passwordChangeRequired('PASSWORD_CHANGE_REQUIRED'),
  loginSuccess('LOGIN_SUCCESS');

  const ApiResponseCode(this.code);
  final String code;
}

enum SessionType { physical, remote }

@JsonEnum(valueField: 'value')
enum AppointmentType {
  physical('Physical'),
  remote('Remote');

  const AppointmentType(this.value);
  final String value;
}

enum AppointmentStatus {
  @JsonValue('PendingPatientConfirmation')
  pendingConfirmation('Pending Confirmation', Colors.white, AppTheme.warning),
  @JsonValue('Scheduled')
  scheduled('Scheduled', Colors.white, AppTheme.primary),
  @JsonValue('Completed')
  completed('Completed', Colors.white, Colors.green),
  @JsonValue('Cancelled')
  cancelled('Cancelled', Colors.white, AppTheme.error),
  @JsonValue('NoShow')
  noShow('No Show', AppTheme.textSecondary, Colors.black54);

  const AppointmentStatus(this.value, this.textColor, this.backgroundColor);
  final String value;
  final Color textColor;
  final Color backgroundColor;
}

enum EventType {
  @JsonValue('AppointmentCompleted')
  appointmentCompleted('Appointment Completed'),
  @JsonValue('XRayUpload')
  xRayUpload('X-Ray Uploaded'),
  @JsonValue('AIClassification')
  aiClassification('AI Classification'),
  @JsonValue('CobbAngleMeasurement')
  cobbAngleMeasurement('Cobb Angle Measurement'),
  @JsonValue('SessionNote')
  sessionNote('Session Note');

  const EventType(this.value);
  final String value;
}

enum AIClassificationType {
  @JsonValue('NoScoliosisDetected')
  noScoliosisDetected('No Scoliosis Detected'),
  @JsonValue('ScoliosisCCurve')
  scoliosisCCurve('Scoliosis C Curve'),
  @JsonValue('ScoliosisSCurve')
  scoliosisSCurve('Scoliosis S Curve'),
  @JsonValue('NotASpinalXray')
  notASpinalXray('Not A Spinal X-ray'),
  @JsonValue('NoXrayDetected')
  noXrayDetected('No X-ray Detected'),
  @JsonValue('AnalysisFailed')
  analysisFailed('Analysis Failed');

  const AIClassificationType(this.value);
  final String value;
}

enum UserRole {
  @JsonValue('Patient')
  patient,
  @JsonValue('Practitioner')
  practitioner,
}

enum AccountStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('Active')
  active,
  @JsonValue('Inactive')
  inactive,
  @JsonValue('Suspended')
  suspended,
}

@JsonEnum(valueField: 'value')
enum Gender {
  male('Male'),
  female('Female');

  const Gender(this.value);
  final String value;
}

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
  unknown,
  passwordMustSetup,
  pendingActivation,
}

enum SortOrder {
  ascending('asc'),
  descending('desc');

  const SortOrder(this.value);
  final String value;
}
