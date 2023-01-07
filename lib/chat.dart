import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:web_socket_channel/html.dart';
import 'package:ns_fw_room_login/url_conf.dart';
import 'vid_web_element.dart';
import 'state_user.dart';
import 'state_room.dart';
import 'package:ns_fw_room_login/gstyles.dart';


Map VC_msg ={
   "text":"initvcmsg txt",
  "sender": "initvcmsg sender"
};

class mState {
  static List? msgList;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, this.room}) : super(key: key);
  final ChatRoom? room;
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextStyle chat_text_main = TextStyle(color: Colors.white);
  Color send_color = Colors.black87;

  String? room_url;
  List? _roomMessages = [{"text":"test message 1", "sender":"test user 1"}];
  bool? sendSocketIsConnected;
  TextEditingController _chat_msg_ctl = new TextEditingController();

  User? cur_user;

  HtmlWebSocketChannel? ws_chan;

  initState() {
    // get user from state update
    UserState.stateStream.listen((e) {
      print("chat screen user state event ~ " + e.toString());
      setState(() {
        cur_user = e.name;
      });
    });

    print("state stream listen complete");
    ws_chan = HtmlWebSocketChannel.connect(test_room_url_connect);

      print("test room connect complete");
    ws_chan!.stream.listen((wsm) {
      print("ws_chan listener event fired from chat event ~ " + wsm.toString());

      setState(() {
         _roomMessages!.insert(0, wsm);
      });
    });

    // sendChannel.stream.listen((_) {}, onDone: () {
    //   print("send channel close code ${sendChannel.closeCode}");
    //   print("send channel close reason" + "${sendChannel.closeReason}");
    //   sendChannel.sink.close();
    //   sendSocketIsConnected = false;
    //   if (mounted) {
    //     setState(() {
    //       sendSocketIsConnected = false;
    //     });
    //   }
    // }, onError: (err) {
    //   sendChannel.sink.close();
    //   sendSocketIsConnected = false;
    //   if (mounted) {
    //     setState(() {
    //       sendSocketIsConnected = false;
    //     });
    //   }
    // });
  }

  void _handle_submit(String text) {
    print("handle chat message submit called");
    if (text == "" || text == null) {
      return;
    }
    var date = new DateTime.now();
    var timeStamp = date.millisecondsSinceEpoch;
    // var uuidMsg = new Uuid();
    // var msguuid = uuidMsg.v4().toString();

    Map ws_msg = {
      "time": timeStamp.toString(),
      "message": text,
      "type": "chatMessage",
      "from": cur_user,
      "roomName": widget.room!.roomName
    };

    ws_chan!.sink.add(json.encode(ws_msg));
    // sendChannel.sink.add(msgData);
    _chat_msg_ctl.clear();
  }

  Widget build(BuildContext context) {
  print("build chat");
  print("gwin size " + g_win_size.toString());
    return Scaffold(
        body: Container(
      color: Colors.black,
      height: g_win_size!.height,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: g_win_size!.height * .1,
              ),
              Vid_Web_Element(),
              Container(
                height: g_win_size!.height * .1,
              )
            ],
          ),

          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Container(width:g_win_size!.width*.3,
              child:ListView.builder( itemCount:_roomMessages!.length,
                  itemBuilder: (context,idx ){
                  print("item builder build room msgs");
                    return Text(_roomMessages![idx]["text"]);
              })
              )
            ],)

          ],),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              color: chat_text_color, width: g_win_size!.width * 0),
                          bottom: BorderSide(color: chat_text_color, width: 0),
                          top: BorderSide(
                              color: chat_text_color, width: g_win_size!.width * .005),
                          right: BorderSide(
                              color: chat_text_color, width: g_win_size!.width * 0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: g_win_size!.width * .7,
                              padding: EdgeInsets.only(left: g_win_size!.width * .02),
                              child: TextField(
                                controller: _chat_msg_ctl,
                                style: chat_text_main,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Message'),
                              )),
                          MouseRegion(
                              // onHover: (e) {
                              //   setState(() {
                              //     print("hov");
                              //   });
                              // },
                              onEnter: (e) {
                                print("enter");
                                setState(() {
                                  send_color = Colors.purpleAccent;
                                });
                              },
                              onExit: (e) {
                                print("exit");
                                setState(() {
                                  send_color = Colors.black54;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: send_color,
                                    border: Border.all(
                                        color: chat_text_color,
                                        width: g_win_size!.width * .003)),
                                width: g_win_size!.width * .22,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      print("Send message press msg ~ " +
                                          _chat_msg_ctl.text);
                                      _handle_submit(_chat_msg_ctl.text);
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: chat_text_color,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      )))
            ],
          )
        ],
      ),
    ));
  }
}

class ChatMsg extends StatefulWidget {
  ChatMsg({Key? key, this.profilePicW, this.msg}) : super(key: key);
  Widget? profilePicW;
  Map? msg;
  _ChatMsgState createState() => _ChatMsgState();
}

class _ChatMsgState extends State<ChatMsg> {
  final BorderRadius radius = BorderRadius.only(
    topRight: Radius.circular(5.0),
    topLeft: Radius.circular(10.0),
    bottomRight: Radius.circular(5.0),
  );

  Widget build(BuildContext context) {
  print("build chat msg");
    return new Container(
        width: MediaQuery.of(context).size.width * .6,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (BuildContext context) {
                  //     // return AccountViewPage(
                  //     //   userID: fromID,
                  //     //   userUUID: fromUUID,
                  //     // );
                  //   },
                  // ));
                },
                child: ClipRRect(
                    borderRadius: new BorderRadius.circular(g_win_size!.width * .08),
                    child: Align(
                        widthFactor: .77,
                        heightFactor: .77,
                        child: Container(
                            width: g_win_size!.height * .08,
                            height: g_win_size!.height * .08,
                            child: widget.profilePicW??Container())))),
            Container(
              width: g_win_size!.width * .02,
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(widget.msg!["sender"],
                    style: TextStyle(fontSize: g_win_size!.height * .02)),
                new Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .5,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(.24))
                    ],
                    color: Colors.blue[500],
                    borderRadius: radius,
                  ),
                  padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(widget.msg!["text"],
                      softWrap: true,
                      style: TextStyle(fontSize: g_win_size!.height * .02)),
                )
              ],
            )
          ],
        ));
  }
}
