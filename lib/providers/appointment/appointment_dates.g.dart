// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_dates.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appointmentDatesHash() => r'6b16b20f210eb073d50c5226f48ff3b2735002c1';

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

/// See also [appointmentDates].
@ProviderFor(appointmentDates)
const appointmentDatesProvider = AppointmentDatesFamily();

/// See also [appointmentDates].
class AppointmentDatesFamily extends Family<AsyncValue<List<DateTime>>> {
  /// See also [appointmentDates].
  const AppointmentDatesFamily();

  /// See also [appointmentDates].
  AppointmentDatesProvider call(DateTime? startDate, DateTime? endDate) {
    return AppointmentDatesProvider(startDate, endDate);
  }

  @override
  AppointmentDatesProvider getProviderOverride(
    covariant AppointmentDatesProvider provider,
  ) {
    return call(provider.startDate, provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'appointmentDatesProvider';
}

/// See also [appointmentDates].
class AppointmentDatesProvider
    extends AutoDisposeFutureProvider<List<DateTime>> {
  /// See also [appointmentDates].
  AppointmentDatesProvider(DateTime? startDate, DateTime? endDate)
    : this._internal(
        (ref) =>
            appointmentDates(ref as AppointmentDatesRef, startDate, endDate),
        from: appointmentDatesProvider,
        name: r'appointmentDatesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$appointmentDatesHash,
        dependencies: AppointmentDatesFamily._dependencies,
        allTransitiveDependencies:
            AppointmentDatesFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  AppointmentDatesProvider._internal(
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
  Override overrideWith(
    FutureOr<List<DateTime>> Function(AppointmentDatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppointmentDatesProvider._internal(
        (ref) => create(ref as AppointmentDatesRef),
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
  AutoDisposeFutureProviderElement<List<DateTime>> createElement() {
    return _AppointmentDatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentDatesProvider &&
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
mixin AppointmentDatesRef on AutoDisposeFutureProviderRef<List<DateTime>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _AppointmentDatesProviderElement
    extends AutoDisposeFutureProviderElement<List<DateTime>>
    with AppointmentDatesRef {
  _AppointmentDatesProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as AppointmentDatesProvider).startDate;
  @override
  DateTime? get endDate => (origin as AppointmentDatesProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
