import 'package:flutter/material.dart';
import 'package:vpn_basic_project/main.dart';

class HomeCard extends StatelessWidget {
  final String title, subTitle;
  final Widget icon;
  const HomeCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width * .45,
      child: Column(
        children: [
          //icon
          icon,
          //adding some space
          const SizedBox(
            height: 6,
          ),
          //text title
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          //for adding some space
          const SizedBox(
            height: 6,
          ),
          //text subtitle
          Text(
            subTitle,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).lightText),
          )
        ],
      ),
    );
  }
}
