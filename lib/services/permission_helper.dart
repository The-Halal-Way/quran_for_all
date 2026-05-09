import 'dart:io';

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

    final shouldShowRationale =
        await permission.shouldShowRequestRationale;
    if (shouldShowRationale) {
      _rejectedPermissions.add(permission);
    }

    return shouldShowRationale;
  }

  bool _isEffectivelyGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited || status.isProvisional;
  }
}
