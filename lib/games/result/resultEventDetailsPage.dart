import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/models/winnerModel.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';

class ResultEventsDetailsPage extends StatefulWidget {
  final EventModel eventModel;

  const ResultEventsDetailsPage({Key key, this.eventModel}) : super(key: key);

  @override
  _ResultEventsDetailsPageState createState() =>
      _ResultEventsDetailsPageState(this.eventModel);
}

class _ResultEventsDetailsPageState extends State<ResultEventsDetailsPage> {
  final EventModel eventModel;

  _ResultEventsDetailsPageState(this.eventModel);

  FirestoreServices fireStoreServices = FirestoreServices();

  List<DocumentSnapshot> _listParticipatiedUsers;
  List<DocumentSnapshot> _listWinnersUsers;
  bool _loadingProducts = true;
  bool _loadingWinners = true;

  @override
  void initState() {
    super.initState();
    _getParticiaptedUsers();
    _getWinners();
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

  _getWinners() {
    fireStoreServices
        .getWinners(widget.eventModel.gameId.toString())
        .then((val) {
      _listWinnersUsers = val;
      setState(() {
        _loadingWinners = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text("Match Result"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightBGColors
                    : Constants.darkBGColors,
              ),
            ),
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  "Match #${eventModel.gameId}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                subtitle: Text("Organised at ${time}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightBGColors
                    : Constants.darkBGColors,
              ),
            ),
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("WIN PRIZE",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                        Text("ENTRY FEE",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Rs: ${eventModel.prize}",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                        Text("${eventModel.entryFee} coins",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightBGColors
                    : Constants.darkBGColors,
              ),
            ),
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Container(
                  color: Colors.orangeAccent,
                  child: Card(
                    color: Colors.yellow,
                    child: Text(
                      "Winner",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                subtitle: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.orangeAccent,
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "#",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              "PLAYER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(
                              "PRIZE",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 4,
                      color: Colors.red,
                    ),
                    Container(
                      child: _loadingWinners == true
                          ? Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              )),
                            )
                          : _listWinnersUsers.length == 0
                              ? Container(
                                  child: Center(
                                      child: Text(
                                  "No Participants Yet",
                                  style: TextStyle(color: Colors.red),
                                )))
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _listWinnersUsers.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    WinnerModel winnerModel = WinnerModel(
                                        ludoName: _listWinnersUsers[index]
                                            .data["ludoName"],
                                        name: _listWinnersUsers[index]
                                            .data["name"],
                                        winner_prize: _listWinnersUsers[index]
                                            .data["winner_prize"]);
                                    return _buildWinners(index, winnerModel);
                                  }),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightBGColors
                    : Constants.darkBGColors,
              ),
            ),
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Container(
                  color: Colors.orangeAccent,
                  child: Card(
                    color: Colors.yellow,
                    child: Text(
                      "Full Players List",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                subtitle: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.orangeAccent,
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "#",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              "PLAYER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 4,
                      color: Colors.red,
                    ),
                    Container(
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
                                  "No Players Yet",
                                  style: TextStyle(color: Colors.red),
                                )))
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _listParticipatiedUsers.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    WinnerModel playersModel = WinnerModel(
                                        ludoName: _listParticipatiedUsers[index]
                                            .data["ludoName"],
                                        name: _listParticipatiedUsers[index]
                                            .data["name"],
                                        winner_prize: 0);
                                    return _buildWinners(index, playersModel);
                                  }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildWinners(int index, WinnerModel winnerModel) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "${index + 1}",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                winnerModel.ludoName,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              flex: 2,
            ),
            Expanded(
              child: winnerModel.winner_prize == 0
                  ? SizedBox()
                  : Text(
                      "₹ ${winnerModel.winner_prize}",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
              flex: 1,
            ),
          ],
        ),
        Divider(
          height: 4,
          color: Colors.red,
        )
      ],
    );
  }
}
