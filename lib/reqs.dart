import 'package:http/http.dart' as http;
import 'package:ns_fw_room_login/url_conf.dart';
import 'dart:convert';
import 'package:ns_fw_room_login/lounge_rooms.dart';

GET_rooms() async {
  print("Get rooms by name called");
  Uri posturl = Uri.parse(vc_url + "/rooms/");
//  print("USER NAME FOR INIT THREADS ${GUID.globUserID.id}");
  Map<String, String> headerMap = def_headers;

  Map<String, String> reqBody = {
    "meta": "get rooms request",
  };
  http.Response resp =
      await http.post(posturl, headers: headerMap, body: reqBody);
  Map decodedResp = json.decode(resp.body);
  print("Room get by nameresponse ~");
  print(decodedResp);
  // return resp.body;

  return resp.body;
}

POST_createRoom(Map jp) async {
  print("createroom called");

  Uri posturl = Uri.parse(vc_url + "/createRoom/");
//  print("USER NAME FOR INIT THREADS ${GUID.globUserID.id}");
  Map<String, String> headerMap = def_headers;

  Map<String, String> reqBody = {
    "meta": "creating new chat room",
    "roomName": jp["roomName"],
    "user": jp["user"],
  };
  print("creatRoom body ~ " + reqBody.toString());

  http.Response resp =
      await http.post(posturl, headers: headerMap, body: reqBody);

  Map decodedResp = json.decode(resp.body);
  print("Room create res ~ " + decodedResp.toString());
  // return resp.body;

  return decodedResp;
}
