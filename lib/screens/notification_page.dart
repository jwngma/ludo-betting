import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/widget/showLoading.dart';


class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Stream stream;
  FirestoreServices fireStoreServices = FirestoreServices();
  bool showLoading = true;

  @override
  void initState() {
    fireStoreServices.getNotifications().then((val) {
      setState(() {
        stream = val;
        showLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          StreamBuilder(
                              stream: stream,
                              builder: (context, snapshots) {
                                return snapshots.data == null
                                    ? showLoadingDialog()
                                    : ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            snapshots.data.documents.length,
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemBuilder: (context, index) {
                                          if (index < 0)
                                            return Text("No Notifications");
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Card(
                                              elevation: 1,
                                              color: Colors.grey,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.notifications,
                                                    size: 15,
                                                  ),
                                                ),
                                                title: AutoSizeText(
                                                  snapshots
                                                      .data
                                                      .documents[index]
                                                      .data["title"],
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  snapshots
                                                      .data
                                                      .documents[index]
                                                      .data["message"],
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                trailing: Text(
                                                  "${DateFormat.yMd().format(DateTime.parse(snapshots.data.documents[index].data['time'].toString()))}",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                              })
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
          showLoading ? showLoadingDialog() : SizedBox.shrink(),
        ],
      ),
    );
  }
}
