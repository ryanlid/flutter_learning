import 'dart:async';

import 'package:flutter/material.dart';
import 'components/ClockHand.dart';
import 'components/ClockHandSecond.dart';
import 'components/ClockCenter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '拟物时钟',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final clockSize = Size(screenWidth * 0.9, screenWidth * 0.9);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClockPanel(clockSize),
            ClockHand(
              clockSize,
              ClockHandType.hour,
              now.hour,
              now.minute,
              now.second,
            ),
            ClockHand(
              clockSize,
              ClockHandType.minute,
              now.hour,
              now.minute,
              now.second,
            ),
            ClockHandSecond(
              clockSize,
              now.second,
            ),
            const ClockCenter(),
          ],
        ),
      ),
    );
  }
}

class ClockScalePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint scalePaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.12),
      Offset(size.width * 0.5, size.height * 0.06),
      scalePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.94),
      Offset(size.width * 0.5, size.height * 0.88),
      scalePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.5),
      Offset(size.width * 0.12, size.height * 0.5),
      scalePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, size.height * 0.5),
      Offset(size.width * 0.94, size.height * 0.5),
      scalePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClockPanel extends StatelessWidget {
  final Size size;

  const ClockPanel(this.size, {Key? key}) : super(key: key);

  // 外表盘
  Widget getOuterPanel() {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5.0, -5.0),
            blurRadius: 15.0,
          ),
          BoxShadow(
            color: (Colors.grey[400])!,
            offset: const Offset(5.0, 5.0),
            blurRadius: 15.0,
          )
        ],
      ),
    );
  }

  // 内表盘
  Widget getInnerPanel() {
    return Stack(
      children: [
        Container(
          height: size.height * 0.9,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.grey[400]!,
              ],
              center: AlignmentDirectional(0.1, 0.1),
              focal: AlignmentDirectional(0.0, 0.0),
              radius: 0.65,
              focalRadius: 0.001,
              stops: const [0.3, 1.0],
            ),
          ),
        ),
        Container(
          height: size.height * 0.9,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white,
              ],
              center: AlignmentDirectional(-0.1, -0.1),
              focal: AlignmentDirectional(0.0, 0.0),
              radius: 0.67,
              focalRadius: 0.001,
              stops: [0.75, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget getScale() {
    return CustomPaint(
      size: size,
      painter: ClockScalePainter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 外表盘
        getOuterPanel(),
        // 内表盘
        getInnerPanel(),
        // 表盘刻度
        getScale(),
      ],
    );
  }
}
