import 'dart:async';
import 'home.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NewMeeting extends StatefulWidget {
  @override
  _NewMeetingState createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  final _purposeCon = TextEditingController();
  final _dateCon = TextEditingController();
  final _timeCon = TextEditingController();
  final _venueCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(30.0),
      child: ListView(children: [
        Form(
            autovalidate: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Purpose of the meeting : ",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _purposeCon,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Meeting Date : ",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _dateCon,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Meeting Time : ",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _timeCon,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Venue : ",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _venueCon,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: createMeeting,
                  textColor: Colors.white,
                  child: Text("Add Meeting"),
                ),
              ],
            )),
      ]),
    ));
  }

  void createMeeting() async {
    if (_purposeCon.value == null ||
        _dateCon.value == null ||
        _timeCon.value == null ||
        _venueCon.value == null) {
      return;
    }

    String date = _dateCon.value.text;
    String time = _timeCon.value.text;
    String venue = _venueCon.value.text;
    String purpose = _purposeCon.text;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String hostedBy = user.displayName;

    FirebaseDatabase.instance
        .reference()
        .child('infinity/Meetings')
        .push()
        .set({
      "MeetingTime": "$date" + " $time",
      "PurposeOfMeeting": "$purpose",
      "HostedBy": "$hostedBy",
      "Venue": "$venue"
    });

    Navigator.of(context).pop();
  }
}
