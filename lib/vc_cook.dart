import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

Cookie vc_cook = Cookie("vidchat_ck_key", "vidchat_ck_val");

String suname = "session user name";
String spass = "session password";

Map cook_data = {
  "vm_session": {"user": suname, "auth":spass}
};
String enc_cook_data = json.encode(cook_data);
Cookie raw_cook = Cookie.fromSetCookieValue(enc_cook_data);
