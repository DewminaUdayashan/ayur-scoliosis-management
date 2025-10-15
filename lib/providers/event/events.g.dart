// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'35c28c4d76ae91141047295746e372716443edda';

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

/// See also [events].
@ProviderFor(events)
const eventsProvider = EventsFamily();

/// See also [events].
class EventsFamily extends Family<AsyncValue<List<PatientEvent>>> {
  /// See also [events].
  const EventsFamily();

  /// See also [events].
  EventsProvider call(String? patientId) {
    return EventsProvider(patientId);
  }

  @override
  EventsProvider getProviderOverride(covariant EventsProvider provider) {
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
  String? get name => r'eventsProvider';
}

/// See also [events].
class EventsProvider extends AutoDisposeFutureProvider<List<PatientEvent>> {
  /// See also [events].
  EventsProvider(String? patientId)
    : this._internal(
        (ref) => events(ref as EventsRef, patientId),
        from: eventsProvider,
        name: r'eventsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$eventsHash,
        dependencies: EventsFamily._dependencies,
        allTransitiveDependencies: EventsFamily._allTransitiveDependencies,
        patientId: patientId,
      );

  EventsProvider._internal(
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
  Override overrideWith(
    FutureOr<List<PatientEvent>> Function(EventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventsProvider._internal(
        (ref) => create(ref as EventsRef),
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
  AutoDisposeFutureProviderElement<List<PatientEvent>> createElement() {
    return _EventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsProvider && other.patientId == patientId;
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
mixin EventsRef on AutoDisposeFutureProviderRef<List<PatientEvent>> {
  /// The parameter `patientId` of this provider.
  String? get patientId;
}

class _EventsProviderElement
    extends AutoDisposeFutureProviderElement<List<PatientEvent>>
    with EventsRef {
  _EventsProviderElement(super.provider);

  @override
  String? get patientId => (origin as EventsProvider).patientId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
