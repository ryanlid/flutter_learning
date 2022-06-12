import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

import 'components/Dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription _stepCountSubscription;
  int stepCount = 0;

  @override
  void initState() {
    super.initState();
    initPedometer();
  }

  void onStepCount(StepCount event) {
    setState(() {
      stepCount = event.steps;
    });
    debugPrint('StepCount = ${event.steps}');
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      stepCount = 0;
    });
  }

  void initPedometer() {
    var stepCountStream = Pedometer.stepCountStream;
    // _stepCountSubscription =
    stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Dashboard([
              DashBoardItem('步数', stepCount.toString()),
              DashBoardItem('公里', "待开发"),
              DashBoardItem('千卡', "待开发"),
            ]),
          )
        ],
      ),
    );
  }
}
