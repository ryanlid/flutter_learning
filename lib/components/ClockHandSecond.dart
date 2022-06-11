import 'dart:math';

import 'package:flutter/material.dart';

class ClockHandSecond extends StatelessWidget {
  final Size clockSize;
  final int second;

  const ClockHandSecond(this.clockSize, this.second, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var beginAngle = 2 * pi / 60 * (second - 1);
    var endAngle = 2 * pi / 60 * second;
    return TweenAnimationBuilder<double>(
        key: const ValueKey('normal'),
        duration: const Duration(microseconds: 300),
        curve: Curves.easeInQuint,
        tween: Tween<double>(begin: beginAngle, end: endAngle),
        builder: (context, anim, child) {
          return Transform.rotate(
            angle: anim,
            child: CustomPaint(
              size: clockSize,
              painter: SecondHandPainter(),
            ),
          );
        });
  }
}

class SecondHandPainter extends CustomPainter {
  static const HAND_WIDTH = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    var handPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = HAND_WIDTH;

    var handStart = Offset(size.width * 0.5, size.height * 0.65);
    var handEnd = Offset(size.width * 0.5, size.height * 0.1);
    canvas.drawLine(handStart, handEnd, handPaint);

    var circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    var center = Offset(size.width * 0.5, size.height * 0.65);
    canvas.drawCircle(center, 6.0, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
