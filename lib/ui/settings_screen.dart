import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_services.dart';
import '../l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final s = services.settings;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuSettings)),
      body: ListenableBuilder(
        listenable: s,
        builder: (context, _) => ListView(
          children: [
            SwitchListTile(title: Text(l10n.settingsSound), value: s.sound, onChanged: (v) => s.sound = v),
            SwitchListTile(title: Text(l10n.settingsHaptics), value: s.haptics, onChanged: (v) => s.haptics = v),
            SwitchListTile(
              title: Text(l10n.settingsAutoReload),
              subtitle: Text(l10n.settingsAutoReloadHint),
              value: s.autoReload,
              onChanged: (v) => s.autoReload = v,
            ),
            if (services.store.supported)
              ListTile(
                leading: const Icon(Icons.restore),
                title: Text(l10n.settingsRestore),
                onTap: services.store.restore,
              ),
            if (kDebugMode)
              SwitchListTile(
                title: Text(l10n.settingsDebug),
                subtitle: Text(l10n.settingsDebugHint),
                value: s.debugOverlay,
                onChanged: (v) => s.debugOverlay = v,
              ),
          ],
        ),
      ),
    );
  }
}
