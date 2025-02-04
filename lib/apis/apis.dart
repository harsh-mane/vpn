import 'dart:convert';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_basic_project/helpers/my_dialogues.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/vpn.dart';

class APIs {
  // Static function to fetch VPN servers
  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];
    try {
      final res =
          await http.get(Uri.parse('https://www.vpngate.net/api/iphone/'));

      if (res.statusCode == 200) {
        // Split the response to extract the CSV part
        final csvString = res.body.split("#")[1];

        // Convert CSV string to list
        List<List<dynamic>> list =
            const CsvToListConverter().convert(csvString);

        // Extract the header (first row)
        final header = list[0];

        // Parse the data rows
        for (int i = 1; i < list.length; ++i) {
          Map<String, dynamic> tempJson = {};

          for (int j = 0; j < header.length; ++j) {
            tempJson[header[j].toString()] = list[i][j];
          }

          // Add the VPN object to the list
          vpnList.add(Vpn.fromJson(tempJson));
        }
      } else {
        log('HTTP error: ${res.statusCode}');
      }
    } catch (e) {
       MyDialogues.error(msg: e.toString());
      log('getVpnserversE: $e');
    }

    // Shuffle the list before returning
    vpnList.shuffle();
    if (vpnList.isNotEmpty) Pref.vpnList = vpnList;

    return vpnList;
  }

  // Static function to fetch VPN servers
  static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
    try {
      final res = await http.get(Uri.parse('http://ip-api.com/json/24.48.0.1'));
      final data = jsonDecode(res.body);
      ipData.value = IPDetails.fromJson(data);
    } catch (e) {
      MyDialogues.error(msg: e.toString());
      log('\ngetIPDetailsE: $e');
    }
  }
}
