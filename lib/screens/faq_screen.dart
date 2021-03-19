import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Faq Screen"),
      ),
      body: SingleChildScrollView(
        child: new ListView.builder(
          itemCount: vehicles.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return new ExpansionTile(
              title: new Text(
                vehicles[i].title,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: <Widget>[
                new Column(
                  children: _buildExpandableContent(vehicles[i]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildExpandableContent(Vehicle vehicle) {
    List<Widget> columnContent = [];

    for (String content in vehicle.contents)
      columnContent.add(
        new ListTile(
          title: new Text(
            content,
            style: new TextStyle(fontSize: 18.0),
          ),
          leading: new Icon(vehicle.icon),
        ),
      );

    return columnContent;
  }
}

class Vehicle {
  final String title;
  List<String> contents = [];
  final IconData icon;

  Vehicle(this.title, this.contents, this.icon);
}

List<Vehicle> vehicles = [
  new Vehicle(
    "How to get Ludo Room Id and password",
    [
      'Room Id and password are shared inthe app, Just go to the app and Tab the My Contest section & click on your participated match. There you will get the room id and the password of that contest before 5 to 10 minutes of the contest start time. make sure to join the room in time',
    ],
    Icons.security,
  ),
  new Vehicle(
    'Why i have been kicked from the room?',
    [
      'If you have been kicked out from the room even after participating the event , then the reason may be- \n1. Your Ludo IGN(In-Game-Name) does not match \n2. May have Invited outsider / shared room details \n3. Continuously Moving/ changing position in the room \n4. Using Hacked account or Emulators to paly the match',
    ],
    Icons.delete,
  ),
  new Vehicle(
    'How do i edit my profile Details',
    [
      'Just go to the navigation drawer, and click the edit profile button, You will be navigated to the Profile page section',
    ],
    Icons.account_circle,
  ),
  new Vehicle(
    'Your Question is not listed',
    [
      'You can mail us your problem or doubt from the help section, We will be happy to help you',
    ],
    Icons.all_out,
  ),
];
