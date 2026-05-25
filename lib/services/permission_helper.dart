import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestResult {
  const PermissionRequestResult(
    this.statuses, {
    this.previouslyRejected = const <Permission>{},
  });

  final Map<Permission, PermissionStatus> statuses;
  final Set<Permission> previouslyRejected;

  bool get allGranted =>
      denied.isEmpty && permanentlyDenied.isEmpty && restricted.isEmpty;

  bool get shouldPromptToOpenSettings =>
      permanentlyDenied.isNotEmpty ||
      restricted.isNotEmpty ||
      previouslyRejected.isNotEmpty;

  List<Permission> get granted => statuses.entries
      .where((entry) => _isEffectivelyGranted(entry.value))
      .map((entry) => entry.key)
      .toList(growable: false);

  List<Permission> get denied => statuses.entries
      .where((entry) => entry.value.isDenied)
      .map((entry) => entry.key)
      .toList(growable: false);

  List<Permission> get permanentlyDenied => statuses.entries
      .where((entry) => entry.value.isPermanentlyDenied)
      .map((entry) => entry.key)
      .toList(growable: false);

  List<Permission> get restricted => statuses.entries
      .where((entry) => entry.value.isRestricted)
      .map((entry) => entry.key)
      .toList(growable: false);

  List<Permission> get limited => statuses.entries
      .where((entry) => entry.value.isLimited)
      .map((entry) => entry.key)
      .toList(growable: false);

  bool isGranted(Permission permission) {
    final status = statuses[permission];
    if (status == null) {
      return false;
    }

    return _isEffectivelyGranted(status);
  }

  static bool _isEffectivelyGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited || status.isProvisional;
  }
}

class CompassListeningSession {
  const CompassListeningSession._(this._subscription);

  final StreamSubscription<CompassEvent> _subscription;

  Future<void> cancel() => _subscription.cancel();
}

class PermissionHelper {
  const PermissionHelper();

  static final Set<Permission> _rejectedPermissions = <Permission>{};

  Future<PermissionStatus> getStatus(Permission permission) {
    return permission.status;
  }

  Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return _isEffectivelyGranted(status);
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final currentStatus = await permission.status;
    if (_isEffectivelyGranted(currentStatus)) {
      _updateRejectionHistoryFor(permission, currentStatus);
      return currentStatus;
    }

    if (currentStatus.isPermanentlyDenied || currentStatus.isRestricted) {
      _updateRejectionHistoryFor(permission, currentStatus);
      return currentStatus;
    }

    // If this permission was already rejected before, skip another OS prompt
    // and let the caller surface a settings action immediately.
    if (await _isPreviouslyRejected(permission, currentStatus)) {
      _updateRejectionHistoryFor(permission, currentStatus);
      return currentStatus;
    }

    final requestedStatus = await permission.request();
    _updateRejectionHistoryFor(permission, requestedStatus);
    return requestedStatus;
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    if (permissions.isEmpty) {
      return const <Permission, PermissionStatus>{};
    }

    final statuses = <Permission, PermissionStatus>{};
    final toRequest = <Permission>[];

    for (final permission in permissions.toSet()) {
      final currentStatus = await permission.status;
      if (_isEffectivelyGranted(currentStatus)) {
        statuses[permission] = currentStatus;
      } else if (currentStatus.isPermanentlyDenied ||
          currentStatus.isRestricted) {
        statuses[permission] = currentStatus;
      } else if (await _isPreviouslyRejected(permission, currentStatus)) {
        // Respect previously rejected permissions and avoid re-prompting.
        statuses[permission] = currentStatus;
      } else {
        toRequest.add(permission);
      }
    }

    if (toRequest.isNotEmpty) {
      statuses.addAll(await toRequest.request());
    }

    _updateRejectionHistory(statuses);

    return statuses;
  }

  Future<PermissionRequestResult> requestWithSummary(
    List<Permission> permissions,
  ) async {
    final uniquePermissions = permissions.toSet().toList(growable: false);
    final previouslyRejected = <Permission>{};
    for (final permission in uniquePermissions) {
      final currentStatus = await permission.status;
      if (await _isPreviouslyRejected(permission, currentStatus)) {
        previouslyRejected.add(permission);
      }
    }
    final statuses = await requestPermissions(uniquePermissions);

    return PermissionRequestResult(
      statuses,
      previouslyRejected: Set.unmodifiable(previouslyRejected),
    );
  }

  Future<PermissionRequestResult> ensureAudioControlPermissions() {
    final requiredPermissions = <Permission>[];

    if (Platform.isAndroid || Platform.isIOS) {
      // Media-style controls typically depend on notification permission.
      requiredPermissions.add(Permission.notification);
    }

    return requestWithSummary(requiredPermissions);
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }

  void _updateRejectionHistory(Map<Permission, PermissionStatus> statuses) {
    for (final entry in statuses.entries) {
      _updateRejectionHistoryFor(entry.key, entry.value);
    }
  }

  void _updateRejectionHistoryFor(
    Permission permission,
    PermissionStatus status,
  ) {
    if (_isEffectivelyGranted(status)) {
      _rejectedPermissions.remove(permission);
      return;
    }

    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      _rejectedPermissions.add(permission);
    }
  }

  Future<bool> _isPreviouslyRejected(
    Permission permission,
    PermissionStatus status,
  ) async {
    if (_rejectedPermissions.contains(permission)) {
      return true;
    }

    // Android can tell if user denied this permission before, even after
    // process restarts. Use this to keep "next attempt -> settings" behavior
    // consistent on Android 13+ devices.
    if (!Platform.isAndroid || !status.isDenied) {
      return false;
    }

    final shouldShowRationale = await permission.shouldShowRequestRationale;
    if (shouldShowRationale) {
      _rejectedPermissions.add(permission);
    }

    return shouldShowRationale;
  }

  bool _isEffectivelyGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited || status.isProvisional;
  }

  Future<bool> hasNativeCompassFeature() async {
    return FlutterCompass.events != null;
  }

  Future<CompassListeningSession?> startCompassWithPermission({
    required Function(double heading) onHeadingChanged,
    required Function(String direction)
    onDirectionChanged, // e.g., 'East', 'West'
    double headingCorrectionDegrees = 0,
  }) async {
    final requiredPermissions = <Permission>[];
    if (Platform.isAndroid || Platform.isIOS) {
      requiredPermissions.add(Permission.locationWhenInUse);
    }

    final result = await requestWithSummary(requiredPermissions);

    if (requiredPermissions.any(
      (permission) => !result.isGranted(permission),
    )) {
      if (result.shouldPromptToOpenSettings) {
        await openSettings();
      } else {
        debugPrint('Compass permissions denied');
      }
      return null;
    }

    final events = FlutterCompass.events;
    if (events == null) {
      debugPrint('Compass sensor is not available on this device');
      return null;
    }

    final ready = Completer<bool>();
    late final StreamSubscription<CompassEvent> subscription;

    // flutter_compass returns a stream of CompassEvent
    subscription = events.listen(
      (CompassEvent event) {
        final heading = _extractHeading(event);
        if (heading == null) {
          return;
        }

        final correctedHeading =
            (heading + headingCorrectionDegrees + 360) % 360;

        onHeadingChanged(correctedHeading);
        onDirectionChanged(_getCardinalDirection(correctedHeading));

        if (!ready.isCompleted) {
          ready.complete(true);
        }
      },
      onError: (_) {
        if (!ready.isCompleted) {
          ready.complete(false);
        }
      },
    );

    final started = await ready.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => false,
    );

    if (!started) {
      await subscription.cancel();
      debugPrint('Compass data unavailable on this device');
      return null;
    }

    return CompassListeningSession._(subscription);
  }

  double? _extractHeading(CompassEvent event) {
    final heading = event.heading;
    if (heading != null) {
      return heading;
    }

    final dynamic dynamicEvent = event;
    final dynamic cameraHeading = dynamicEvent.headingForCameraMode;
    if (cameraHeading is num) {
      return cameraHeading.toDouble();
    }

    return null;
  }

  // Helper for cardinal direction (East/West emphasis)
  String _getCardinalDirection(double heading) {
    if (heading >= 315 || heading < 45) return 'North';
    if (heading >= 45 && heading < 135) return 'East';
    if (heading >= 135 && heading < 225) return 'South';
    if (heading >= 225 && heading < 315) return 'West';
    return 'Unknown';
  }
}
