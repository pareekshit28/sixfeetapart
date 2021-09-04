import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenViewModel extends ChangeNotifier {
  List<ScanResult>? list;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool vibrate = false;

  void getDevicesList(bool refresh) async {
    vibrate = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ScanResult> res = [];
    List<String>? whiteList = prefs.getStringList("whitelist");

    if (whiteList == null) {
      whiteList = [];
    }

    if (!refresh) {
      flutterBlue.startScan(timeout: Duration(seconds: 10));
    }

    flutterBlue.scanResults.listen((event) {
      res.clear();
      for (ScanResult r in event) {
        if (r.rssi > -100) {
          if (!whiteList!.contains(r.device.id.id)) {
            res.add(r);
          }
        }
      }
      list = res;
      notifyListeners();
      if (res.length > 0) {
        vibrateNow();
      }
    });
  }

  void vibrateNow() {
    if (vibrate) {
      Future.delayed(Duration(seconds: 3), () async {
        if (await Vibrate.canVibrate) {
          Vibrate.feedback(FeedbackType.warning);
        }
      });
    }
    vibrate = false;
  }

  Future<bool> addToWhiteList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList("whitelist");

    if (list == null) {
      list = [];
    }

    list.add(id);

    var res = await prefs.setStringList("whitelist", list);
    return res;
  }

  void stopScan() {
    print("Scanning Stopped");
  }
}
