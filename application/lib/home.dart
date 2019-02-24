import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String pageName = "Meetings";

  List<Widget> _getData(DataSnapshot snapshot) {
    List<Widget> list = List<Widget>();
    if (pageName == "Meetings") {
      for (var value in snapshot.value.values) {
        Meetings temp = Meetings.fromJson(value);
        list.add(
          ListTile(
              contentPadding: EdgeInsets.all(8),
              title: Text(
                "Purpose: " + temp.purpose,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:
                    Text("Hosted By: " + temp.hostedBy + " at " + temp.venue),
              ),
              trailing: Text(temp.meetingTime.split(" ").join("\n"))),
        );
      }
    } else {
      for (var value in snapshot.value.values) {
        Issues temp = Issues.fromJson(value);
        list.add(ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text(
            "Issue : " + temp.Problem,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Tag: " + temp.Tag + "\t Date:" + temp.DateOfIssue),
          ),
          trailing: Text(temp.Status),
        ));
      }
    }
    return list;
  }

  Future<Null> _refresh() async {
    _refreshIndicatorKey.currentState.show();
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinity Community'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text("Meetings"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text("Concerns"),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            pageName = "Meetings";
          } else if (index == 1) {
            pageName = "Issues";
          }
          setState(() {});
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: FutureBuilder(
          future: FirebaseDatabase.instance
              .reference()
              .child("infinity/$pageName")
              .once(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Column(
                    children: <Widget>[
                      new Expanded(
                          child: new ListView(
                        children: _getData(snapshot.data),
                      ))
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (pageName == "Meetings")
            Navigator.of(context).pushNamed('/newMeeting');
          else if (pageName == "Issues")
            Navigator.of(context).pushNamed('/newIssue');
        },
      ),
    );
  }
}

class Meetings {
  String hostedBy;
  String purpose;
  String meetingTime;
  String venue;

  Meetings.fromJson(var value)
      : hostedBy = value["HostedBy"],
        purpose = value["PurposeOfMeeting"],
        meetingTime = value["MeetingTime"],
        venue = value["Venue"];
}

class Issues {
  String DateOfIssue;
  String Problem;
  String Status;
  String Tag;

  Issues.fromJson(var value)
      : DateOfIssue = value["DateOfIssue"],
        Problem = value["Problem"],
        Status = value["Status"],
        Tag = value["Tag"];
}
