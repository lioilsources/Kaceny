// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get menuTagline => '90 segundos. 8 cartuchos. Muitos patos.';

  @override
  String get menuPlay => 'JOGAR';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Ranking';

  @override
  String get menuSettings => 'Configurações';

  @override
  String get menuOnlineLeaderboard => 'Ranking online';

  @override
  String get signIn => 'Entrar';

  @override
  String get pause => 'Pausa';

  @override
  String get pauseResume => 'Continuar';

  @override
  String get pauseRestart => 'Recomeçar';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'recarregando…';

  @override
  String get hudReloadHint => 'deslize para baixo ou toque aqui';

  @override
  String get settingsSound => 'Som';

  @override
  String get settingsHaptics => 'Vibração';

  @override
  String get settingsAutoReload => 'Recarga automática';

  @override
  String get settingsAutoReloadHint =>
      'Senão, recarregue deslizando para baixo ou tocando nos cartuchos.';

  @override
  String get settingsDebug => 'Debug: hitboxes e tiros';

  @override
  String get settingsDebugHint => 'Só na build de debug.';

  @override
  String get settingsRestore => 'Restaurar compras';

  @override
  String get leaderboardThisPhone => 'Este celular';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Nenhuma pontuação ainda. Vá caçar uns patos!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precisão $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Pontuações de todos os jogadores no Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Entre e compare-se com os outros.';

  @override
  String get leaderboardOpen => 'Abrir';

  @override
  String get leaderboardSignIn => 'Entrar';

  @override
  String get gameOverTitle => 'Fim da rodada';

  @override
  String get gameOverNewRecord => 'NOVO RECORDE!';

  @override
  String get gameOverInitials => 'Você entrou no ranking! Suas iniciais:';

  @override
  String get gameOverReplay => 'De novo';

  @override
  String get statBest => 'melhor';

  @override
  String get statAccuracy => 'precisão';

  @override
  String get statStreak => 'sequência';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'grátis';

  @override
  String get skinsOwned => 'sua';

  @override
  String get skinsAnimated => 'bate asas';

  @override
  String skinsUnlock(String price) {
    return 'Desbloquear por $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Desbloquear';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, cada uma com um pato e seu próprio fundo. Suas para sempre, em todos os seus aparelhos.',
      one:
          '$count skin: um pato com seu próprio fundo. Sua para sempre, em todos os seus aparelhos.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'A loja não está disponível agora. Tente de novo mais tarde.';

  @override
  String get skinsRestore => 'Restaurar compras';

  @override
  String get skinsRestoreDone => 'Compras restauradas.';

  @override
  String get skinsThanks => 'Valeu! O pacote é seu.';

  @override
  String get skinsAllTitle => 'Todos os pacotes';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skins de todos os $packs pacotes de uma vez, por mais ou menos metade do preço. Suas para sempre, em todos os seus aparelhos.';
  }
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get menuTagline => '90 segundos. 8 cartuchos. Muitos patos.';

  @override
  String get menuPlay => 'JOGAR';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Classificação';

  @override
  String get menuSettings => 'Definições';

  @override
  String get menuOnlineLeaderboard => 'Classificação online';

  @override
  String get signIn => 'Iniciar sessão';

  @override
  String get pause => 'Pausa';

  @override
  String get pauseResume => 'Continuar';

  @override
  String get pauseRestart => 'Recomeçar';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'a recarregar…';

  @override
  String get hudReloadHint => 'desliza para baixo ou toca aqui';

  @override
  String get settingsSound => 'Som';

  @override
  String get settingsHaptics => 'Vibração';

  @override
  String get settingsAutoReload => 'Recarregar automaticamente';

  @override
  String get settingsAutoReloadHint =>
      'Caso contrário, recarrega a deslizar para baixo ou a tocar nos cartuchos.';

  @override
  String get settingsDebug => 'Debug: hitboxes e tiros';

  @override
  String get settingsDebugHint => 'Só na versão de debug.';

  @override
  String get settingsRestore => 'Restaurar compras';

  @override
  String get leaderboardThisPhone => 'Este telemóvel';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Ainda sem pontuações. Vai caçar uns patos!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precisão $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Pontuações de todos os jogadores no Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Inicia sessão e compara-te com os outros.';

  @override
  String get leaderboardOpen => 'Abrir';

  @override
  String get leaderboardSignIn => 'Iniciar sessão';

  @override
  String get gameOverTitle => 'Fim da ronda';

  @override
  String get gameOverNewRecord => 'NOVO RECORDE!';

  @override
  String get gameOverInitials => 'Entraste na classificação! As tuas iniciais:';

  @override
  String get gameOverReplay => 'Outra vez';

  @override
  String get statBest => 'melhor';

  @override
  String get statAccuracy => 'precisão';

  @override
  String get statStreak => 'sequência';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'grátis';

  @override
  String get skinsOwned => 'tua';

  @override
  String get skinsAnimated => 'bate asas';

  @override
  String skinsUnlock(String price) {
    return 'Desbloquear por $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Desbloquear';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, cada uma com um pato e o seu próprio fundo. Tuas para sempre, em todos os teus dispositivos.',
      one:
          '$count skin: um pato com o seu próprio fundo. Tua para sempre, em todos os teus dispositivos.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'A loja não está disponível neste momento. Tenta mais tarde.';

  @override
  String get skinsRestore => 'Restaurar compras';

  @override
  String get skinsRestoreDone => 'Compras restauradas.';

  @override
  String get skinsThanks => 'Obrigado! O pacote é teu.';

  @override
  String get skinsAllTitle => 'Todos os pacotes';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skins de todos os $packs pacotes de uma vez, por cerca de metade do preço. Tuas para sempre, em todos os teus dispositivos.';
  }
}
