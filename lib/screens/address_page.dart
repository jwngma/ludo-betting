import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ludobettings/models/address_model.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/utils/validators.dart';
import 'package:ludobettings/widget/message_dialog_with_ok.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddressPage extends StatefulWidget {
  static const String routeName = "/AddressPage";

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _paytmTextController = TextEditingController();
  TextEditingController _googlePayTextController = TextEditingController();


  ProgressDialog progressDialog;
  FirestoreServices _fireStoreServices = FirestoreServices();
  String paytm_wallet, googlepay_wallet, _warning;
  bool isLoginPressed = false;
  AddressModel addressModel;

  @override
  void initState() {
    super.initState();
    _getUserAddress();
  }

  _getUserAddress() async {
    addressModel = await _fireStoreServices.getUserAddress();
    setState(() {
      _paytmTextController.text = addressModel.paytm_wallet;
      _googlePayTextController.text = addressModel.googlepay_wallet;
    });
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

  updateAddress(BuildContext context, ProgressDialog progressDialog) async {
    progressDialog = new ProgressDialog(context);
    await progressDialog.show();

    AddressModel addressModel = AddressModel(
      paytm_wallet: paytm_wallet,
      googlepay_wallet: googlepay_wallet,
    );
    await _fireStoreServices.updateAddress(context, addressModel).then((val) {
      progressDialog.hide();
      showDialog(
          context: context,
          builder: (context) => CustomDialogWithOk(
                title: "Wallet Address Updated",
                description: "Your Wallet Addresses has been Updated,",
                primaryButtonText: "Ok",
                primaryButtonRoute: HomePage.routeName,
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet Address"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Save Your Wallet Address that you want to use for withdrawall",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  _buildErrorWidget(),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: _buildWidgets() + _buildButtons(),
                      )),
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.blue,
            child: Text(
              "Save",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 22),
            ),
            onPressed: () {
              submit(context);
            }),
      ),
    ];
  }

  bool isValid() {
    final form = _formKey.currentState;

    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit(BuildContext context) async {
    final form = _formKey.currentState;

    form.save();
    try {
      updateAddress(context, progressDialog);
    } catch (error) {
      setState(() {
        _warning = error.message;
        isLoginPressed = false;
      });
      print(error);
    }
  }

  InputDecoration buildSignUpinputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 10),
      fillColor: Colors.white,
      border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10.0),
        borderSide: new BorderSide(),
      ),
      //fillColor: Colors.green
    );
  }

  List<Widget> _buildWidgets() {
    List<Widget> textfields = [];

    textfields.add(Text(
      "Paytm Wallet Upi",
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ));
    textfields.add(SizedBox(
      height: 5,
    ));

    textfields.add(TextFormField(
      style: TextStyle(fontSize: 22),
      validator: Namevalidator.validate,
      controller: _paytmTextController,
      decoration:
          buildSignUpinputDecoration("Enter The Paytm Wallet upi address "),
      keyboardType: TextInputType.text,
      onSaved: (String value) => paytm_wallet = value,
    ));
    textfields.add(SizedBox(
      height: 5,
    ));
    textfields.add(Divider(
      color: Colors.red,
      height: 5,
    ));
    textfields.add(SizedBox(
      height: 20,
    ));
    textfields.add(Text(
      "Google Pay Upi",
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ));
    textfields.add(SizedBox(
      height: 5,
    ));

    textfields.add(TextFormField(
      style: TextStyle(fontSize: 22),
      validator: Namevalidator.validate,
      controller: _googlePayTextController,
      decoration: buildSignUpinputDecoration("Enter The Google Pay Upi Address"),
      keyboardType: TextInputType.text,
      onSaved: (String value) => googlepay_wallet = value,
    ));
    textfields.add(SizedBox(
      height: 5,
    ));
    textfields.add(Divider(
      color: Colors.red,
      height: 5,
    ));
    textfields.add(SizedBox(
      height: 20,
    ));

    //
    return textfields;
  }

  _buildErrorWidget() {
    if (_warning != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  IconButton(icon: Icon(Icons.error_outline), onPressed: () {}),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _warning = null;
                    });
                  }),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
