import 'package:flutter/material.dart';

class TGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(painter: CurvePainter(),),
    );
  }
}

class CurvePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(-45, -140),
      Offset(-45, 140),
      paint,
    );
    canvas.drawLine(
      Offset(49, -140),
      Offset(49, 140),
      paint,
    );
    canvas.drawLine(
      //Axis.horizontal;
      Offset(-140, -48),
      Offset(140, -48),
      paint,
    );
    canvas.drawLine(
      Offset(-140, 48),
      Offset(140, 48),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}