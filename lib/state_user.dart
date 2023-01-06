import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

// Map gUser = {"name": "none"};

class User {
  User(this.name);
  String name;
}

User gCurUser = User("none");

class UserState {
  static StreamController<User> gUserStateStrCtl = StreamController();
  static Stream stateStream = gUserStateStrCtl.stream.asBroadcastStream();

// User state passes a User obj
  static addUserStateEvent(User event) async {
    print("static user state listener called");
    gCurUser = event;
    gUserStateStrCtl.add(event);
  }
}
