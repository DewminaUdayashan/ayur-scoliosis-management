import 'package:json_annotation/json_annotation.dart';

enum SessionType { physical, remote }

enum AppointmentType {
  @JsonValue('Physical')
  physical,
  @JsonValue('Remote')
  remote,
}

enum AppointmentStatus {
  @JsonValue('Scheduled')
  scheduled,
  @JsonValue('Completed')
  completed,
  @JsonValue('Cancelled')
  cancelled,
  @JsonValue('NoShow')
  noShow,
}

enum EventType {
  @JsonValue('AppointmentCompleted')
  appointmentCompleted,
  @JsonValue('XRayUpload')
  xRayUpload,
  @JsonValue('AIClassification')
  aiClassification,
  @JsonValue('CobbAngleMeasurement')
  cobbAngleMeasurement,
  @JsonValue('SessionNote')
  sessionNote,
}

enum AIClassificationType {
  @JsonValue('NoScoliosisDetected')
  noScoliosisDetected,
  @JsonValue('ScoliosisCCurve')
  scoliosisCCurve,
  @JsonValue('ScoliosisSCurve')
  scoliosisSCurve,
  @JsonValue('NotASpinalXray')
  notASpinalXray,
  @JsonValue('NoXrayDetected')
  noXrayDetected,
  @JsonValue('AnalysisFailed')
  analysisFailed,
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

@JsonEnum(valueField: 'code')
enum ApiResponseCode {
  registrationSuccess('REGISTRATION_SUCCESS');

  const ApiResponseCode(this.code);
  final String code;
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
