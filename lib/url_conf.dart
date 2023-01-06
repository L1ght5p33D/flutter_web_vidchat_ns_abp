Map<String, String> def_headers = {
  "ACCEPT": "text/html,application/json",
};
Map<String, String> ws_headers = {
  "ACCEPT": "text/html,application/json",
  "ACCEPT_ENCODING": "gzip,deflate,br",
  "CONNECTION": "keep-alive",
  "ACCEPT_LANGUAGE": "en-US,en",
  "CONTENT_TYPE": "application/x-www-form-urlencoded",
};

String vc_url = "http://localhost:3232";
String vc_ws_url = "ws://localhost:3232";


// var channel = HtmlWebSocketChannel.connect("ws://192.168.2.190:7003");
String test_room_url_connect = "ws://localhost:8001/chat/roomtest/";