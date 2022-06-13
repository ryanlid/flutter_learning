import 'dart:io';
import 'dart:developer';

import 'dart:convert';

class Message {
  static const String TYPE_USER = "user";
  static const String TYPE_SYSTEM = "system";
  static const String TYPE_ME = "me";
  final String from;
  final String msg;
  final String meme;

  Message(this.from, this.msg, this.meme);

  Message.fromJson(Map<String, dynamic> json)
      : from = json["type"],
        msg = json['msg'],
        meme = json['meme'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'type': from, "msg": msg, 'meme': meme};
}


// Message msg = Message('me', 'Hello', '');

// print(jsonEncode(msg));
//
// String jsonStr = '{"type":"me","msg":"Hello","meme":""}';
//
// Map<String,dynamic> msgMap = jsonDecode(jsonStr);
//
// Message msg = Message.fromJson(msgMap);
//
// // main(){
// //   print(msg);
//   print(msg.msg);
// }

