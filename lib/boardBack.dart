import 'package:flutter/material.dart';


class BoardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 340.0,
        height: 340.0,
        //alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          boxShadow: [BoxShadow(blurRadius: 5.0)],
        ),
      );
  }
}