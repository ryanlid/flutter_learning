import 'package:flutter/material.dart';
import '../model/Message.dart';

class ChatPage extends StatefulWidget {
  final List<Message> _message;
  final Function(String msgText, String meme) _sendMsg;

  const ChatPage(this._message, this._sendMsg, {Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _msgController;

  @override
  void initState() {
    super.initState();
    _msgController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _msgController.dispose();
  }

  Widget getListView() {
    return ListView.builder(
      reverse: true,
      itemBuilder: (_, int index) {
        Message msg = widget._message[index];
        print('msg${msg.msg}');
        return MessageComponent(msg);
      },
      itemCount: widget._message.length,
    );
  }

  Widget getInputPanel() {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 4, 0, 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  autofocus: true,
                  controller: _msgController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.face),
                iconSize: 32,
                color: Colors.grey[600],
                onPressed: () => null,
              ),
              SizedBox(width: 12, height: 0),
              IconButton(
                icon: Icon(Icons.send),
                iconSize: 32,
                color: Colors.grey[600],
                onPressed: () {
                  print('12121${_msgController.text}');
                  widget._sendMsg(_msgController.text, "");
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: getListView(),
              ),
            ),
            getInputPanel()
          ],
        ),
      ),
    );
  }
}

class MessageComponent extends StatelessWidget {
  final Message _msg;

  const MessageComponent(this._msg, {Key? key}) : super(key: key);

  Widget showMessage() {
    print('_msg${_msg}');
    return Text(_msg.msg);
  }

  Widget containerOpposite(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: showMessage(),
        )
      ],
    );
  }

  Widget containerMe(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_msg.from == Message.TYPE_ME) {
      return containerMe(context);
    } else {
      return containerOpposite(context);
    }
  }
}
