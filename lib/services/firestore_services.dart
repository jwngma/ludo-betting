import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ludobettings/models/PaymentSuccessModel.dart';
import 'package:ludobettings/models/address_model.dart';
import 'package:ludobettings/models/eventModel.dart';
import 'package:ludobettings/models/users.dart';
import 'package:ludobettings/models/winnerModel.dart';
import 'package:ludobettings/utils/Constants.dart';

class FirestoreServices {
  Firestore _db = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<DocumentSnapshot>> getEvents(
    String status,
  ) async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.events)
        .where('status', isEqualTo: status)
        .orderBy("time", descending: false)
        .limit(30);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;

    return _list;
  }

  Future<bool> getUserAlreadyparticipated(int gameId) async {
    final FirebaseUser user = await auth.currentUser();
    List<dynamic> usersList = [];
    bool participated = false;
    print("Game Id $gameId");
    await _db
        .collection(Constants.events)
        .document("ludo${gameId}")
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data['participants'])
        .then((value) {
      usersList = value;
      if (usersList != null) {
        if (usersList.contains(user.uid)) {
          print("User Already Participated");
          participated = true;
        } else {
          print("Have to aprticipated");
          participated = false;
        }
      } else {
        print("No Paticipants yet");
        participated = false;
      }
    });

    return participated;
  }

  //participate user
  Future<bool> participateLudoEvent(EventModel eventModel, String ludoName,
      int entryFee, BuildContext context) async {
    final FirebaseUser user = await auth.currentUser();
    var respectsQuery = await _db
        .collection(Constants.events)
        .document("ludo${eventModel.gameId}")
        .collection("participants");
    var querySnapshot = await respectsQuery.getDocuments();
    var total_participated = querySnapshot.documents.length;
    print("Total" + total_participated.toString());

    print("Total Slots ${eventModel.totalPlayer}");

    if (total_participated <= eventModel.totalPlayer) {
      var userMap = Map<String, dynamic>();
      userMap['name'] = user.displayName;
      userMap['ludoName'] = ludoName;
      userMap['uid'] = user.uid;

      //decr amount from wallet
      await _db.collection(Constants.Users).document(user.uid).updateData({
        "entry_coin": FieldValue.increment(-entryFee),
        "matchPlayed": FieldValue.increment(1),
      }).then((value) async {
        // add to db to Participation array for show in drawer
        await _db
            .collection(Constants.events)
            .document("${Constants.ludo}${eventModel.gameId}")
            .updateData({
          "participants": FieldValue.arrayUnion([user.uid]),
          "totalParticipated": FieldValue.increment(1),
        }).then((value) async {
          //participate
          await _db
              .collection(Constants.events)
              .document("${Constants.ludo}${eventModel.gameId}")
              .collection("participants")
              .document(user.uid)
              .setData(userMap);
        });
      }).catchError((error) {
        _showError(context, error);
      });

      return true;
    } else {
      Fluttertoast.showToast(
          msg:
              "We have Reched The Max Limit, Please participate in the next Event",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }
  }

  //get Ludo name
  Future getLudoName() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data['ludoName']);
  }

  //get Ludo name
  Future gettName() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data['name']);
  }

  //drawer my particapition
  Future getMyParticipationsEvents() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection("Participations")
        .where('participants', arrayContains: user.uid)
        .orderBy("time", descending: true)
        .snapshots();
  }

  //drawer my particapition
  Future<List<DocumentSnapshot>> getMyContest(String status) async {
    final FirebaseUser user = await auth.currentUser();

    List<DocumentSnapshot> _list = [];

    Query query = _db
        .collection(Constants.events)
        .where('participants', arrayContains: user.uid)
        .where('status', isEqualTo: status)
        .orderBy("time", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;

    return _list;
  }

  // getting Notifications
  getNotifications() async {
    return await _db
        .collection("Notifications")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<List<DocumentSnapshot>> getparticipatedusers(String gameId) async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.events)
        .document("ludo$gameId")
        .collection(Constants.participants);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;

    return _list;
  }

  // getting the partipated user from the Eg Solo/ gameID/Paticipants
  getWinnerfortheEndedmatches(String gameType, String gameId) async {
    return await _db
        .collection(gameType)
        .document(gameId)
        .collection("winners")
        .snapshots();
  }

  // getting Group Message
  getGroupMessage() async {
    return await _db
        .collection("ludobettingChat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  // add group messge
  Future<void> addGroupMessage(String message, String name, String uid) async {
    var groupMap = Map<String, dynamic>();
    groupMap['message'] = message;
    groupMap['time'] = DateTime.now().toIso8601String();
    groupMap['name'] = name;
    groupMap['uid'] = uid;
    await _db.collection("ludobettingChat").document().setData(groupMap);
  }

  Future<List<DocumentSnapshot>> getResults() async {
    List<DocumentSnapshot> _list = [];
    Query query =
        _db.collection("Events").orderBy("drawNumber", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  Future<List<DocumentSnapshot>> getParticipationsTickets() async {
    final FirebaseUser user = await auth.currentUser();
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("participations")
        .orderBy("drawNumber", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  Future<List<DocumentSnapshot>> getWinners(String gameId) async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.events)
        .document("ludo$gameId")
        .collection(Constants.winner);

    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  // getting transaction done by the user
  Future<List<DocumentSnapshot>> getTransactions() async {
    final FirebaseUser user = await auth.currentUser();
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.Users)
        .document(user.uid)
        .collection("transactions")
        .orderBy("date", descending: false);

    QuerySnapshot querySnapshot = await query.getDocuments();
    _list = querySnapshot.documents;
    return _list;
  }

  Future getEntryCoin() async {
    final FirebaseUser user = await auth.currentUser();
    print("Get Points is called");
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["entry_coin"]);
  }

  Future getAmount() async {
    final FirebaseUser user = await auth.currentUser();
    print("Get Points is called");
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["amount"]);
  }

  Future getNumber() async {
    final FirebaseUser user = await auth.currentUser();
    print("Get Points is called");
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["phone_number"]);
  }

  Future getMatchPlayed() async {
    final FirebaseUser user = await auth.currentUser();
    print("Get Points is called");
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["matchPlayed"]);
  }

  Future getClicks(FirebaseUser currentUser) async {
    print("Get Clicks is called");
    return await _db
        .collection(Constants.Users)
        .document(currentUser.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data["clicks"]);
    // .then((DocumentSnapshot) => DocumentSnapshot.data['clicks']);
  }

  Future getName() async {
    final FirebaseUser user = await auth.currentUser();

    return await user.displayName;
  }

  Future<Users> getUserprofile() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db
        .collection(Constants.Users)
        .document(user.uid)
        .get()
        //.then((DocumentSnapshot) => Users.fromMap(DocumentSnapshot.data()));
        .then((DocumentSnapshot) => Users.fromMap(DocumentSnapshot.data));
  }

  Future<AddressModel> getUserAddress() async {
    final FirebaseUser user = await auth.currentUser();
    return await _db.collection(Constants.Users).document(user.uid).get().then(
        //(DocumentSnapshot) => AddressModel.fromJson(DocumentSnapshot.data()));
        (DocumentSnapshot) => AddressModel.fromJson(DocumentSnapshot.data));
  }

  Future<bool> addTransactionsBypaytm(
    BuildContext context,
    PaymentSuccessModel paymentSuccessModel,
  ) async {
    final FirebaseUser user = await auth.currentUser();

    await _db.collection(Constants.Users).document(user.uid).updateData({
      "entry_coin": FieldValue.increment(paymentSuccessModel.coins),
    }).then((val) async {
      //save the transactions record for the user
      var transMap = Map<String, dynamic>();
      transMap["version"] = Constants.app_version;
      transMap["txn"] = paymentSuccessModel.TXNID;
      transMap["amount"] = paymentSuccessModel.AMOUNT;
      transMap["status"] = paymentSuccessModel.STATUS;
      transMap["orderid"] = paymentSuccessModel.ORDERID;
      transMap["respcode"] = paymentSuccessModel.RESPCODE;
      transMap["checksumhash"] = paymentSuccessModel.CHECKSUMHASH;
      transMap["date"] = DateTime.now().toString();
      transMap["type"] = "Buying Entry Coin";

      await _db
          .collection(Constants.Users)
          .document(user.uid)
          .collection("transactions")
          .document(paymentSuccessModel.TXNID)
          .setData(transMap)
          .then((value) {
        return true;
      }).catchError((error) {
        _showError(context);
      });
    });
  }

  //Withdraw
  Future<void> addWithdrawRequest(
      BuildContext context,
      String method,
      int amount,
      String wallet_address,
      String name,
      String number,
      int matchPlayed) async {
    final FirebaseUser user = await auth.currentUser();
    //update to user Database

    await _db.collection(Constants.Users).document(user.uid).updateData({
      "amount": FieldValue.increment(-amount),
    }).then((val) async {
      var withdrawMap = Map<String, dynamic>();
      withdrawMap["amount"] = amount;
      withdrawMap["date"] = DateTime.now().toIso8601String();
      withdrawMap["method"] = method;
      withdrawMap["matchPlayed"] = matchPlayed;
      withdrawMap["name"] = "$name";
      withdrawMap["status"] = "pending";
      withdrawMap["number"] = "$number";
      withdrawMap["wallet_address"] = wallet_address;
      withdrawMap["uid"] = user.uid;
      withdrawMap["type"] = "Withdraw";
      withdrawMap["version"] = Constants.app_version;
      String docId = user.uid + "${DateTime.now().toIso8601String()}";
      await _db
          .collection("WithdrawRequest")
          .document(docId)
          .setData(withdrawMap)
          .then((value) async {
        await _db
            .collection(Constants.Users)
            .document(user.uid)
            .collection("transactions")
            .document(docId)
            .setData(withdrawMap)
            .then((value) {})
            .then((val) {
          print("Withdraw Request have been added");
        });
      }).catchError((error) {
        _showError(context);
      });
      ;
    });
  }

  //Update Profile
  Future<void> updateUserProfile(BuildContext context, Users user) async {
    final FirebaseUser users = await auth.currentUser();
    //update to user Database
    var userMap = Map<String, dynamic>();
    userMap['name'] = user.name;
    userMap['phone_number'] = user.phone_number;
    userMap['ludoName'] = user.ludoName;

    await _db
        .collection(Constants.Users)
        .document(users.uid)
        .updateData(userMap)
        .then((val) {
      print("User profile Updated");
    }).catchError((error) {
      _showError(context);
    });
    ;
  }

  //Update Profile
  Future<void> updateAddress(
      BuildContext context, AddressModel addressModel) async {
    final FirebaseUser user = await auth.currentUser();
    //update Adrress to user Database

    var addressMap = Map<String, dynamic>();
    addressMap['paytm_wallet'] = addressModel.paytm_wallet;
    addressMap['googlepay_wallet'] = addressModel.googlepay_wallet;

    await _db
        .collection(Constants.Users)
        .document(user.uid)
        .updateData(addressMap)
        .then((val) {
      print("User Address Updated");
    }).catchError((error) {
      _showError(context);
    });
    ;
  }

  Future<bool> addWinningScreenShot(int gameId, String url) async {
    final FirebaseUser user = await auth.currentUser();
    var winnerScreenshotMap = Map<String, dynamic>();
    winnerScreenshotMap["uid"] = user.uid;
    winnerScreenshotMap["url"] = url;

    await _db
        .collection(Constants.events)
        .document("${Constants.ludo}${gameId}")
        .collection("winner_proof")
        .document()
        .setData(winnerScreenshotMap)
        .then((value) async {
      return true;
    });
  }
}

_showDoneMessage(
  BuildContext context,
) {
  Fluttertoast.showToast(
      msg: "You have Paticipated Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

_showError(BuildContext context, [Error error]) {
  Fluttertoast.showToast(
      msg: "Error Occured, Please Try Again",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
