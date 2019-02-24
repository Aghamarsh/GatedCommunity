import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class NewIssue extends StatefulWidget {
  @override
  _NewIssueState createState() => _NewIssueState();
}

class _NewIssueState extends State<NewIssue> {
  final _problemCon = TextEditingController();
  final _tagCon = TextEditingController();

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
                    labelText: "Problem : ",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _problemCon,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Issue Tag : ",
                  ),
                  keyboardType: TextInputType.text,
                  controller: _tagCon,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                ),
                RaisedButton(
                  onPressed: updateIssue,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Add Issue"),
                ),
              ],
            )),
      ]),
    ));
  }

  void updateIssue() async {
    if (_problemCon.value == null || _tagCon.value == null) {
      return;
    }

    String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String tag = _tagCon.value.text;
    String problem = _problemCon.value.text;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String hostedBy = user.displayName;

    FirebaseDatabase.instance.reference().child('infinity/Issues').push().set({
      "DateOfIssue": "$date",
      "Problem": "$problem",
      "PostedBy": "$hostedBy",
      "Status": "opened",
      "Tag": "$tag"
    });

    Navigator.of(context).pop();
  }
}
