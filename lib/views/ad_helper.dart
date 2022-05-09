import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-54646546/68464646';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-54646546/68464646';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-651651616/ddc9978021749';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-651651616/ddc9978021749';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }
}