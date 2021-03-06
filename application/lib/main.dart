import 'dart:async';

import 'home.dart';
import 'newMeeting.dart';
import 'newIssue.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() async {
  runApp(InfinityApp());
}

class InfinityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _handleCurrentScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (BuildContext context) => HomePage(),
          '/newMeeting': (BuildContext context) => NewMeeting(),
          '/newIssue': (BuildContext context) => NewIssue(),
        });
  }
}

Widget _handleCurrentScreen() {
  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      }
    },
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<bool> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);

    DatabaseReference userRef =
        await FirebaseDatabase.instance.reference().child("infinity/users");
    DataSnapshot snapshot = await userRef.once();
    int noOfUsers = snapshot.value.values.length;

    userRef
        .child("${noOfUsers + 1}")
        .set({"name": "${user.displayName}", "isAccepted": false});

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _testSignInWithGoogle().then((login) {
                      if (login) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        print("User not registered");
                      }
                    });
                  });
                },
                child: Text('SignUp using Google Id '),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
