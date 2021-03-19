import 'dart:math';
import 'package:ludobettings/inapp_purchase/CoinStoreNewPage.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludobettings/wallet/transaction_page.dart';
import 'package:ludobettings/wallet/withdraw_money_page.dart';

class RedeemScreen extends StatefulWidget {
  static const String routeName = "/WalletScreen";

  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  FirestoreServices firestoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Wallet"),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Tools.multiColors[Random().nextInt(4)],
            labelStyle: TextStyle(
              fontSize: 12,
            ),
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                child: Text("Buy Coins",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                icon: Icon(
                  FontAwesomeIcons.coins,
                  size: 18,
                ),
              ),
              Tab(
                child: Text("Withdraw",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                icon: Icon(
                  FontAwesomeIcons.gem,
                  color: Colors.purpleAccent,
                  size: 18,
                ),
              ),
              Tab(
                child: Text("Transations",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                icon: Icon(
                  FontAwesomeIcons.moneyBillAlt,
                  size: 18,
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
        //  children: <Widget>[WithdrawMoney(), TransactionsPage()],
          children: <Widget>[CoinStoreNewPage(),WithdrawMoney(), TransactionsPage()],
        ),
      ),
    );
  }
}
