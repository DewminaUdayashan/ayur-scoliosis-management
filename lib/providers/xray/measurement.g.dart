// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$measurementByIdHash() => r'af61ea7ac2e93d278ed9a3778c92ef33abb24938';

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

abstract class _$MeasurementById
    extends BuildlessAutoDisposeAsyncNotifier<List<Measurement>> {
  late final String xrayId;

  FutureOr<List<Measurement>> build(String xrayId);
}

/// See also [MeasurementById].
@ProviderFor(MeasurementById)
const measurementByIdProvider = MeasurementByIdFamily();

/// See also [MeasurementById].
class MeasurementByIdFamily extends Family<AsyncValue<List<Measurement>>> {
  /// See also [MeasurementById].
  const MeasurementByIdFamily();

  /// See also [MeasurementById].
  MeasurementByIdProvider call(String xrayId) {
    return MeasurementByIdProvider(xrayId);
  }

  @override
  MeasurementByIdProvider getProviderOverride(
    covariant MeasurementByIdProvider provider,
  ) {
    return call(provider.xrayId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'measurementByIdProvider';
}

/// See also [MeasurementById].
class MeasurementByIdProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MeasurementById,
          List<Measurement>
        > {
  /// See also [MeasurementById].
  MeasurementByIdProvider(String xrayId)
    : this._internal(
        () => MeasurementById()..xrayId = xrayId,
        from: measurementByIdProvider,
        name: r'measurementByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$measurementByIdHash,
        dependencies: MeasurementByIdFamily._dependencies,
        allTransitiveDependencies:
            MeasurementByIdFamily._allTransitiveDependencies,
        xrayId: xrayId,
      );

  MeasurementByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.xrayId,
  }) : super.internal();

  final String xrayId;

  @override
  FutureOr<List<Measurement>> runNotifierBuild(
    covariant MeasurementById notifier,
  ) {
    return notifier.build(xrayId);
  }

  @override
  Override overrideWith(MeasurementById Function() create) {
    return ProviderOverride(
      origin: this,
      override: MeasurementByIdProvider._internal(
        () => create()..xrayId = xrayId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        xrayId: xrayId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MeasurementById, List<Measurement>>
  createElement() {
    return _MeasurementByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MeasurementByIdProvider && other.xrayId == xrayId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, xrayId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MeasurementByIdRef
    on AutoDisposeAsyncNotifierProviderRef<List<Measurement>> {
  /// The parameter `xrayId` of this provider.
  String get xrayId;
}

class _MeasurementByIdProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MeasurementById,
          List<Measurement>
        >
    with MeasurementByIdRef {
  _MeasurementByIdProviderElement(super.provider);

  @override
  String get xrayId => (origin as MeasurementByIdProvider).xrayId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
