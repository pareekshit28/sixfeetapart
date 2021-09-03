import 'package:flutter/material.dart';

class Near extends StatelessWidget {
  const Near({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.clear,
          color: Colors.red,
          size: 100,
        ),
        Text(
          "You are at Risk\n Please Keep Distance ⚠️",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.red),
        )
      ],
    );
  }
}
