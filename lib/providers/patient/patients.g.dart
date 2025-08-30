// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patients.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$patientsHash() => r'47e2379bd3a352b4a4be97c189e85994120ae0af';

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

abstract class _$Patients
    extends BuildlessAutoDisposeAsyncNotifier<List<Paginated<AppUser>>> {
  late final String? searchQuery;

  FutureOr<List<Paginated<AppUser>>> build(String? searchQuery);
}

/// See also [Patients].
@ProviderFor(Patients)
const patientsProvider = PatientsFamily();

/// See also [Patients].
class PatientsFamily extends Family<AsyncValue<List<Paginated<AppUser>>>> {
  /// See also [Patients].
  const PatientsFamily();

  /// See also [Patients].
  PatientsProvider call(String? searchQuery) {
    return PatientsProvider(searchQuery);
  }

  @override
  PatientsProvider getProviderOverride(covariant PatientsProvider provider) {
    return call(provider.searchQuery);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'patientsProvider';
}

/// See also [Patients].
class PatientsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          Patients,
          List<Paginated<AppUser>>
        > {
  /// See also [Patients].
  PatientsProvider(String? searchQuery)
    : this._internal(
        () => Patients()..searchQuery = searchQuery,
        from: patientsProvider,
        name: r'patientsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$patientsHash,
        dependencies: PatientsFamily._dependencies,
        allTransitiveDependencies: PatientsFamily._allTransitiveDependencies,
        searchQuery: searchQuery,
      );

  PatientsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  FutureOr<List<Paginated<AppUser>>> runNotifierBuild(
    covariant Patients notifier,
  ) {
    return notifier.build(searchQuery);
  }

  @override
  Override overrideWith(Patients Function() create) {
    return ProviderOverride(
      origin: this,
      override: PatientsProvider._internal(
        () => create()..searchQuery = searchQuery,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Patients, List<Paginated<AppUser>>>
  createElement() {
    return _PatientsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientsProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PatientsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Paginated<AppUser>>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _PatientsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          Patients,
          List<Paginated<AppUser>>
        >
    with PatientsRef {
  _PatientsProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as PatientsProvider).searchQuery;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
