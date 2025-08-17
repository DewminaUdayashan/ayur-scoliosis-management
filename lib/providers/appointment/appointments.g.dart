// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appointmentsHash() => r'c0061e8c48b3fa1d0d12c53d009d2d327a8e071a';

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

abstract class _$Appointments
    extends BuildlessAutoDisposeAsyncNotifier<List<Paginated<Appointment>>> {
  late final DateTime? startDate;
  late final DateTime? endDate;

  FutureOr<List<Paginated<Appointment>>> build({
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// See also [Appointments].
@ProviderFor(Appointments)
const appointmentsProvider = AppointmentsFamily();

/// See also [Appointments].
class AppointmentsFamily
    extends Family<AsyncValue<List<Paginated<Appointment>>>> {
  /// See also [Appointments].
  const AppointmentsFamily();

  /// See also [Appointments].
  AppointmentsProvider call({DateTime? startDate, DateTime? endDate}) {
    return AppointmentsProvider(startDate: startDate, endDate: endDate);
  }

  @override
  AppointmentsProvider getProviderOverride(
    covariant AppointmentsProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'appointmentsProvider';
}

/// See also [Appointments].
class AppointmentsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          Appointments,
          List<Paginated<Appointment>>
        > {
  /// See also [Appointments].
  AppointmentsProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        () => Appointments()
          ..startDate = startDate
          ..endDate = endDate,
        from: appointmentsProvider,
        name: r'appointmentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$appointmentsHash,
        dependencies: AppointmentsFamily._dependencies,
        allTransitiveDependencies:
            AppointmentsFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  AppointmentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  FutureOr<List<Paginated<Appointment>>> runNotifierBuild(
    covariant Appointments notifier,
  ) {
    return notifier.build(startDate: startDate, endDate: endDate);
  }

  @override
  Override overrideWith(Appointments Function() create) {
    return ProviderOverride(
      origin: this,
      override: AppointmentsProvider._internal(
        () => create()
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    Appointments,
    List<Paginated<Appointment>>
  >
  createElement() {
    return _AppointmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppointmentsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Paginated<Appointment>>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _AppointmentsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          Appointments,
          List<Paginated<Appointment>>
        >
    with AppointmentsRef {
  _AppointmentsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as AppointmentsProvider).startDate;
  @override
  DateTime? get endDate => (origin as AppointmentsProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
