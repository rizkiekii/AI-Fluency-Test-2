import 'package:flutter/material.dart';

import '../widget_keys.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Item Overview',
              key: VaultWidgetKeys.detailTitleText,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Category',
              key: VaultWidgetKeys.detailCategoryText,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: const Text(
                'Sensitive value preview',
                key: VaultWidgetKeys.detailSecretMaskedText,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sensitive record details can be shown here.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}