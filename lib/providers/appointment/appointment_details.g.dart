// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appointmentDetailsHash() =>
    r'5db5502b375fb3bce4752e4cb7fb20f9bf6f1f38';

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

/// See also [appointmentDetails].
@ProviderFor(appointmentDetails)
const appointmentDetailsProvider = AppointmentDetailsFamily();

/// See also [appointmentDetails].
class AppointmentDetailsFamily extends Family<AsyncValue<Appointment>> {
  /// See also [appointmentDetails].
  const AppointmentDetailsFamily();

  /// See also [appointmentDetails].
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

/// See also [appointmentDetails].
class AppointmentDetailsProvider
    extends AutoDisposeFutureProvider<Appointment> {
  /// See also [appointmentDetails].
  AppointmentDetailsProvider(String appointmentId)
    : this._internal(
        (ref) =>
            appointmentDetails(ref as AppointmentDetailsRef, appointmentId),
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
  Override overrideWith(
    FutureOr<Appointment> Function(AppointmentDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppointmentDetailsProvider._internal(
        (ref) => create(ref as AppointmentDetailsRef),
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
  AutoDisposeFutureProviderElement<Appointment> createElement() {
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
mixin AppointmentDetailsRef on AutoDisposeFutureProviderRef<Appointment> {
  /// The parameter `appointmentId` of this provider.
  String get appointmentId;
}

class _AppointmentDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Appointment>
    with AppointmentDetailsRef {
  _AppointmentDetailsProviderElement(super.provider);

  @override
  String get appointmentId =>
      (origin as AppointmentDetailsProvider).appointmentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
