// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get menuTagline => '90 giây. 8 viên đạn. Cả đàn vịt.';

  @override
  String get menuPlay => 'CHƠI';

  @override
  String get menuSkins => 'Giao diện';

  @override
  String get menuLeaderboard => 'Bảng xếp hạng';

  @override
  String get menuSettings => 'Cài đặt';

  @override
  String get menuOnlineLeaderboard => 'Bảng xếp hạng trực tuyến';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get pauseResume => 'Tiếp tục';

  @override
  String get pauseRestart => 'Chơi lại từ đầu';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'đang nạp đạn…';

  @override
  String get hudReloadHint => 'vuốt xuống hoặc chạm vào đây';

  @override
  String get settingsSound => 'Âm thanh';

  @override
  String get settingsHaptics => 'Rung';

  @override
  String get settingsAutoReload => 'Tự động nạp đạn';

  @override
  String get settingsAutoReloadHint =>
      'Nếu không, hãy nạp đạn bằng cách vuốt xuống hoặc chạm vào băng đạn.';

  @override
  String get settingsDebug => 'Gỡ lỗi: vùng trúng và phát bắn';

  @override
  String get settingsDebugHint => 'Chỉ có trong bản gỡ lỗi.';

  @override
  String get settingsRestore => 'Khôi phục giao dịch mua';

  @override
  String get leaderboardThisPhone => 'Điện thoại này';

  @override
  String get leaderboardOnline => 'Trực tuyến';

  @override
  String get leaderboardEmpty => 'Chưa có điểm nào. Đi bắn vịt thôi!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · độ chính xác $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Điểm của mọi người chơi trên Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Đăng nhập và so tài với người khác.';

  @override
  String get leaderboardOpen => 'Mở';

  @override
  String get leaderboardSignIn => 'Đăng nhập';

  @override
  String get gameOverTitle => 'Hết vòng';

  @override
  String get gameOverNewRecord => 'KỶ LỤC MỚI!';

  @override
  String get gameOverInitials =>
      'Bạn đã lọt bảng xếp hạng! Tên viết tắt của bạn:';

  @override
  String get gameOverReplay => 'Chơi lại';

  @override
  String get statBest => 'cao nhất';

  @override
  String get statAccuracy => 'chính xác';

  @override
  String get statStreak => 'chuỗi';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Giao diện ($count)';
  }

  @override
  String get skinsFree => 'miễn phí';

  @override
  String get skinsOwned => 'của bạn';

  @override
  String get skinsAnimated => 'vỗ cánh';

  @override
  String skinsUnlock(String price) {
    return 'Mở khóa với giá $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Mở khóa';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count giao diện, mỗi cái là một chú vịt với nền riêng. Của bạn mãi mãi, trên mọi thiết bị.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Cửa hàng hiện không khả dụng. Hãy thử lại sau.';

  @override
  String get skinsRestore => 'Khôi phục giao dịch mua';

  @override
  String get skinsRestoreDone => 'Đã khôi phục giao dịch mua.';

  @override
  String get skinsThanks => 'Cảm ơn bạn! Gói này là của bạn.';

  @override
  String get skinsAllTitle => 'Tất cả các gói';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins giao diện từ cả $packs gói cùng lúc, với khoảng nửa giá. Của bạn mãi mãi, trên mọi thiết bị.';
  }
}
