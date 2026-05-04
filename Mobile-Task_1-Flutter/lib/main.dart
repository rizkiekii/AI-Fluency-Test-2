import 'package:flutter/material.dart';

import 'screens/setup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PocketRecoveryVaultApp());
}

class PocketRecoveryVaultApp extends StatelessWidget {
  const PocketRecoveryVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pocket Recovery Vault',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const SetupScreen(),
    );
  }
}
