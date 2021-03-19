import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/widget/events_card.dart';
import 'package:ludobettings/widget/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'my_contest_event_details.dart';

class MyContestsScreen extends StatefulWidget {
  @override
  _MyContestsScreenState createState() => _MyContestsScreenState();
}

class _MyContestsScreenState extends State<MyContestsScreen> {
  Stream stream;
  FirestoreServices fireStoreServices = FirestoreServices();
  List<DocumentSnapshot> _listEvents;
  bool _loadingProducts = true;
  var prizesmap = Map<String, dynamic>();
  String toVisible = "Upcoming";

  _getMyParticipations(String status) async {
    if (status == "Upcoming") {
      fireStoreServices.getMyContest("Upcoming").then((val) {
        _listEvents = val;
        setState(() {
          _loadingProducts = false;
        });
      });
    } else {
      fireStoreServices.getMyContest("Ended").then((val) {
        _listEvents = val;
        setState(() {
          _loadingProducts = false;
        });
      });
    }
  }

  @override
  void initState() {
    _getMyParticipations("Upcoming");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
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
                              color: toVisible == "Upcoming"
                                  ? Colors.indigo
                                  : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  toVisible = "Upcoming";
                                  _getMyParticipations("Upcoming");
                                });
                              },
                              child: Text("Upcoming"))),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RaisedButton(
                              color: toVisible == "Ended"
                                  ? Colors.indigo
                                  : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  toVisible = "Ended";
                                  _getMyParticipations("Ended");
                                });
                              },
                              child: Text("Completed"))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    children: _buildWidgets(toVisible),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> _buildWidgets(String toVisible) {
    List<Widget> listWidgets = [];

    if (toVisible == "Upcoming") {
      listWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: _loadingProducts == true
                      ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Container(
                        child: Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.white,
                          enabled: true,
                          child: ShimmerWidget(),
                        ),
                      ),
                    ),
                  )
                      : _listEvents.length == 0
                      ? Center(
                    child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              Constants.nodata_icon,
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "You haven't joined any Upcoming Contest Yet !",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton(
                                color: Colors.indigo,
                                child: Text(
                                  "Join Now",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage();
                                          }));
                                })
                          ],
                        )),
                  )
                      : ListView.builder(
                      itemCount: _listEvents.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        EventModel eventModel = EventModel(
                          uid: _listEvents[index].data["uid"],
                          gameId:
                          _listEvents[index].data["gameId"],
                          entryFee: _listEvents[index]
                              .data["entryFee"],
                          prize:
                          _listEvents[index].data["prize"],
                          totalPlayer: _listEvents[index]
                              .data["totalPlayer"],
                          totalParticipated: _listEvents[index]
                              .data["totalParticipated"],
                          time: _listEvents[index].data["time"],
                          status:
                          _listEvents[index].data["status"],
                          appType: _listEvents[index]
                              .data["appType"],
                          gameType: _listEvents[index]
                              .data["gameType"],
                          hostName: _listEvents[index]
                              .data["hostName"],
                          roomId: _listEvents[index]
                              .data["roomId"],
                          roomPassword: _listEvents[index]
                              .data["roomPassword"],
                        );

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MyContestEventDetailsPage(
                                    eventModel: eventModel,
                                  );
                                }));
                          },
                          child: Card(
                              elevation: 10,
                              color: Colors.black12,
                              child: EventCards(
                                eventModel: eventModel,
                              )),
                        );
                      })),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      );

      return listWidgets;
    }
    if (toVisible == "Ended") {
      listWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: _loadingProducts == true
                      ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Container(
                        child: Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.white,
                          enabled: true,
                          child: ShimmerWidget(),
                        ),
                      ),
                    ),
                  )
                      : _listEvents.length == 0
                      ? Center(
                    child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              Constants.nodata_icon,
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "You haven't joined any Contest Yet !",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton(
                                color: Colors.indigo,
                                child: Text(
                                  "Join Now",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage();
                                          }));
                                })
                          ],
                        )),
                  )
                      : ListView.builder(
                      itemCount: _listEvents.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        EventModel eventModel = EventModel(
                          uid: _listEvents[index].data["uid"],
                          gameId:
                          _listEvents[index].data["gameId"],
                          entryFee: _listEvents[index]
                              .data["entryFee"],
                          prize:
                          _listEvents[index].data["prize"],
                          totalPlayer: _listEvents[index]
                              .data["totalPlayer"],
                          totalParticipated: _listEvents[index]
                              .data["totalParticipated"],
                          time: _listEvents[index].data["time"],
                          status:
                          _listEvents[index].data["status"],
                          appType: _listEvents[index]
                              .data["appType"],
                          gameType: _listEvents[index]
                              .data["gameType"],
                          hostName: _listEvents[index]
                              .data["hostName"],
                          roomId: _listEvents[index]
                              .data["roomId"],
                          roomPassword: _listEvents[index]
                              .data["roomPassword"],
                        );



                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MyContestEventDetailsPage(
                                    eventModel: eventModel,
                                  );
                                }));
                          },
                          child: Card(
                              elevation: 10,
                              color: Colors.black12,
                              child: EventCards(
                                eventModel: eventModel,
                              )),
                        );
                      })),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      );
    }

    return listWidgets;
  }
}
