import 'package:get/get.dart';

import '../../core/enums/google_sync_status.dart';
import '../../domain/entities/google_calendar_connection.dart';
import '../../usecases/google_calendar/params.dart';
import '../../usecases/usecase.dart';

final class SettingsController extends GetxController {
  SettingsController(
    this._getAuthUrl,
    this._exchangeCode,
    this._disconnect,
    this._getConnectionStatus,
    this._toggleSync,
    this._triggerSync,
  );

  final UseCase<String, NoParams> _getAuthUrl;
  final UseCase<void, ExchangeCodeParams> _exchangeCode;
  final UseCase<void, NoParams> _disconnect;
  final UseCase<GoogleCalendarConnection?, NoParams> _getConnectionStatus;
  final UseCase<void, ToggleSyncParams> _toggleSync;
  final UseCase<void, NoParams> _triggerSync;

  final connection = Rxn<GoogleCalendarConnection>();
  final syncStatus = GoogleSyncStatus.disconnected.obs;
  final isLoading = false.obs;
  final isSyncing = false.obs;
  final errorMessage = Rxn<String>();
  final pendingAuthUrl = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadConnectionStatus();
  }

  Future<void> loadConnectionStatus() async {
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _getConnectionStatus(const NoParams());
    result.fold(
      ok: (conn) {
        connection.value = conn;
        syncStatus.value = conn != null
            ? GoogleSyncStatus.connected
            : GoogleSyncStatus.disconnected;
      },
      err: (f) {
        errorMessage.value = f.message;
        syncStatus.value = GoogleSyncStatus.error;
      },
    );
    isLoading.value = false;
  }

  Future<void> connectGoogle() async {
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _getAuthUrl(const NoParams());
    result.fold(
      ok: (url) => pendingAuthUrl.value = url,
      err: (f) => errorMessage.value = f.message,
    );
    isLoading.value = false;
  }

  Future<void> submitAuthCode(String code) async {
    if (code.trim().isEmpty) return;
    isLoading.value = true;
    errorMessage.value = null;
    pendingAuthUrl.value = null;
    final result = await _exchangeCode((code: code.trim()));
    await result.fold(
      ok: (_) => loadConnectionStatus(),
      err: (f) async {
        errorMessage.value = f.message;
        syncStatus.value = GoogleSyncStatus.error;
      },
    );
    isLoading.value = false;
  }

  Future<void> disconnectGoogle() async {
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _disconnect(const NoParams());
    await result.fold(
      ok: (_) => loadConnectionStatus(),
      err: (f) async {
        errorMessage.value = f.message;
      },
    );
    isLoading.value = false;
  }

  Future<void> toggleSync({required bool enabled}) async {
    final result = await _toggleSync((enabled: enabled));
    result.fold(
      ok: (_) {
        if (connection.value != null) {
          connection.value = connection.value!.copyWith(syncEnabled: enabled);
        }
      },
      err: (f) => errorMessage.value = f.message,
    );
  }

  Future<void> manualSync() async {
    isSyncing.value = true;
    errorMessage.value = null;
    syncStatus.value = GoogleSyncStatus.syncing;
    final result = await _triggerSync(const NoParams());
    result.fold(
      ok: (_) => syncStatus.value = GoogleSyncStatus.connected,
      err: (f) {
        errorMessage.value = f.message;
        syncStatus.value = GoogleSyncStatus.error;
      },
    );
    isSyncing.value = false;
    await loadConnectionStatus();
  }
}
