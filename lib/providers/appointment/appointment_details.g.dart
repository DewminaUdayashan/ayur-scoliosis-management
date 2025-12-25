// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appointmentDetailsHash() =>
    r'3329cda773136d9cbf4de6124724ecc6efaa513e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AppointmentDetails
    extends BuildlessAutoDisposeAsyncNotifier<Appointment> {
  late final String appointmentId;

  FutureOr<Appointment> build(String appointmentId);
}

/// See also [AppointmentDetails].
@ProviderFor(AppointmentDetails)
const appointmentDetailsProvider = AppointmentDetailsFamily();

/// See also [AppointmentDetails].
class AppointmentDetailsFamily extends Family<AsyncValue<Appointment>> {
  /// See also [AppointmentDetails].
  const AppointmentDetailsFamily();

  /// See also [AppointmentDetails].
  AppointmentDetailsProvider call(String appointmentId) {
    return AppointmentDetailsProvider(appointmentId);
  }

  @override
  AppointmentDetailsProvider getProviderOverride(
    covariant AppointmentDetailsProvider provider,
  ) {
    return call(provider.appointmentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'appointmentDetailsProvider';
}

/// See also [AppointmentDetails].
class AppointmentDetailsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<AppointmentDetails, Appointment> {
  /// See also [AppointmentDetails].
  AppointmentDetailsProvider(String appointmentId)
    : this._internal(
        () => AppointmentDetails()..appointmentId = appointmentId,
        from: appointmentDetailsProvider,
        name: r'appointmentDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$appointmentDetailsHash,
        dependencies: AppointmentDetailsFamily._dependencies,
        allTransitiveDependencies:
            AppointmentDetailsFamily._allTransitiveDependencies,
        appointmentId: appointmentId,
      );

  AppointmentDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.appointmentId,
  }) : super.internal();

  final String appointmentId;

  @override
  FutureOr<Appointment> runNotifierBuild(
    covariant AppointmentDetails notifier,
  ) {
    return notifier.build(appointmentId);
  }

  @override
  Override overrideWith(AppointmentDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: AppointmentDetailsProvider._internal(
        () => create()..appointmentId = appointmentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        appointmentId: appointmentId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AppointmentDetails, Appointment>
  createElement() {
    return _AppointmentDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentDetailsProvider &&
        other.appointmentId == appointmentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, appointmentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppointmentDetailsRef
    on AutoDisposeAsyncNotifierProviderRef<Appointment> {
  /// The parameter `appointmentId` of this provider.
  String get appointmentId;
}

class _AppointmentDetailsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<AppointmentDetails, Appointment>
    with AppointmentDetailsRef {
  _AppointmentDetailsProviderElement(super.provider);

  @override
  String get appointmentId =>
      (origin as AppointmentDetailsProvider).appointmentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
