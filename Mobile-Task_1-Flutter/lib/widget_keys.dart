import 'package:flutter/material.dart';

final class VaultWidgetKeys {
  const VaultWidgetKeys._();

  static const setupScreenTitle = Key('setup_screen_title');
  static const setupPinInput = Key('setup_pin_input');
  static const setupPinConfirmInput = Key('setup_pin_confirm_input');
  static const setupPinErrorText = Key('setup_pin_error_text');
  static const setupCreateVaultButton = Key('setup_create_vault_button');

  static const unlockScreenTitle = Key('unlock_screen_title');
  static const unlockPinInput = Key('unlock_pin_input');
  static const unlockSubmitButton = Key('unlock_submit_button');
  static const unlockErrorText = Key('unlock_error_text');

  static const homeScreenTitle = Key('home_screen_title');
  static const homeSearchInput = Key('home_search_input');
  static const homeEmptyStateText = Key('home_empty_state_text');
  static const homeAddItemButton = Key('home_add_item_button');
  static const homeLockNowButton = Key('home_lock_now_button');

  static Key itemTile(String itemId) => Key('vault_item_tile_$itemId');
  static Key itemTitle(String itemId) => Key('vault_item_title_$itemId');

  static const editorScreenTitle = Key('editor_screen_title');
  static const editorCancelButton = Key('editor_cancel_button');
  static const editorTitleInput = Key('editor_title_input');
  static const editorCategoryDropdown = Key('editor_category_dropdown');
  static const editorCategoryOptionCredential = Key('editor_category_option_credential');
  static const editorCategoryOptionRecoveryCode = Key('editor_category_option_recovery_code');
  static const editorCategoryOptionDocumentReference = Key('editor_category_option_document_reference');
  static const editorCategoryOptionEmergencyNote = Key('editor_category_option_emergency_note');
  static const editorCategoryOptionHouseholdAccess = Key('editor_category_option_household_access');
  static const editorSecretInput = Key('editor_secret_input');
  static const editorValidationText = Key('editor_validation_text');
  static const editorSaveButton = Key('editor_save_button');

  static const detailTitleText = Key('detail_title_text');
  static const detailBackButton = Key('detail_back_button');
  static const detailCategoryText = Key('detail_category_text');
  static const detailSecretMaskedText = Key('detail_secret_masked_text');
  static const detailRevealButton = Key('detail_reveal_button');
  static const detailCopyButton = Key('detail_copy_button');
  static const detailCopyFeedbackText = Key('detail_copy_feedback_text');
  static const detailEditButton = Key('detail_edit_button');
}