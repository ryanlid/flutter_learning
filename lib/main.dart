import 'dart:io';

import 'package:flutter/material.dart';
import 'model/Message.dart';
import 'net/Socket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BaseSocketCS _socketCS;
  final List<Message> _message = [];

  void createServer(int port) {
    _socketCS = SocketServer(port);
    initSocketCS();
  }

  void createClient(String address ,int port) {
    _socketCS = SocketClient(address,port);
    initSocketCS();
  }

  void initSocketCS() {
    _socketCS.init();
    _socketCS.msgStream.stream.listen((msg) {
      debugPrint(msg.toJson().toString());
      setState(() {
        _message.insert(0, msg);
      });
    });
  }

  void onSendMessage(String msgText, String meme) {
    var msgToUser = Message(Message.TYPE_USER, msgText, meme);
    var msgToMe = Message(Message.TYPE_ME, msgText, meme);
    _socketCS.send(msgToUser);
    setState(() {
      _message.insert(0, msgToMe);
    });
  }

  void goToChatPage(BuildContext childContext) {}

  @override
  void dispose() {
    super.dispose();
    _socketCS.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket IM',
      home: SettingHomePage(
        createServer,
        createClient,
        goToChatPage,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Flutter'),
      ),
    );
  }
}

class SettingHomePage extends StatefulWidget {
  Function (int port) _createServerCallback;
  Function(String address, int port) _createClientCallback;
  Function(BuildContext childContext) _goToChatPage;

  SettingHomePage(this._createServerCallback, this._createClientCallback,
      this._goToChatPage, {Key? key}) : super(key: key)

  @override
  State<SettingHomePage> createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  String ipAddress = "";

  final _serverPortController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _clientPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIpAddress();
  }

  @override
  void dispose() {
    super.dispose();
    _serverPortController.dispose();
    _clientPortController.dispose();
    _clientPortController.dispose();
  }

  void getIpAddress() {
    NetworkInterface.list(
      // includeLoopback: false,
      type: InternetAddressType.any,
    ).then((List<NetworkInterface> interfaces) =>
    {
      setState(() {
        ipAddress = "";

        if (interfaces.length == 0) {
          ipAddress = "IP地址为空";
          return;
        }

        for (var interface in interfaces) {
          ipAddress += "${interface.name}\n";
          for (var address in interface.addresses) {
            ipAddress += "${address.address}\n";
          }
        }
      })
    });
  }

  Widget getServerConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Socket Server 模式运行",
          style: TextStyle(fontSize: 26),
        ),
        Row(
          children: [
            Text("端口号："),
            Expanded(
              child: TextField(
                controller: _serverPortController,
                keyboardType: TextInputType.number,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                widget._createServerCallback.call(
                    int.parse(_serverPortController.text));
                widget._goToChatPage(context);
              },
              child: Text("启动"),
            ),
          ],
        )
      ],
    );
  }

  Widget getClientConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Socket client 模式运行",
          style: TextStyle(fontSize: 26),
        ),
        Row(
          children: [
            Text("Server IP："),
            Expanded(
              child: TextField(
                controller: _serverPortController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text("Server 端口号："),
            Expanded(
                child: TextField(
                  controller: _clientPortController,
                  keyboardType: TextInputType.number,
                ))
          ],
        ),
        OutlinedButton(
          onPressed: () {
            widget._createClientCallback.call(_clientAddressController.text,
                int.parse(_clientPortController.text));
            widget._goToChatPage(context);
          },
          child: Text("启动"),
        ),
      ],
    );
  }

  Widget getDeviceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "本机IP 地址",
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        Text(ipAddress)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置首页"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            getDeviceInfo(),
            SizedBox(
              height: 12,
            ),
            getServerConfig(),
            SizedBox(
              height: 12,
            ),
            Text("需先在一台设备上启动 Server，再用另一台设备连接"),
            getClientConfig(),
          ],
        ),
      ),
    );
  }
}
