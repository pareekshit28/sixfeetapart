import 'package:flutter/material.dart';

class Far extends StatelessWidget {
  const Far({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.done,
          color: Colors.green,
          size: 100,
        ),
        Text(
          "You are at a safe distance\nWell Done 👏",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.green),
        )
      ],
    );
  }
}
