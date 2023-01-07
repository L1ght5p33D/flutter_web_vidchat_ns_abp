import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:ns_fw_room_login/main.dart';
import 'package:ns_fw_room_login/gstyles.dart';

class Vid_Web_Element extends StatefulWidget {
  @override
  _Vid_Web_ElementState createState() => _Vid_Web_ElementState();
}

class _Vid_Web_ElementState extends State<Vid_Web_Element> {
  initState() {
    // platformViewRegistry not defined in js, still compiles fine



    WidgetsBinding.instance.addPostFrameCallback((_) {
      init_wc();
      _webcamVideoElement!.play();
    });


  }

  init_wc() async {
    _webcamVideoElement = VideoElement();
    ui.platformViewRegistry.registerViewFactory(
        'webcamVideoElement', (int viewId) => _webcamVideoElement!);
    if (_webcamWidget == null) {
      _webcamWidget =
          HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');
    }
    await window.navigator
        .getUserMedia(video: true)
        .then((MediaStream mstream) {
      List<MediaStreamTrack> msts = mstream.getVideoTracks();
      MediaStreamTrack mst = msts[0];

      setState(() {
        _webcamVideoElement!.srcObject = mstream;
      });
    });
  }

  Widget? _webcamWidget;
  VideoElement? _webcamVideoElement;

  Widget build(BuildContext context) {
    print("build vid portal");
    print("g win size ~ " + g_win_size.toString());
    return
     Container(
          width: g_win_size!.width,
          height: g_win_size!.height * .6,
          child:_webcamWidget??Container()
    );
  }
}
