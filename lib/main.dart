import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:latlong2/latlong.dart';

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
  // 步数
  int stepCount = 0;

  // 当前位置
  late Position? position;
  late LocationPermission permission;

  // 定位参数设置
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  //  历史位置信息
  List<Position> historyPositions = [];

  @override
  void initState() {
    super.initState();
    initPedometer();
    initLocation();
  }

  void updateLocation(Position? newPosition) {
    print('当前定位 ${newPosition}');
    setState(() {
      position = newPosition ?? null;
      if (newPosition != null) {
        historyPositions.add(newPosition);
      }
    });
  }

  // 获取最近一次定位坐标，以及订阅位置更新
  Future<Position?> initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // return await Geolocator.getLastKnownPosition();
    // 获取 最近一次定位坐标
    Position? position = await Geolocator.getLastKnownPosition();
    updateLocation(position);

    // 订阅位置更新
    // subscribePosition();
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen(updateLocation);
    return null;
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
    stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  Widget getMap() {
    if (position == null) return Container();
    return FlutterMap(
      options: MapOptions(
        center: LatLng(position!.latitude, position!.longitude),
        zoom: 16,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: [
          Marker(
            width: 20,
            height: 20,
            point: LatLng(
              position!.latitude,
              position!.longitude,
            ),
            builder: (ctx) => Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          )
        ]),
        PolylineLayerOptions(
          polylines: [
            Polyline(
              points: historyPositions
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
              borderColor: Colors.red,
              color: Colors.red,
              borderStrokeWidth: 4,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: getMap(),
          ),
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
