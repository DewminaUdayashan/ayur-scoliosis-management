// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_call.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoCallRoomHash() => r'29f1727fc182517d5db089c72f96657edfa5e538';

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

/// Provider to get room by appointment ID
///
/// Copied from [videoCallRoom].
@ProviderFor(videoCallRoom)
const videoCallRoomProvider = VideoCallRoomFamily();

/// Provider to get room by appointment ID
///
/// Copied from [videoCallRoom].
class VideoCallRoomFamily
    extends Family<AsyncValue<VideoCallRoomWithAppointment>> {
  /// Provider to get room by appointment ID
  ///
  /// Copied from [videoCallRoom].
  const VideoCallRoomFamily();

  /// Provider to get room by appointment ID
  ///
  /// Copied from [videoCallRoom].
  VideoCallRoomProvider call(String appointmentId) {
    return VideoCallRoomProvider(appointmentId);
  }

  @override
  VideoCallRoomProvider getProviderOverride(
    covariant VideoCallRoomProvider provider,
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
  String? get name => r'videoCallRoomProvider';
}

/// Provider to get room by appointment ID
///
/// Copied from [videoCallRoom].
class VideoCallRoomProvider
    extends AutoDisposeFutureProvider<VideoCallRoomWithAppointment> {
  /// Provider to get room by appointment ID
  ///
  /// Copied from [videoCallRoom].
  VideoCallRoomProvider(String appointmentId)
    : this._internal(
        (ref) => videoCallRoom(ref as VideoCallRoomRef, appointmentId),
        from: videoCallRoomProvider,
        name: r'videoCallRoomProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$videoCallRoomHash,
        dependencies: VideoCallRoomFamily._dependencies,
        allTransitiveDependencies:
            VideoCallRoomFamily._allTransitiveDependencies,
        appointmentId: appointmentId,
      );

  VideoCallRoomProvider._internal(
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
    FutureOr<VideoCallRoomWithAppointment> Function(VideoCallRoomRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VideoCallRoomProvider._internal(
        (ref) => create(ref as VideoCallRoomRef),
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
  AutoDisposeFutureProviderElement<VideoCallRoomWithAppointment>
  createElement() {
    return _VideoCallRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoCallRoomProvider &&
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
mixin VideoCallRoomRef
    on AutoDisposeFutureProviderRef<VideoCallRoomWithAppointment> {
  /// The parameter `appointmentId` of this provider.
  String get appointmentId;
}

class _VideoCallRoomProviderElement
    extends AutoDisposeFutureProviderElement<VideoCallRoomWithAppointment>
    with VideoCallRoomRef {
  _VideoCallRoomProviderElement(super.provider);

  @override
  String get appointmentId => (origin as VideoCallRoomProvider).appointmentId;
}

String _$videoCallHash() => r'553223a51caa94a0678b4ceeae0462f736b965cb';

/// See also [VideoCall].
@ProviderFor(VideoCall)
final videoCallProvider =
    AutoDisposeNotifierProvider<VideoCall, VideoCallState>.internal(
      VideoCall.new,
      name: r'videoCallProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$videoCallHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VideoCall = AutoDisposeNotifier<VideoCallState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
