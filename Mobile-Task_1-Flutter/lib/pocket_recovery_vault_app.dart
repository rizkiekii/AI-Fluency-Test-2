import 'package:flutter/widgets.dart';

import 'main.dart' as app;
import 'services/clipboard_service.dart';
import 'services/secure_screen_service.dart';
import 'services/vault_storage_service.dart';

Future<Widget> buildPocketRecoveryVaultApp({
  required VaultStorageService storageService,
  required ClipboardService clipboardService,
  required SecureScreenService secureScreenService,
}) async {
  return const app.PocketRecoveryVaultApp();
}