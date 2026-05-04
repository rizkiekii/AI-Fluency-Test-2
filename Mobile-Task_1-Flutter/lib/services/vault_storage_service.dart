abstract class VaultStorageService {
  Future<bool> vaultExists();

  Future<String?> readVaultDocument();

  Future<void> writeVaultDocument(String document);
}