import 'dart:io';

class AdmobService {
  static String getAdmobId({bool isTesting = false}) {
    if (Platform.isIOS) {
      //TODO: Configurar id para ios
      return "";
    } else if (Platform.isAndroid) {
      if (isTesting) {
        return "ca-app-pub-3940256099942544~3347511713";
      }
      return 'ca-app-pub-4665787383933447~5752148925';
    }
    return '';
  }

  static String videoId({bool isTesting = false}) {
    if (Platform.isIOS) {
      //TODO: Configurar id para ios
      return "";
    } else if (Platform.isAndroid) {
      if (isTesting) {
        return "ca-app-pub-3940256099942544/1033173712";
      }
      return 'ca-app-pub-4665787383933447/5717146443';
    }
    return '';
  }
}
