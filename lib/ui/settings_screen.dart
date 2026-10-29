import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final s = services.settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Nastavení')),
      body: ListenableBuilder(
        listenable: s,
        builder: (context, _) => ListView(
          children: [
            SwitchListTile(title: const Text('Zvuk'), value: s.sound, onChanged: (v) => s.sound = v),
            SwitchListTile(title: const Text('Vibrace'), value: s.haptics, onChanged: (v) => s.haptics = v),
            SwitchListTile(
              title: const Text('Automatické přebíjení'),
              subtitle: const Text('Jinak přebiješ přejetím prstu dolů nebo ťuknutím na náboje.'),
              value: s.autoReload,
              onChanged: (v) => s.autoReload = v,
            ),
            if (kDebugMode)
              SwitchListTile(
                title: const Text('Debug: hitboxy a výstřely'),
                subtitle: const Text('Jen v debug buildu.'),
                value: s.debugOverlay,
                onChanged: (v) => s.debugOverlay = v,
              ),
          ],
        ),
      ),
    );
  }
}
