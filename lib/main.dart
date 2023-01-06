import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:microphone/microphone.dart';
import 'login.dart';
import 'package:ns_fw_room_login/gstyles.dart';

MicrophoneRecorder? microphoneRecorder;
Widget? _webcamWidget;
VideoElement? _webcamVideoElement;

// Later figure out a way to retrieve session data between flutter runs
// might have to serve the app so its not the dev chrome instance
// either cookies or local storage indexed_db something like that
bool init_session = true;
void main() {
  print("Flutter session reload test ~");
  if (init_session == true) {
    print("init session true");
    var test_cookie = {"teststuff":"val 1"};
    document.cookie = (json.encode(test_cookie));
    init_session = false;
  }



  runApp(VChat_App());
}

class VChat_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    print("get session data ~ ");
    final cookie = document.cookie!;
    print("doc cookie str ~ " + cookie);

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: hp_audio_wrap());
  }
}

class hp_audio_wrap extends StatefulWidget {
  @override
  _hp_audio_wrapState createState() => _hp_audio_wrapState();
}

class _hp_audio_wrapState extends State<hp_audio_wrap> {
  initState() {
    microphoneRecorder = MicrophoneRecorder()
      ..init().then((res) {
        print("mic init done");
      });
  }

  // Widget build(BuildContext context) {
  //   return Camera_W_Wrap(title: 'Flutter Demo Home Page');
  // }
  Widget build(BuildContext context) {
    g_win_size = MediaQuery.of(context).size;
    return Login();
  }
}

class Camera_W_Wrap extends StatefulWidget {
  Camera_W_Wrap({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _Camera_W_WrapState createState() => _Camera_W_WrapState();
}

class _Camera_W_WrapState extends State<Camera_W_Wrap> {
  build(context) {
    return Camera_W();
  }
}

class Camera_W extends StatefulWidget {
  @override
  _Camera_WState createState() => _Camera_WState();
}

class _Camera_WState extends State<Camera_W> {
  initState() {
    // platformViewRegistry not defined still compiles fine
    ui.platformViewRegistry.registerViewFactory(
        'webcamVideoElement', (int viewId) => _webcamVideoElement!);
    init_wc();
  }

  init_wc() async {
    _webcamVideoElement = VideoElement();

    await window.navigator
        .getUserMedia(video: true)
        .then((MediaStream stream) async {
      print("init wc setstate1");

      setState(() {
        _webcamVideoElement!.srcObject = stream;
      });
    });

    // const oneSec = const Duration(seconds: 1);
    // new Timer.periodic(
    //     oneSec, (Timer t) => update_window_size(MediaQuery.of(context).size));
  }

  Widget build(BuildContext context) {
    print("rebuild camera wcw");
    g_win_size = MediaQuery.of(context).size;

    if (_webcamWidget == null) {
      _webcamWidget =
          HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');
    }

    return Scaffold(
        body: Container(
            height: g_win_size!.height * .4,
            child: Container(
                width: g_win_size!.width,
                height: g_win_size!.height * .6,
                child: _webcamWidget)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print("Cam action pressed");
            if (_webcamVideoElement!.srcObject!.active == true) {
              print("webcam src active play vid");
              _webcamVideoElement!.play();
              print("init audio");
              if (microphoneRecorder != null) {
                print("mic recording not null start audio rec");
                microphoneRecorder!.start();
              } else {
                print("mic recorder Still null !!!");
              }
            } else {
              print("end webcam vid");
              _webcamVideoElement!.pause();
              print("end mic audio ");
              if (microphoneRecorder != null) {
                print("mic not null nic rec stop");
                await microphoneRecorder!.stop();

                print("get recordingUrl");
                final recordingUrl = microphoneRecorder!.value.recording!.url;
              }
            }
          },
          tooltip: 'Start stream, stop stream',
          child: Icon(Icons.camera_alt),
        ));
  }
}
