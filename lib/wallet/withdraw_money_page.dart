import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludobettings/screens/address_page.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/widget/message_dialog_with_ok.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludobettings/models/address_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class WithdrawMoney extends StatefulWidget {
  @override
  _WithdrawMoneyState createState() => _WithdrawMoneyState();
}

class _WithdrawMoneyState extends State<WithdrawMoney> {
  int entry_coin;
  String withdrawal_address = "";
  TextEditingController _withdrawal_addressController = TextEditingController();
  FirebaseAuthServices authServices = FirebaseAuthServices();
  FirestoreServices _fireStoreServices = FirestoreServices();

  int selected_location = 0;
  bool walletSelected = false;
  List<String> withdrawalServices = Constants.withdrawalServices;

  String paytm_wallet, googlepay_wallet, _warning;
  bool isLoginPressed = false;
  AddressModel addressModel;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _getPoints();
  }

  _getPoints() async {
    var firestoreServices =
        Provider.of<FirestoreServices>(context, listen: false);
    int available_entry_coins = await firestoreServices.getAmount();
    if (mounted) {
      setState(() {
        entry_coin = available_entry_coins;
      });
    }
  }

  showEmptyWalletDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => CustomDialogWithOk(
              title: "Empty Wallet",
              description: "Your have Not Added Your $message Address Yet",
              primaryButtonText: "Ok",
              primaryButtonRoute: AddressPage.routeName,
            ));
  }

  getTheWithdrawalAddress(ProgressDialog progressDialog, int value) async {
    switch (value) {
      case 0:
        //Paytm
        await progressDialog.show();
        addressModel = await _fireStoreServices.getUserAddress().then((value) {
          progressDialog.hide();

          if (value.paytm_wallet == "" || value.paytm_wallet == null) {
            setState(() {
              showEmptyWalletDialog("Paytm");
              _withdrawal_addressController.text =
                  "Please Save Your Address First";
            });
            return;
          } else {
            setState(() {
              walletSelected = true;
              _withdrawal_addressController.text = value.paytm_wallet;
              withdrawal_address = _withdrawal_addressController.text;
            });
            return;
          }
        });

        break;
      case 1:
        //Google pay
        await progressDialog.show();
        addressModel = await _fireStoreServices.getUserAddress().then((value) {
          progressDialog.hide();

          if (value.googlepay_wallet == "" || value.googlepay_wallet == null) {
            setState(() {
              showEmptyWalletDialog("Google pay)");
              _withdrawal_addressController.text =
                  "Please Save Your Address First";
            });
            return;
          } else {
            setState(() {
              walletSelected = true;
              _withdrawal_addressController.text = value.googlepay_wallet;
              withdrawal_address = _withdrawal_addressController.text;
            });
            return;
          }
        });

        break;
    }
  }

  showToasts(String message) {
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

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
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
                              "Available Amount Rs:\n in Wallet",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: Text(
                                entry_coin == 0 ? "0" : "$entry_coin",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.gem,
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
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: AutoSizeText(
                        "Note- Add Your Withdrawal Address, before withdrawal",
                        maxLines: 2,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddressPage();
                        }));
                      },
                      child: Container(
                        color: Colors.red,
                        child: Text("Here"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  color: Colors.grey[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      AutoSizeText(
                        "Select the Wallet service",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        color: Colors.grey[600],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton(
                            color: Colors.grey,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  withdrawalServices[selected_location],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ],
                            ),
                            onSelected: (int value) {
                              setState(() {
                                selected_location = value;
                                getTheWithdrawalAddress(progressDialog, value);
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuItem<int>>[
                                PopupMenuItem(
                                  child: Text(
                                    withdrawalServices[0],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    withdrawalServices[1],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  value: 1,
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    child: TextFormField(
                  style: TextStyle(fontSize: 14),
                  controller: _withdrawal_addressController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Wallet Address",
                    labelStyle: TextStyle(fontSize: 15),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onSaved: (String value) => withdrawal_address = value,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: FlatButton(
                    onPressed: () async {
                      ProgressDialog pr =
                          ProgressDialog(context, isDismissible: false);
                      int amount = await _fireStoreServices.getAmount();
                      var name = await _fireStoreServices.gettName();
                      var number = await _fireStoreServices.getNumber();
                      var matchPlayed =
                          await _fireStoreServices.getMatchPlayed();

                      print("Name: $name \n Number: $number\n MatchPlayed: $matchPlayed");

                      if (amount >= 300) {
                        if (walletSelected == true) {
                          if (withdrawal_address != "") {
                            await pr.show();
                            _fireStoreServices
                                .addWithdrawRequest(
                                    context,
                                    withdrawalServices[selected_location],
                                    amount,
                                    withdrawal_address, name, number, matchPlayed)
                                .then((val) {
                              pr.hide();
                              setState(() {
                                amount = 0;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomDialogWithOk(
                                        title: "Withdrawal request",
                                        description:
                                            "Your withdrawal will be processed within 48 Hours",
                                        primaryButtonText: "Ok",
                                        primaryButtonRoute: HomePage.routeName,
                                      ));
                            });
                          } else {
                            showToasts("We should send you to the Address");
                          }
                        } else {
                          showToasts("Please Select Your Wallet Address First");
                        }
                      } else {
                        showToasts(
                            "You have Low Balance in your wallet, Min Withdraw point is 500");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Withdraw",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Note- You Will receive your payment within 48 hours if you use Paytm or Google pay For Withdrawal",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
