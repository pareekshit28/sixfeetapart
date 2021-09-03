import 'package:flutter/material.dart';

class Scanning extends StatelessWidget {
  const Scanning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.bluetooth,
          color: Colors.grey,
          size: 100,
        ),
        Text(
          "Scanning...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        )
      ],
    );
  }
}
