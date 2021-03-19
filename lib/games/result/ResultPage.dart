import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ludobettings/games/result/resultEventDetailsPage.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/widget/ResultEventCard.dart';
import 'package:ludobettings/widget/events_card.dart';
import 'package:ludobettings/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  FirestoreServices fireStoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();
  bool _loadingProducts = true;
  List<DocumentSnapshot> _listEvents = [];
  GlobalKey<ScaffoldState> _key = GlobalKey();
  var prizesmap = Map<String, dynamic>();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    getEvents();
  }

  getEvents() {
    fireStoreServices.getEvents("Ended").then((val) {
      _listEvents = val;
      setState(() {
        _loadingProducts = false;
      });
    });
  }

  List<Widget> chick_hunter_texts(context) => [
    Text(
      "Results Of All Events",
      style: Theme.of(context).textTheme.headline.copyWith(fontSize: 32),
      textAlign: TextAlign.center,
    ),
    Text(
      "Play more, Kill more, Earn more and Repeat",
      style: Theme.of(context).textTheme.headline.copyWith(fontSize: 7),
      textAlign: TextAlign.center,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      ...chick_hunter_texts(context),
                      SizedBox(
                        height: 5,
                      ),
                      // tournamentsActions(context),
                      // events(context),
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
                              ? Container(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    Constants.nodata_icon,
                                    height: 100,
                                    width: 100,
                                  ),
                                  SizedBox(height: 30,),
                                  Center(
                                      child: Text(
                                        "Results Will be Declared Soon!",
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ],
                              ))
                              : ListView.builder(
                              itemCount: _listEvents.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                EventModel eventModel = EventModel(
                                  uid:
                                  _listEvents[index].data["uid"],
                                  gameId: _listEvents[index].data["gameId"],
                                  entryFee:
                                  _listEvents[index].data["entryFee"],
                                  prize: _listEvents[index]
                                      .data["prize"],
                                  totalPlayer: _listEvents[index]
                                      .data["totalPlayer"],
                                  totalParticipated: _listEvents[index]
                                      .data["totalParticipated"],
                                  time: _listEvents[index]
                                      .data["time"],
                                  status:
                                  _listEvents[index].data["status"],
                                  appType: _listEvents[index].data["appType"],
                                  gameType: _listEvents[index]
                                      .data["gameType"],
                                  hostName:
                                  _listEvents[index].data["hostName"],
                                );

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                              return ResultEventsDetailsPage(
                                                eventModel: eventModel,
                                              );
                                            }));
                                  },
                                  child: Card(
                                      elevation: 10,
                                      color: Colors.black12,
                                      child: ResultEventCard(
                                        eventModel: eventModel,
                                        prizemap: prizesmap,
                                      )),
                                );
                              })),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
