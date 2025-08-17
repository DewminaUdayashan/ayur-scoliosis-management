// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$patientDetailsHash() => r'db176a574914ecaa10d130d30dafc65ec2eb193f';

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

/// See also [patientDetails].
@ProviderFor(patientDetails)
const patientDetailsProvider = PatientDetailsFamily();

/// See also [patientDetails].
class PatientDetailsFamily extends Family<AsyncValue<AppUser>> {
  /// See also [patientDetails].
  const PatientDetailsFamily();

  /// See also [patientDetails].
  PatientDetailsProvider call(String patientId) {
    return PatientDetailsProvider(patientId);
  }

  @override
  PatientDetailsProvider getProviderOverride(
    covariant PatientDetailsProvider provider,
  ) {
    return call(provider.patientId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'patientDetailsProvider';
}

/// See also [patientDetails].
class PatientDetailsProvider extends AutoDisposeFutureProvider<AppUser> {
  /// See also [patientDetails].
  PatientDetailsProvider(String patientId)
    : this._internal(
        (ref) => patientDetails(ref as PatientDetailsRef, patientId),
        from: patientDetailsProvider,
        name: r'patientDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$patientDetailsHash,
        dependencies: PatientDetailsFamily._dependencies,
        allTransitiveDependencies:
            PatientDetailsFamily._allTransitiveDependencies,
        patientId: patientId,
      );

  PatientDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.patientId,
  }) : super.internal();

  final String patientId;

  @override
  Override overrideWith(
    FutureOr<AppUser> Function(PatientDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PatientDetailsProvider._internal(
        (ref) => create(ref as PatientDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        patientId: patientId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser> createElement() {
    return _PatientDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientDetailsProvider && other.patientId == patientId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, patientId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PatientDetailsRef on AutoDisposeFutureProviderRef<AppUser> {
  /// The parameter `patientId` of this provider.
  String get patientId;
}

class _PatientDetailsProviderElement
    extends AutoDisposeFutureProviderElement<AppUser>
    with PatientDetailsRef {
  _PatientDetailsProviderElement(super.provider);

  @override
  String get patientId => (origin as PatientDetailsProvider).patientId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
