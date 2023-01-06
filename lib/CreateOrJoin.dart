import 'package:flutter/material.dart';
import 'package:ns_fw_room_login/lounge_rooms.dart';
import 'CreateRoom.dart';

class CreateOrJoin extends StatefulWidget {
  @override
  _CreateOrJoinState createState() => _CreateOrJoinState();
}

class _CreateOrJoinState extends State<CreateOrJoin> {
  Widget build(BuildContext context) {
    Size ss = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: ss.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                hoverColor: Colors.purple,
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new CreateRoom()));
                },
                child: Container(
                  height: ss.height * .12,
                  child: Center(
                    child: Text("Create Chat Room"),
                  ),
                )),
            Container(
              height: ss.width * .02,
            ),
            InkWell(
                hoverColor: Colors.purple,
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new LoungeRooms()));
                },
                child: Container(
                  height: ss.height * .12,
                  child: Center(
                    child: Text("Join Chat"),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
