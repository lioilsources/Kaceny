import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_services.dart';
import '../game/kaceny_game.dart';
import '../services/leaderboard/leaderboard_repository.dart';
import 'theme.dart';

/// End of a round (§4.4): score, best, accuracy; initials if it made the
/// local top 20; Replay / Leaderboard / Menu.
class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({
    super.key,
    required this.result,
    required this.services,
    required this.onReplay,
    required this.onLeaderboard,
    required this.onMenu,
  });

  final RoundResult result;
  final AppServices services;
  final VoidCallback onReplay;
  final void Function(int? rank) onLeaderboard;
  final VoidCallback onMenu;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  late final TextEditingController _initials = TextEditingController(text: widget.services.settings.initials);

  bool _loading = true;
  bool _qualifies = false;
  int _previousBest = 0;

  /// Set once the entry is stored, so leaving never stores it twice.
  Future<int?>? _saved;

  RoundResult get result => widget.result;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final board = widget.services.leaderboard;
    final top = await board.top();
    final qualifies = await board.qualifies(result.score);
    if (!mounted) {
      return;
    }
    setState(() {
      _previousBest = top.isEmpty ? 0 : top.first.score;
      _qualifies = qualifies;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _initials.dispose();
    super.dispose();
  }

  /// Stores the round if it qualifies, with whatever initials are typed.
  Future<int?> _save() {
    if (!_qualifies) {
      return Future.value();
    }
    return _saved ??= () {
      var initials = _initials.text.trim().toUpperCase();
      if (initials.isEmpty) {
        initials = '???';
      } else {
        widget.services.settings.initials = initials;
      }
      return widget.services.leaderboard.add(
        LeaderboardEntry(initials: initials, score: result.score, date: DateTime.now(), accuracy: result.accuracy),
      );
    }();
  }

  Future<void> _leave(VoidCallback then) async {
    FocusScope.of(context).unfocus();
    await _save();
    then();
  }

  @override
  Widget build(BuildContext context) {
    final record = !_loading && result.score > _previousBest && result.score > 0;
    return ColoredBox(
      color: KColors.scrim,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Konec kola', style: hudText.copyWith(fontSize: 28)),
                const SizedBox(height: 8),
                Text('${result.score}', style: hudText.copyWith(fontSize: 76, height: 1)),
                if (record)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: KColors.orange, borderRadius: BorderRadius.circular(12)),
                    child: Text('NOVÝ REKORD!', style: hudText.copyWith(fontSize: 16)),
                  ),
                const SizedBox(height: 16),
                _Stats(result: result, best: record ? result.score : _previousBest),
                if (_qualifies) ...[
                  const SizedBox(height: 20),
                  Text('Do žebříčku! Tvoje iniciály:', style: hudText.copyWith(fontSize: 16)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: _initials,
                      enabled: _saved == null,
                      maxLength: 3,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9ÁČĎÉĚÍŇÓŘŠŤÚŮÝŽáčďéěíňóřšťúůýž]')),
                      ],
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 6),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: KColors.cream,
                        hintText: 'ABC',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onSubmitted: (_) => setState(() => _save()),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(onPressed: () => _leave(widget.onReplay), child: const Text('Znovu')),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SmallButton(
                      label: 'Žebříček',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final rank = await _save();
                        if (mounted) {
                          setState(() {});
                        }
                        widget.onLeaderboard(rank);
                      },
                    ),
                    const SizedBox(width: 12),
                    _SmallButton(label: 'Menu', onPressed: () => _leave(widget.onMenu)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.result, required this.best});

  final RoundResult result;
  final int best;

  @override
  Widget build(BuildContext context) {
    Widget stat(String label, String value) => Expanded(
      child: Column(
        children: [
          Text(value, style: hudText.copyWith(fontSize: 24)),
          Text(
            label,
            style: hudText.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
        ],
      ),
    );
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          stat('nejlepší', '$best'),
          stat('přesnost', '${(result.accuracy * 100).round()} %'),
          stat('série', '${result.bestStreak}'),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size(130, 50),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
