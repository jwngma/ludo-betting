import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ludobettings/models/PaymentSuccessModel.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/wallet/SuccesfulPurchase.dart';
import 'package:ludobettings/widget/message_dialog_with_ok.dart';
import 'package:paytm/paytm.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final int price;
  final int coins;

  const PaymentScreen({Key key, this.price, this.coins}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String payment_response = null;
  FirestoreServices _fireStoreServices = FirestoreServices();

  //Live
  String mid = "NPtiMi63273535189560";
  String PAYTM_MERCHANT_KEY = "MFS@%5t2lZ9LunC#";
  String website = "DEFAULT";
  bool testing = false;

  //Testing
//  String mid = "iPMoji73382098817294";
//  String PAYTM_MERCHANT_KEY = "YZ2yMNcC%kMtT9fc";
//  String website = "WEBSTAGING";
//  bool testing = true;

  double amount = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    amount = widget.price.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Store'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "We Support Only payments by Paytm Wallet and Paytm Upi (We Will add more system very soon)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Select Any one Below",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  generateTxnToken(0, progressDialog);
                },
                child: Text(
                  "Pay using Paytm Wallet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  generateTxnToken(2, progressDialog);
                },
                child: Text(
                  "Pay using  Paytm UPI",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  generateTxnToken(2, progressDialog);
                },
                child: Text(
                  "Pay using  Google Pay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Note- If you paying using paytm wallet or upi, You should paytm installed in your device",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  showToastt(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
  void generateTxnToken(int mode, ProgressDialog progressDialog) async {
    progressDialog.show();
    setState(() {
      loading = true;
    });
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String custId = DateTime.now().millisecondsSinceEpoch.toString() + "0ne";

    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;
    var url = 'https://payapinow.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": mid,
      "key_secret": PAYTM_MERCHANT_KEY,
      "website": website,
      "orderId": orderId,
      "amount": amount.toString(),
      "callbackUrl": callBackUrl,
      "custId": custId,
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {'Content-type': "application/json"},
      );
      print("Response is");
      print(response.body);

      showToastt(response.body);
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          mid, orderId, txnToken, amount.toString(), callBackUrl, testing);

      paytmResponse.then((value) {
        print(value);


        setState(() {
          loading = false;
          print("Value is: $value ");

          if (value['error']) {
            payment_response = value['errorMessage'];
            progressDialog.hide();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return PaymentResultScreen(
                done: false,
                desc: " You Payment Transaction Failed ",
                transactionId: "Failed Transaction",
              );
            }));
          } else {
            if (value['response'] != null) {
              payment_response = value['response']['STATUS'];

              if (value['response']['RESPCODE'] == "01" &&
                  value['response']['STATUS'] == "TXN_SUCCESS") {
                PaymentSuccessModel paymentSuccessModel = PaymentSuccessModel(
                    ORDERID: value['response']['ORDERID'],
                    TXNID: value['response']['TXNID'],
                    STATUS: value['response']['STATUS'],
                    RESPCODE: value['response']['RESPCODE'],
                    CHECKSUMHASH: value['response']['CHECKSUMHASH'],
                    AMOUNT: widget.price,
                    coins: widget.coins);

                print("Response: " + payment_response);

                _fireStoreServices
                    .addTransactionsBypaytm(context, paymentSuccessModel)
                    .then((valu) {
                  progressDialog.hide();

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return SuccesfulPurchase(
                      done: true,
                      desc: "You have done you Transaction Successfully ",
                      amount: widget.price,
                      transactionId: "${value['response']['TXNID']}",
                    );
                  }));
                });
              } else if (value['response']['STATUS'] == "TXN_FAILURE") {
                progressDialog.hide();
                print("Response: " + value['response']);

                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return SuccesfulPurchase(
                    done: false,
                    desc: "Payment Transaction Failed",
                    amount: widget.price,
                    transactionId: "${value['response']['TXNID']}",
                  );
                }));
              }
            }
          }
          payment_response += "\n" + value.toString();
        });
      });
    } catch (e) {
      print(e);
    }
  }
}

class PaymentResultScreen extends StatefulWidget {
  final bool done;
  final String desc;
  final String transactionId;

  const PaymentResultScreen(
      {@required this.done, @required this.desc, this.transactionId});

  @override
  _PaymentResultScreenState createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((val) {
      showDialogPopup();
    });
    super.initState();
  }

  showDialogPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomDialogWithOk(
              title: widget.done ? "Success" : "Failed",
              description: widget.done
                  ? "You have Successfully Participated the Event,"
                  : "You have Failed to Participated",
              primaryButtonText: "Ok",
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment Status",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigoAccent,
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: widget.done
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Payment Success",
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You have done Payment Transaction Successfully,",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Text(
                            "The Event Results  will be published within 1 hour of the event time, Hope to see you  again.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          Spacer(),
                          Text(
                            "Note- Our Events are totally fair, ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                      height: 300,
                      width: MediaQuery.of(context).size.width * 0.9,
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      height: 300,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Payment Failed",
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Your Payment Transaction have Failed, We have Encounterd Some error while adding your Payment, ",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Text(
                            "Please Try Again, \nusing another Payment System",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          Spacer(),
                          Text(
                            "Note- We Support Only Payment Added using Paytm, You shoud have Paytm App istalled in your device",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      )),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return HomePage();
                  }));
                },
                child: Text("Back To Home")),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
