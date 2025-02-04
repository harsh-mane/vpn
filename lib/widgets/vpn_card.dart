import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helpers/my_dialogues.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

class VpnCard extends StatelessWidget {
  final Vpn vpn;
  const VpnCard({super.key, required this.vpn});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          controller.vpn.value = vpn;
          Pref.vpn = vpn; // It will be storing VPN data for us
          Get.back();
           MyDialogues.success(msg: ('Connecting VPN Location...'));

          if (controller.vpnState == VpnEngine.vpnConnected) {
            VpnEngine.stopVpn();
            Future.delayed(
                const Duration(seconds: 2), () => controller.connectToVpn());
          } else {
            controller.connectToVpn();
          }
        },
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

          leading: Container(
              padding: const EdgeInsets.all(.5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(6)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/flags/${vpn.CountryShort.toLowerCase()}.png',
                    height: 40,
                    width: mq.width * .15,
                    fit: BoxFit.cover,
                  ))),

          //title
          title: Text(vpn.CountryLong),
          //subtitle
          subtitle: Row(
            children: [
              const Icon(
                Icons.speed,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                _formatBytes(vpn.Speed, 1),
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),

          //trailing (Ending part)
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpn.NumVpnSessions.toString(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).lightText),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(
                CupertinoIcons.person_3,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ['Bps', 'Kbps', 'Mbps', 'Gbps', 'Tbps'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
