class Api {
  Api._();
  static final Api _instance = Api._();
  factory Api() => _instance;

  // For development on different platforms
  static String get baseUrl {
    return 'http://192.168.1.120:3000'; // Default to localhost for development
  }

  static String get classifierBaseUrl {
    return 'http://192.168.1.120:8000';
  }

  static final _apiPath = '/';

  /// Auth endpoints
  String get authPath => '$_apiPath/auth';
  String get signUpPractitioner => '$authPath/register/practitioner';
  String get signIn => '$authPath/login';
  String get forgotPassword => '$authPath/forgot-password';
  String get resetPassword => '$authPath/reset-password';
  String get setPassword => '$authPath/patient/set-password';
  String get authStatus => '$authPath/status';
  String get signOut => '$authPath/sign-out';

  /// Patient endpoints
  String get patientPath => '$_apiPath/patient';
  String get patients => '$patientPath/patients';
  String get invitePatient => '$patientPath/invite';
  String patientDetails(String id) => '$patientPath/$id';

  /// Profile endpoints
  String get profilePath => '$_apiPath/profile';

  /// Appointment endpoints
  String get appointmentsPath => '$_apiPath/appointments';
  String appointmentDetails(String id) => '$appointmentsPath/$id';
  String get scheduleAppointment => '$appointmentsPath/schedule';
  String get checkAvailability => '$appointmentsPath/check-availability';
  String respondToAppointment(String id) => '$appointmentsPath/$id/respond';
  String completeAppointment(String id) => '$appointmentsPath/$id/complete';
  String updateAppointmentNotes(String id) => '$appointmentsPath/$id/notes';
  String get upcomingAppointments => '$appointmentsPath/upcoming';
  String get dates => '$appointmentsPath/dates';

  /// XRay
  String get xrayPath => '$_apiPath/xray';
  String get uploadXRay => '$xrayPath/upload';
  String get measure => '$xrayPath/measurements';
  String getMeasurement(String xrayId) => '$measure/$xrayId';

  /// Event endpoints
  String get eventsPath => '$_apiPath/patient-event';

  /// Video Call endpoints
  String get videoCallPath => '$_apiPath/video-call';
  String get videoCallRoom => '$videoCallPath/room';
  String videoCallRoomByAppointment(String appointmentId) =>
      '$videoCallRoom/appointment/$appointmentId';
  String createVideoCallRoom(String appointmentId) =>
      '$videoCallRoom/appointment/$appointmentId/create';

  String get classifyImageType => '$classifierBaseUrl/classify_image_type';
}
