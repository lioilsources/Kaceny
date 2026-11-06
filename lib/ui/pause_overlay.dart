import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'theme.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.onResume, required this.onRestart, required this.onMenu});

  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: KColors.scrim,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.pause, style: hudText.copyWith(fontSize: 44)),
            const SizedBox(height: 28),
            FilledButton(onPressed: onResume, child: Text(context.l10n.pauseResume)),
            const SizedBox(height: 12),
            _LightOutlined(onPressed: onRestart, label: context.l10n.pauseRestart),
            const SizedBox(height: 12),
            _LightOutlined(onPressed: onMenu, label: context.l10n.backToMenu),
          ],
        ),
      ),
    );
  }
}

class _LightOutlined extends StatelessWidget {
  const _LightOutlined({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
