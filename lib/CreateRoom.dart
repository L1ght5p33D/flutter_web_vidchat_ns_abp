
import 'package:flutter/material.dart';
import 'package:ns_fw_room_login/state_user.dart';
import 'package:ns_fw_room_login/chat.dart';
import 'package:ns_fw_room_login/state_room.dart';
import 'package:ns_fw_room_login/reqs.dart';



class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController rn_ctl = TextEditingController();
  String? _roomNameIn;
  int? _userLimitIn;
  User? cur_user;

  initState() {
    print("Create room first init called");
    if (cur_user == null && gCurUser.name != null) {
      print("cur user null setting gcuruser");
      cur_user = gCurUser;
    }
    UserState.stateStream.listen((e) {
      print("userstate stream sent with val :: " + e.toString());
      // print("CreateRoom user stream set state event user ~ " + e.name);
      if (e.name != null) {
        print("user even has name setting ~ " + e.name);
        setState(() {
          cur_user = e;
        });
      } else {
        print("null name passed");
      }
    });
  }



  Widget build(BuildContext context) {
    print("building creatroon with cur user ~" + cur_user!.name.toString());
    Size ss = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: ss.height,
      child: Center(
        child:
            //Room create form
            Container(
          // height: ss.height*.23
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: ss.width,
                    child: Center(
                      child: Text("Room Name"),
                    )),
                Container(
                    width: ss.width,
                    child: Center(
                        child: Container(
                            width: ss.width * .38,
                            child: TextFormField(
                              controller: rn_ctl,
                              // initialValue: gen_rname(),
                              onChanged: (v) {
                                setState(() {
                                  _roomNameIn = v;
                                });
                              },

                              onSaved: (v) {
                                setState(() {
                                  _roomNameIn = v;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a room name';
                                }
                                return null;
                              },
                              onEditingComplete: () {
                                setState(() {
                                  _roomNameIn = rn_ctl.text;
                                });
                              },
                              onFieldSubmitted: (val) {
                                setState(() {
                                  _roomNameIn = val;
                                });
                              },
                            )))),
                Container(
                  height: ss.width * .02,
                ),
                Container(
                    width: ss.width,
                    child: Center(
                      child: Text("User Limit"),
                    )),
                Container(
                    width: ss.width,
                    child: Center(
                        child: Container(
                            width: ss.width * .12,
                            child: TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _userLimitIn = int.parse(value!);
                                });
                              },
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              // initialValue: gen_rname(),
                              validator: (value) {
                                try {
                                  int gi = int.parse(value!);
                                } catch (e) {
                                  print("val not number");
                                  return 'Please enter a number';
                                }
                                if (value.isEmpty) {
                                  return 'Please enter a maximum number of users';
                                }
                                return null;
                              },
                            )))),
                Container(
                  height: ss.width * .02,
                ),
                Container(
                  height: ss.width * .12,
                  width: ss.width,
                  child: InkWell(
                      hoverColor: Colors.purple,
                      onTap: () async {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        // if (_formKey.currentState.validate()) {
                        //   // If the form is valid, display a Snackbar.
                        //   Scaffold.of(context).showSnackBar(
                        //       SnackBar(content: Text('Processing Data')));
                        // }
                        //Send values into LoungeRooms with stream
                        //
                        // Joinp["op"] = "create";
                        // Joinp["user"] = cur_user.name;
                        // Joinp["roomName"] = _roomNameIn;
                        // Joinp["roomId"] = Random().nextInt(99999999).toString();
                        _formKey.currentState!.validate();
                        print("build join param with roomname ~ " +
                            _roomNameIn.toString());

                        Map join_param = {
                          "user": cur_user!.name,
                          "roomName": _roomNameIn
                        };
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) => ChatScreen(
                                    room: ChatRoom(
                                        // roomId: ["roomId"],
                                        roomName: join_param["roomName"],
                                        members: [join_param["user"]]))));

                        // await POST_createRoom(join_param).then((create_res){
                        //   if (create_res["success"] == true){
                        //     // Navigator.push(
                        //     //     context,
                        //     //     new MaterialPageRoute(
                        //     //         builder: (BuildContext context) =>
                        //     //            TestW()));
                        //     Navigator.push(
                        //         context,
                        //         new MaterialPageRoute(
                        //             builder: (BuildContext context) =>
                        //                 ChatScreen(room:ChatRoom(
                        //                     // roomId: ["roomId"],
                        //                   roomName: join_param["roomName"],
                        //                     members:[join_param["user"]]) )));
                        //   }});
                      },
                      child: Center(
                        child: Text('Create'),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
