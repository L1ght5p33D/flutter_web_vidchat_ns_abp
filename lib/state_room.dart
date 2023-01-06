import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'url_conf.dart';

class ChatRoom {
  ChatRoom({this.roomName, this.members});
  String? roomName;
  List<String>? members;
}

class RoomsState {
  static StreamController<String> gRooms_StateStrCtl = StreamController();
  static Stream stateStream = gRooms_StateStrCtl.stream.asBroadcastStream();

// User state passes a User obj
  static addCreateRoomEvent(Map event) async {
    print("create room state listener event ~ ");
    print(event.toString());
    gRooms_StateStrCtl.add(json.encode(event));
  }
}
