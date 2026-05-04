enum VaultCategory {
  credential('Credential'),
  recoveryCode('Recovery Code'),
  documentReference('Document Reference'),
  emergencyNote('Emergency Note'),
  householdAccess('Household Access');

  const VaultCategory(this.label);

  final String label;
}

class VaultItemDraft {
  const VaultItemDraft({
    required this.title,
    required this.category,
    required this.secretValue,
  });

  final String title;
  final VaultCategory category;
  final String secretValue;
}

class VaultItem {
  const VaultItem({
    required this.id,
    required this.title,
    required this.category,
    required this.secretValue,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final VaultCategory category;
  final String secretValue;
  final DateTime createdAt;
  final DateTime updatedAt;
}