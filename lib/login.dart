import 'package:flutter/material.dart';
import 'package:ns_fw_room_login/CreateOrJoin.dart';
import 'randname.dart';
import 'chat.dart';
import 'url_conf.dart';
import 'state_user.dart';
import 'dart:math';
import 'lounge_rooms.dart';
import 'package:ns_fw_room_login/gstyles.dart';

class LoginForm extends StatefulWidget {
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? _userName;
  TextEditingController un_ctl = TextEditingController();

  Widget build(BuildContext context) {
    Size ss = MediaQuery.of(context).size;

    un_ctl.text = gen_rname();
    return
        //  Container(height: g_win_size!.height, child: Center(child: Text("meow"))

        Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: un_ctl,
            // initialValue: gen_rname(),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Username field is empty';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a Snackbar.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }

                print("send username streamval ~ " + un_ctl.text);
                // int user_id = Random().nextInt(99999999);
                _userName = un_ctl.text;
                setState(() {
                  gCurUser.name = _userName!;
                });
                UserState.addUserStateEvent(User(_userName!));

                print("username set");

                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => CreateOrJoin()));
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget build(BuildContext context) {

    TextStyle login_heading_style =
        TextStyle(fontSize: g_win_size!.width * .08, fontWeight: FontWeight.w700);

    TextStyle login_form_desc_style =
        TextStyle(fontSize: g_win_size!.width * .036, fontWeight: FontWeight.w600);
    return Scaffold(
        body: Container(
            width: g_win_size!.width,
            height: g_win_size!.height,
            child: Column(children: [
              // Top banner
              Container(
                height: g_win_size!.height * .01,
                color: Colors.purple,
              ),
              // Ad space at top of screen

              Center(
                  child: Container(
                      height: g_win_size!.height * .3,
                      width: g_win_size!.width,
                      child: Center(
                        child: Container(
                            width: g_win_size!.width,
                            child: Image.asset(
                                "assets/title_logo/vchat_titlelogo_1.png",
                                fit: BoxFit.fitWidth
                                //  Text("VChat Lounge",
                                // style: login_heading_style),
                                )),
                      ))),
              Container(
                height: g_win_size!.height * .01,
              ),
              Container(
                child: Center(
                  child: Text(
                    "Username",
                    style: login_form_desc_style,
                  ),
                ),
              ),
              Center(
                child: Container(width: g_win_size!.width * .45, child: LoginForm()),
              ),
            ])));
  }
}
