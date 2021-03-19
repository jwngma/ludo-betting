import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/utils/Constants.dart';

class EventCards extends StatelessWidget {
  final EventModel eventModel;

  const EventCards({
    Key key,
    this.eventModel,
  }) : super(key: key);

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Image.asset("assets/images/ludo_banner.png"),
                ),
              ),
              Positioned(
                top: 0,
                height: 57,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.transparent])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.black),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.black),
                                  child: Text(
                                    "${eventModel.status}",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.black),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text("Game Type :"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text("${eventModel.gameType}"),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.black),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Match #${eventModel.gameId}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 2,
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.transparent])),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              "${time}",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.red),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AutoSizeText(
                                  eventModel.hostName == ""
                                      ? ""
                                      : "By: ${eventModel.hostName}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 7),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white])),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.ccApplePay,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          " ${eventModel.appType}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                    ],
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
                                  child: AutoSizeText(
                                    "Winner Prize",
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
                                    "Rs: ${eventModel.prize}",
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
                                    eventModel.entryFee == 0
                                        ? "Free"
                                        : "${eventModel.entryFee} coins",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Slider(
                                    activeColor: Colors.red,
                                    inactiveColor: Colors.black,
                                    divisions: eventModel.totalPlayer,
                                    label:
                                        "${eventModel.totalParticipated.toString()} Users Participated",
                                    value: double.parse(eventModel
                                        .totalParticipated
                                        .toString()),
                                    onChanged: (value) {},
                                    max: eventModel.totalPlayer.toDouble(),
                                  ),
                                  eventModel.status == Constants.status_upcoming
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            eventModel.totalParticipated >=
                                                    eventModel.totalPlayer
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.red),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          "Match is Full",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  )
                                                : Text(
                                                    "${eventModel.totalPlayer - eventModel.totalParticipated}",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            eventModel.totalParticipated >=
                                                    eventModel.totalPlayer
                                                ? Text("",
                                                    style: TextStyle(
                                                        color: Colors.red))
                                                : AutoSizeText(
                                                    "spots left",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.blue,
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
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  "/",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  "${eventModel.totalPlayer}",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                eventModel.status == Constants.status_upcoming
                                    ? "Join"
                                    : "show",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])),
        ],
      ),
    );
  }
}
