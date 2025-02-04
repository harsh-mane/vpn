import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn_basic_project/models/vpn.dart';

class Pref {
  //creating global object for box
  static late Box _box;

  //to initialize hive creating function
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    //this will enable hive for us

    //creating object for box (hive stores data in boxes)
    _box = await Hive.openBox('data');
  }

//for storing themedata
  static bool get isDarkMode => _box.get('isDarkMode') ?? false;
  static set isDarkMode(bool v) => _box.put('isDarkMode', v);
//store VPN data for us as well as access the vpn data
  static Vpn get vpn => Vpn.fromJson(jsonDecode(_box.get('vpn') ?? '{}'));
  static set vpn(Vpn v) => _box.put('vpn', jsonEncode(v));

  //for storing vpn server details
  static List<Vpn> get vpnList {
    List<Vpn> temp = [];
    final data = jsonDecode(_box.get('vpnList') ?? '[]');
    for (var i in data) temp.add(Vpn.fromJson(i));
    return temp;
  }

  static set vpnList(List<Vpn> v) => _box.put('vpnList', jsonEncode(v));
}
