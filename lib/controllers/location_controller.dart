import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/models/vpn.dart';

class LocationController extends GetxController {
  //creating some variables for storing data
  List<Vpn> vpnList = Pref.vpnList;

  final RxBool isLoading =
      false.obs; //this will tell us loading is in progress or not

  Future<void> getVpnData() async {
    isLoading.value = true;
    vpnList.clear();
    vpnList = await APIs.getVPNServers();
    isLoading.value = false;
  }
}
