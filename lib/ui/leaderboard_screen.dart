import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_services.dart';
import '../services/leaderboard/leaderboard_repository.dart';
import '../l10n/l10n.dart';
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
            appBar: AppBar(title: Text(context.l10n.menuLeaderboard)),
            body: local,
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.menuLeaderboard),
              bottom: TabBar(
                tabs: [
                  Tab(text: context.l10n.leaderboardThisPhone),
                  Tab(text: context.l10n.leaderboardOnline),
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
          return Center(child: Text(context.l10n.leaderboardEmpty));
        }
        final l10n = context.l10n;
        final dates = DateFormat.yMd(Localizations.localeOf(context).toString());
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: entries.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final e = entries[i];
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
              subtitle: Text(
                l10n.leaderboardEntry(dates.format(e.date.toLocal()), l10n.percent((e.accuracy * 100).round())),
              ),
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
              services.online.available ? context.l10n.leaderboardOnlineInfo : context.l10n.leaderboardSignInInfo,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: services.online.show,
              child: Text(services.online.available ? context.l10n.leaderboardOpen : context.l10n.leaderboardSignIn),
            ),
          ],
        ),
      ),
    );
  }
}
