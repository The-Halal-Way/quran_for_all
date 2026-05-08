import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionRequestResult {
  const PermissionRequestResult(this.statuses);

  final Map<Permission, PermissionStatus> statuses;

  bool get allGranted =>
      denied.isEmpty && permanentlyDenied.isEmpty && restricted.isEmpty;

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
      return currentStatus;
    }

    return permission.request();
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
      } else {
        toRequest.add(permission);
      }
    }

    if (toRequest.isNotEmpty) {
      statuses.addAll(await toRequest.request());
    }

    return statuses;
  }

  Future<PermissionRequestResult> requestWithSummary(
    List<Permission> permissions,
  ) async {
    final statuses = await requestPermissions(permissions);
    return PermissionRequestResult(statuses);
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

  bool _isEffectivelyGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited || status.isProvisional;
  }
}
