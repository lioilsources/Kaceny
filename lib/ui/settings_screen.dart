import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';

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
            SwitchListTile(
              title: Text(l10n.settingsSound),
              value: s.sound,
              onChanged: (v) {
                if (!v) {
                  Telemetry.feature('sound_off');
                }
                s.sound = v;
              },
            ),
            SwitchListTile(
              title: Text(l10n.settingsHaptics),
              value: s.haptics,
              onChanged: (v) {
                if (!v) {
                  Telemetry.feature('haptics_off');
                }
                s.haptics = v;
              },
            ),
            SwitchListTile(
              title: Text(l10n.settingsAutoReload),
              subtitle: Text(l10n.settingsAutoReloadHint),
              value: s.autoReload,
              onChanged: (v) {
                if (v) {
                  Telemetry.feature('auto_reload');
                }
                s.autoReload = v;
              },
            ),
            if (services.store.supported)
              ListTile(
                leading: const Icon(Icons.restore),
                title: Text(l10n.settingsRestore),
                onTap: () {
                  Telemetry.feature('restore');
                  services.store.restore();
                },
              ),
            // Anonymous statistics: shown only in a build that can send.
            // Off wipes the queue at once.
            if (Telemetry.isConfigured) const _StatsTile(),
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

class _StatsTile extends StatefulWidget {
  const _StatsTile();

  @override
  State<_StatsTile> createState() => _StatsTileState();
}

class _StatsTileState extends State<_StatsTile> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SwitchListTile(
      title: Text(l10n.settingsStats),
      subtitle: Text(l10n.settingsStatsHint),
      value: Telemetry.isEnabled,
      onChanged: (v) async {
        await Telemetry.setEnabled(v);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
}
