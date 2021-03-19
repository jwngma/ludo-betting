import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ludobettings/models/CoinModel.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/wallet/AllInOnePaymentPage.dart';
import 'package:ludobettings/wallet/AllinOneTwo.dart';
import 'package:ludobettings/wallet/PaymentScreen.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:provider/provider.dart';

class CoinStoreNewPage extends StatefulWidget {
  static const String routeName = "/CoinStorePage";

  @override
  _CoinStoreNewPageState createState() => _CoinStoreNewPageState();
}

class _CoinStoreNewPageState extends State<CoinStoreNewPage> {
  FirestoreServices fireStoreServices = FirestoreServices();
  int entry_coin;

  @override
  void initState() {
    DateTime currentDate = DateTime.now();
    var fiftyDaysFromNow = currentDate.add(new Duration(days: 50));
    print(
        '${fiftyDaysFromNow.month} - ${fiftyDaysFromNow
            .day} - ${fiftyDaysFromNow.year} ${fiftyDaysFromNow
            .hour}:${fiftyDaysFromNow.minute}');
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _getEntryCoins();
    super.initState();
  }

  showToastt(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getEntryCoins() async {
    var firestoreServices =
    Provider.of<FirestoreServices>(context, listen: false);
    int available_entry_coins = await firestoreServices.getEntryCoin();
    setState(() {
      entry_coin = available_entry_coins;
    });
  }

  List<CoinModel> coinList = Constants.coinList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: Text(
                                "Available Entry Coins:\n in Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                            child: Text(
                              entry_coin == 0 ? "0" : "$entry_coin ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.coins,
                                color: Colors.purpleAccent,
                              ),
                              onPressed: () {})
                        ],
                      ),
                    ),
                    Text(
                      entry_coin == 0
                          ? "Wait For Few Seconds To get loaded"
                          : "Loaded",
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 400,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: coinList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          title: Text(coinList[index].title),
                          subtitle: Text(coinList[index].desc),
                          trailing: ElevatedButton(
                              child: Text(
                                  "Buy Rs : ${coinList[index].price
                                      .toString()}"),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) {

                                      return PaymentScreen(
                                        price: coinList[index].price, coins: coinList[index].coins,);

                                   /*   return AllInOnepaymentScreen(
                                        price: coinList[index].price, coins: coinList[index].coins,);*/


//                                      /*dgvhj*/
                                      /*return PaymentScreen(
                                        price: coinList[index].price, coins: coinList[index].coins,);*/
                                    }));
                              }),
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
