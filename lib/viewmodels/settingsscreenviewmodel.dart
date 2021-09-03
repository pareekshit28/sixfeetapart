import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreenViewModel extends ChangeNotifier {
  List<String>? whiteList;

  void getWhiteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList("whitelist");
    if (list == null) {
      whiteList = [];
    } else {
      whiteList = list;
    }
    notifyListeners();
  }

  Future<bool> removeFromWhiteList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList("whitelist");

    if (list != null) {
      if (list.length == 0) {
        return true;
      } else {
        var res = list.remove(id);
        if (res) {
          prefs.setStringList("whitelist", list);
        }
        return true;
      }
    } else {
      return true;
    }
  }
}
