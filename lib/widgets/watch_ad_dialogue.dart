import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchAdDialogue extends StatelessWidget {
  final VoidCallback onComplete;
  const WatchAdDialogue({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Change theme '),
      content: const Text('Watch an Add to change app theme'),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            textStyle: const TextStyle(color: Colors.green),
            child: const Text('Watch Ad'),
            onPressed: () {
              Get.back();
              onComplete();
            })
      ],
    );
  }
}
