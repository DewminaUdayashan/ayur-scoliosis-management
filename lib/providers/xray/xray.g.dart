// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xray.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$xRayHash() => r'221cbea268842b3e6b4c9731c90edfd4b84d3f02';

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

abstract class _$XRay
    extends BuildlessAutoDisposeAsyncNotifier<List<Paginated<xray.Xray>>> {
  late final String? patientId;

  FutureOr<List<Paginated<xray.Xray>>> build({String? patientId});
}

/// See also [XRay].
@ProviderFor(XRay)
const xRayProvider = XRayFamily();

/// See also [XRay].
class XRayFamily extends Family<AsyncValue<List<Paginated<xray.Xray>>>> {
  /// See also [XRay].
  const XRayFamily();

  /// See also [XRay].
  XRayProvider call({String? patientId}) {
    return XRayProvider(patientId: patientId);
  }

  @override
  XRayProvider getProviderOverride(covariant XRayProvider provider) {
    return call(patientId: provider.patientId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'xRayProvider';
}

/// See also [XRay].
class XRayProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<XRay, List<Paginated<xray.Xray>>> {
  /// See also [XRay].
  XRayProvider({String? patientId})
    : this._internal(
        () => XRay()..patientId = patientId,
        from: xRayProvider,
        name: r'xRayProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$xRayHash,
        dependencies: XRayFamily._dependencies,
        allTransitiveDependencies: XRayFamily._allTransitiveDependencies,
        patientId: patientId,
      );

  XRayProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.patientId,
  }) : super.internal();

  final String? patientId;

  @override
  FutureOr<List<Paginated<xray.Xray>>> runNotifierBuild(
    covariant XRay notifier,
  ) {
    return notifier.build(patientId: patientId);
  }

  @override
  Override overrideWith(XRay Function() create) {
    return ProviderOverride(
      origin: this,
      override: XRayProvider._internal(
        () => create()..patientId = patientId,
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
  AutoDisposeAsyncNotifierProviderElement<XRay, List<Paginated<xray.Xray>>>
  createElement() {
    return _XRayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is XRayProvider && other.patientId == patientId;
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
mixin XRayRef
    on AutoDisposeAsyncNotifierProviderRef<List<Paginated<xray.Xray>>> {
  /// The parameter `patientId` of this provider.
  String? get patientId;
}

class _XRayProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          XRay,
          List<Paginated<xray.Xray>>
        >
    with XRayRef {
  _XRayProviderElement(super.provider);

  @override
  String? get patientId => (origin as XRayProvider).patientId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
