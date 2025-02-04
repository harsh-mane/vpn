import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Network Test Screen',
      )),
      //Refresh Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            ipData.value = IPDetails.fromJson({});
            APIs.getIPDetails(ipData: ipData);
          },
          child: const Icon(CupertinoIcons.refresh_circled),
        ),
      ),
      body: Obx(
        () => ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              left: mq.width * .04,
              right: mq.width * .04,
              top: mq.height * .01,
              bottom: mq.height * .1),
          children: [
            //Internet Provider(IP)
            NetworkCard(
                data: NetworkData(
                    title: 'IP Address',
                    subtitle: ipData.value.query,
                    icon: const Icon(
                      Icons.wifi_sharp,
                      color: Colors.orange,
                    ))),

            //Internet Service Provider(ISP)
            NetworkCard(
                data: NetworkData(
                    title: 'Internet Provider',
                    subtitle: ipData.value.isp,
                    icon: const Icon(
                      Icons.router_outlined,
                      color: Colors.pink,
                    ))),

            //Location
            NetworkCard(
                data: NetworkData(
                    title: 'Location',
                    subtitle: ipData.value.country.isEmpty
                        ? 'Fetching...'
                        : '${ipData.value.city}, ${ipData.value.regionName},${ipData.value.country}',
                    icon: const Icon(
                      Icons.location_history,
                      color: Colors.blue,
                    ))),

            //Pin Code
            NetworkCard(
                data: NetworkData(
                    title: 'Pin Code',
                    subtitle: ipData.value.zip,
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ))),

            //timeZone
            NetworkCard(
                data: NetworkData(
                    title: 'TimeZone',
                    subtitle: ipData.value.timezone,
                    icon: const Icon(
                      Icons.access_time_outlined,
                      color: Colors.green,
                    ))),
          ],
        ),
      ),
    );
  }
}
