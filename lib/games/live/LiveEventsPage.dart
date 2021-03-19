import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/widget/events_card.dart';
import 'package:ludobettings/widget/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'LiveEventDetailsPage.dart';

class LiveEventsScreen extends StatefulWidget {
  @override
  _LiveEventsScreenState createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  FirestoreServices fireStoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();

  bool _loadingProducts = true;
  List<DocumentSnapshot> _listEvents = [];

  var prizesmap = Map<String, dynamic>();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    getEvents();
  }

  getEvents() {
    fireStoreServices.getEvents(Constants.status_live).then((val) {
      _listEvents = val;
      print(_listEvents.length);
      if (mounted) {
        setState(() {
          _loadingProducts = false;
        });
      }
    });
  }

  List<Widget> chick_hunter_texts(context) => [
        Text(
          Constants.live_tournaments,
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
  void dispose() {
    super.dispose();
  }

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: MediaQuery.of(context).size.width,
                        child: Carousel(
                          boxFit: BoxFit.cover,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 6.0,
                          dotIncreasedColor: Color(0xFFFF335C),
                          dotBgColor: Colors.transparent,
                          dotPosition: DotPosition.bottomCenter,
                          dotVerticalPadding: 10.0,
                          showIndicator: true,
                          indicatorBgPadding: 7.0,
                          images: [
                            Image.asset(
                              Constants.ludo_banner,
                              fit: BoxFit.fill,
                            ),
                            Image.asset(
                              Constants.ludo_bannertwo,
                              fit: BoxFit.fill,
                            ),
                            Image.asset(
                              Constants.ludo_bannerfive,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ...chick_hunter_texts(context),
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
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "There are no any Live Contests",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          RaisedButton(
                                              color: Colors.indigo,
                                              child: Text(
                                                "Join Now",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                        );

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_) {
                                              return LiveEventDetailsPage(
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
              ],
            ),
          ),
        ));
  }
}
