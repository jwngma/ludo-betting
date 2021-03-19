import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ludobettings/games/live/PickImageFromGallery.dart';
import 'package:ludobettings/models/eventModel.dart';

import 'package:ludobettings/screens/faq_screen.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyLiveContestEventDetailsPage extends StatefulWidget {
  static const String routeName = "/MyContestEventDetailsPage";
  final EventModel eventModel;

  MyLiveContestEventDetailsPage({
    this.eventModel,
  });

  @override
  _MyLiveContestEventDetailsPageState createState() =>
      _MyLiveContestEventDetailsPageState(this.eventModel);
}

class _MyLiveContestEventDetailsPageState
    extends State<MyLiveContestEventDetailsPage> {
  final EventModel eventModel;

  String toVisible = "credentials";

  FirestoreServices fireStoreServices = FirestoreServices();
  bool userparticipated = false;
  List<DocumentSnapshot> _listParticipatiedUsers;
  bool _loadingProducts = true;

  _MyLiveContestEventDetailsPageState(this.eventModel);

  @override
  void initState() {
    super.initState();
    _getParticiaptedUsers();
  }

  _getParticiaptedUsers() async {
    fireStoreServices
        .getparticipatedusers(eventModel.gameId.toString())
        .then((val) {
      _listParticipatiedUsers = val;
      setState(() {
        _loadingProducts = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    FirestoreServices db = FirestoreServices();
    String time;
    try {
      time = DateFormat.yMMMMd('en_US')
          .add_E()
          .addPattern("${"@"}")
          .add_jm()
          .format(DateTime.parse(eventModel.time));
    } catch (error) {
      time = "${eventModel.time}";
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(" Match  #${eventModel.gameId}"),
        elevation: 1,
        actions: <Widget>[
          SizedBox(
            width: 2,
          ),
          IconButton(
              icon: Icon(Icons.live_help),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FaqScreen();
                }));
              }),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("assets/images/ludo_banner.png"),
                      ),
                      Positioned(
                        top: 5,
                        left: 0,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 40,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.blue),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: Text(
                                        "${eventModel.gameType} Match  #${eventModel.gameId}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: Text(
                                "${time}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: Text(
                                eventModel.status,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.white])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "App Type ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          eventModel.appType,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Type ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          eventModel.gameType,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    showBottomSheet(
                                        context: context,
                                        builder: (context) => Container());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue)),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            "Winner Prize ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  "Rs: ${eventModel.prize} /-",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Entry Fee",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          eventModel.entryFee == 0
                                              ? "Free"
                                              : "${eventModel.entryFee} Coins",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Slider(
                                            activeColor: Colors.red,
                                            inactiveColor: Colors.black,
                                            divisions: 100,
                                            label:
                                                "${eventModel.totalParticipated.toString()} Users Participated",
                                            value: eventModel.totalParticipated
                                                .toDouble(),
                                            onChanged: (value) {},
                                            max: 100,
                                          ),
                                          eventModel.status ==
                                                  Constants.status_upcoming
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    eventModel.totalParticipated >=
                                                            eventModel
                                                                .totalPlayer
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color:
                                                                    Colors.red),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "Match is Full",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                          )
                                                        : Text(
                                                            "${eventModel.totalPlayer - eventModel.totalParticipated}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    eventModel.totalParticipated >=
                                                            eventModel
                                                                .totalPlayer
                                                        ? Text("",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red))
                                                        : AutoSizeText(
                                                            "spots left",
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 5),
                                                          ),
                                                  ],
                                                )
                                              : SizedBox.shrink(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "${eventModel.totalParticipated}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "/",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${eventModel.totalPlayer} Spots",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Note- After Winning the Match Upload the Screen of the result here (Please upload only the actual screenshot)",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return PickImageFromGallery(
                                  eventId: eventModel.gameId,
                                  uid: eventModel.uid,

                                );
                              }));
                            },
                            child: Text(
                              " Upload Winning ScreenShot here",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(
                                color: toVisible == "credentials"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "credentials";
                                  });
                                },
                                child: Text("CREDENTIALS",
                                    style: TextStyle(fontSize: 12)))),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(
                                color: toVisible == "rules"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "rules";
                                  });
                                },
                                child: Text("RULES",
                                    style: TextStyle(fontSize: 12)))),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(
                                color: toVisible == "participants"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "participants";
                                  });
                                },
                                child: Text(
                                  "PARTICIPANTS",
                                  style: TextStyle(fontSize: 12),
                                ))),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: _buildWidgets(toVisible),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWidgets(String toVisible) {
    List<Widget> listWidgets = [];

    if (toVisible == "rules") {
      listWidgets.add(
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Rules to Follow",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      listWidgets.add(SizedBox(
        height: 20,
      ));
      listWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Constants.ludoMatchRules
                .asMap()
                .entries
                .map((MapEntry map) => _buildRules(map.key))
                .toList(),
          ),
        ),
      );

      return listWidgets;
    }
    if (toVisible == "participants") {
      listWidgets.add(
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "PARTICIPANTS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      listWidgets.add(Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            child: _loadingProducts == true
                ? Container(
                    child: Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    )),
                  )
                : _listParticipatiedUsers.length == 0
                    ? Container(
                        child: Center(
                            child: Text(
                        "No Participants Yet",
                        style: TextStyle(color: Colors.red),
                      )))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _listParticipatiedUsers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 10,
                            color: Colors.green,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text("${index + 1}"),
                              ),
                              title: Text(
                                  _listParticipatiedUsers[index].data["name"]),
                            ),
                          );
                        }),
          ),
        ),
      ));
    }
    if (toVisible == "credentials") {
      listWidgets.add(
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "CREDENTIALS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      listWidgets.add(Align(
        alignment: Alignment.topLeft,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.indigo,
                      child: ListTile(
                        title: Text(
                          "Room Id",
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          "${eventModel.roomId}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.indigo,
                      child: ListTile(
                        title: Text(
                          "Room Password",
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          "${eventModel.roomPassword}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ));
      listWidgets.add(SizedBox(
        height: 20,
      ));
    }

    return listWidgets;
  }

  Widget _buildRules(int index) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Constants.ludoMatchRules[index],
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
