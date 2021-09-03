import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenViewModel extends ChangeNotifier {
  List<ScanResult>? list;

  void getDevicesList(List<ScanResult> fullList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ScanResult> res = [];
    List<String>? whiteList = prefs.getStringList("whitelist");

    if (whiteList == null) {
      whiteList = [];
    }

    for (ScanResult r in fullList) {
      if (true) {
        if (!whiteList.contains(r.device.id.id)) {
          res.add(r);
        }
      }
    }

    list = res;
    notifyListeners();
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
}
