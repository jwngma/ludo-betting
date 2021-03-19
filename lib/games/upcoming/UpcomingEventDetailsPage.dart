import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ludobettings/inapp_purchase/CoinStoreNewPage.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/screens/faq_screen.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/screens/profile_page.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/widget/message_dialog_with_ok.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';

class UpComingEventsDetailPage extends StatefulWidget {
  final EventModel eventModel;

  const UpComingEventsDetailPage({this.eventModel});

  @override
  _UpComingEventsDetailPageState createState() =>
      _UpComingEventsDetailPageState();
}

class _UpComingEventsDetailPageState extends State<UpComingEventsDetailPage> {
  FirestoreServices fireStoreServices = FirestoreServices();
  bool showLoading = true;
  bool userparticipated = false;
  List<DocumentSnapshot> _listParticipatiedUsers;
  bool _loadingProducts = true;
  String toVisible = "rules";

  @override
  void initState() {
    super.initState();
    _getParticiaptedUsers();
  }

  _getParticiaptedUsers() async {
    fireStoreServices
        .getparticipatedusers(widget.eventModel.gameId.toString())
        .then((val) {
      _listParticipatiedUsers = val;
      print("Parti users: ${_listParticipatiedUsers.length}");
      setState(() {
        _loadingProducts = false;
        checkIfParticipatedAlready();
      });
    });
  }


  checkIfParticipatedAlready() async {
    userparticipated = await fireStoreServices
        .getUserAlreadyparticipated(widget.eventModel.gameId);
    setState(() {
      showLoading = false;
    });
  }

  _participateNow(String ludoName) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    FirestoreServices db = FirestoreServices();

    await progressDialog.show();

    await db
        .participateLudoEvent(
            widget.eventModel,
            ludoName,
            widget.eventModel.entryFee,
            context)
        .then((val) async {
      if (val == true) {
        progressDialog.hide();
        setState(() {
          userparticipated = true;
          showDialog(
              context: context,
              builder: (context) => CustomDialogWithOk(
                    title: "Participated Successfully",
                    description:
                        "You have participated Successfully, Please Check The Match Credentials and Join the Match on Time",
                    primaryButtonText: "Ok",
                primaryButtonRoute: HomePage.routeName,
                  ));
        });
      } else {
        progressDialog.hide();
        showDialog(
            context: context,
            builder: (context) => CustomDialogWithOk(
                  title: "Slots is Full",
                  description:
                      "We have Reched The Max Limit, Please participate in the next Event",
                  primaryButtonText: "Ok",
                ));
      }
    });
  }

  _participateTheUser() async {
    print("Clicked");
    FirestoreServices db = FirestoreServices();
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    await progressDialog.show();
    String name = await db.getName();
    int entry_coins = await db.getEntryCoin();
    String ludoName = await db.getLudoName();
    print("Entry Coins: ${entry_coins}");

    if (!userparticipated) {
      if (name == "" || name == null||ludoName == "" || ludoName == null) {
        progressDialog.hide();
        showDialog(
            context: context,
            builder: (context) => CustomDialogWithOk(
                  title: "Name is Empty",
                  description: " Please Update Your Username & Ludo Name",
                  primaryButtonText: "Ok",
                  primaryButtonRoute: ProfilePage.routeName,
                ));
      } else if (entry_coins < widget.eventModel.entryFee) {
        progressDialog.hide();
        showDialog(
            context: context,
            builder: (context) => CustomDialogWithOk(
                  title: "Low Coin ",
                  description:
                      "You have low coin in your account. Buy coins to Participate",
                  primaryButtonText: "OK",
                  primaryButtonRoute: CoinStoreNewPage.routeName,
                ));
      } else if (entry_coins >= widget.eventModel.entryFee) {
        print("can Proccedd");
        print(" Entry Coin  is Greater Than Required");
        _participateNow(ludoName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    String time;
    try {
      time = DateFormat.yMMMMd('en_US')
          .add_E()
          .addPattern("${"@"}")
          .add_jm()
          .format(DateTime.parse(widget.eventModel.time));
    } catch (error) {
      time = "${widget.eventModel.time}";
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(" Match  #${widget.eventModel.gameId}"),
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
      floatingActionButton: showLoading
          ? CircularProgressIndicator(
              backgroundColor: Colors.red,
            )
          : FloatingActionButton.extended(
              backgroundColor: userparticipated ? Colors.black : Colors.red,
              onPressed: !userparticipated ? _participateTheUser : null,
              isExtended: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              icon: Icon(
                Icons.videogame_asset,
                color: Colors.white,
              ),
              label: Text(
                userparticipated ? "Participated" : "Particpate",
                style: TextStyle(color: Colors.white),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                        bottom: 0,
                        left: 10,
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
                                        " Match  #${widget.eventModel.gameId}",
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
                                "$time",
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
                                widget.eventModel.status,
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
                                          "Ludo King",
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
                                          widget.eventModel.entryFee == 0
                                              ? "Free"
                                              : "${widget.eventModel.entryFee} coins",
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
                                          widget.eventModel.gameType,
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
                            padding: const EdgeInsets.only(right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: AutoSizeText(
                                          "Winner Prize ",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Rs: ${widget.eventModel.prize}",
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
                                            divisions:
                                                widget.eventModel.totalPlayer,
                                            label:
                                                "${widget.eventModel.totalParticipated.toString()} Users Participated",
                                            value: widget
                                                .eventModel.totalParticipated
                                                .toDouble(),
                                            onChanged: (value) {},
                                            max: widget.eventModel.totalPlayer
                                                .toDouble(),
                                          ),
                                          widget.eventModel.status ==
                                                  Constants.status_upcoming
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    widget.eventModel
                                                                .totalParticipated >=
                                                            widget.eventModel
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
                                                            "${widget.eventModel.totalPlayer - widget.eventModel.totalParticipated}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    widget.eventModel
                                                                .totalParticipated >=
                                                            widget.eventModel
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
                                          "${widget.eventModel.totalParticipated}",
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
                                          "${widget.eventModel.totalPlayer} Spots",
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
                                color: toVisible == "rules"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "rules";
                                  });
                                },
                                child: Text("RULES"))),
                        SizedBox(
                          width: 5,
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
                                child: Text("PARTICIPANTS"))),
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        )),
                      ],
                    ),
                  )
                : _listParticipatiedUsers.length == 0
                    ? Container(
                        child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            "No Participants Yet",
                            style: TextStyle(color: Colors.red),
                          )),
                        ],
                      ))
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
                              subtitle: Text(_listParticipatiedUsers[index]
                                  .data["ludoName"]),
                            ),
                          );
                        }),
          ),
        ),
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
