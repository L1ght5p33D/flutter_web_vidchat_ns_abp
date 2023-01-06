import 'package:flutter/material.dart';
import 'package:ns_fw_room_login/CreateOrJoin.dart';
import 'state_room.dart';
import 'dart:convert';
import 'chat.dart';
import 'package:ns_fw_room_login/state_user.dart';

Map Joinp = {"op": "join", "user": "none", "roomName": "none"};

class LoungeRooms extends StatefulWidget {
// join param
// init is set if sent from CreateRoom otherwise false
// {"user":<'username'>, "init",<true/false>}

  const LoungeRooms({Key? key, Map? joinp}) : super(key: key);

  _LoungeRoomsState createState() => _LoungeRoomsState();
}

class _LoungeRoomsState extends State<LoungeRooms> {
// Get list of rooms available from the server
//   List avail_rooms = [];
  List avail_rooms_data = [
    {
      "name": "testroom1",
      "users": ["tusera", "tuserb"]
    },
    {
      "name": "testroom2",
      "users": ["tuser3", "tuser4"]
    }
  ];
  List<Widget> rooms_build = [];

  User? cur_user;
  String? op;

  initState() {
    RoomsState.stateStream.listen((e) {
      print("room state event ~ " + e.toString());
      if (e["op"] == "create") {
        setState(() {
          cur_user = e["user"];
          op = e["op"];
        });
      }
      if (e["op"] == "join") {
        // get room data from GET already should be made for room meta data
      }
    });

    UserState.stateStream.listen((e) {
      print("user stream set state " + e.toString());
      setState(() {
        cur_user = e;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: avail_rooms_data.length,
      itemBuilder: (BuildContext context, no) {
        List<Widget> bitems = [];
        // avail_rooms.forEach((dec_room) {
        if (no == 0) {
          return ListTile(
              title: Row(children: [
            IconButton(
              onPressed: () {
                print("new room create press");
                // http get to create new endpoint

                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => CreateOrJoin()));
              },
              icon: Icon(Icons.add_outlined),
            ),
            Text("Create new chat")
          ]));
        }

        // });
        return ListTile(
            title: Row(children: [
          IconButton(
            onPressed: () {
              print("join room ");
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new ChatScreen(
                          room: ChatRoom(
                              roomName: avail_rooms_data[no - 1]["name"],
                              members: avail_rooms_data[no - 1]["users"]))));
            },
            icon: Icon(Icons.voice_chat_sharp),
          ),
          Text(avail_rooms_data[no - 1]["name"])
        ]));
      },
    ));
  }
}
