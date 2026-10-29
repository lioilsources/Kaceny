import 'package:flutter/material.dart';

import '../app_services.dart';
import '../services/leaderboard/leaderboard_repository.dart';
import 'theme.dart';

/// Local top 20, plus an Online tab while signed in to Game Center / Play
/// Games (§5, §6).
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key, required this.services, this.highlightRank});

  final AppServices services;

  /// Row to highlight, e.g. the entry just added.
  final int? highlightRank;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: services.online,
      builder: (context, _) {
        final online = services.online.offered;
        final local = _LocalList(services: services, highlightRank: highlightRank);
        if (!online) {
          return Scaffold(
            appBar: AppBar(title: const Text('Žebříček')),
            body: local,
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Žebříček'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Tento telefon'),
                  Tab(text: 'Online'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                local,
                _OnlineTab(services: services),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LocalList extends StatelessWidget {
  const _LocalList({required this.services, this.highlightRank});

  final AppServices services;
  final int? highlightRank;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeaderboardEntry>>(
      future: services.leaderboard.top(),
      builder: (context, snapshot) {
        final entries = snapshot.data;
        if (entries == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (entries.isEmpty) {
          return const Center(child: Text('Zatím žádné skóre. Jdi střílet!'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: entries.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final e = entries[i];
            final d = e.date.toLocal();
            return ListTile(
              tileColor: i == highlightRank ? KColors.orange.withValues(alpha: 0.18) : null,
              leading: SizedBox(
                width: 36,
                child: Text(
                  '${i + 1}.',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              title: Text(
                e.initials,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 2),
              ),
              subtitle: Text('${d.day}. ${d.month}. ${d.year} · přesnost ${(e.accuracy * 100).round()} %'),
              trailing: Text('${e.score}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            );
          },
        );
      },
    );
  }
}

class _OnlineTab extends StatelessWidget {
  const _OnlineTab({required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: KColors.orange),
            const SizedBox(height: 16),
            Text(
              services.online.available
                  ? 'Výsledky všech hráčů v Game Center / Play Games.'
                  : 'Přihlas se a porovnej se s ostatními.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: services.online.show,
              child: Text(services.online.available ? 'Otevřít' : 'Přihlásit'),
            ),
          ],
        ),
      ),
    );
  }
}
