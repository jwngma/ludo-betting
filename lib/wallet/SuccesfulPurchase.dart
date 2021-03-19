import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludobettings/screens/home_page.dart';

class SuccesfulPurchase extends StatefulWidget {
  final bool done;
  final String desc;
  final String transactionId;
  final int amount;

  const SuccesfulPurchase(
      {this.done, this.desc, this.transactionId, this.amount});

  @override
  _SuccesfulPurchaseState createState() => _SuccesfulPurchaseState();
}

class _SuccesfulPurchaseState extends State<SuccesfulPurchase> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              SizedBox(height: 70),
              Center(
                child: Image.network(
                  'https://image.similarpng.com/very-thumbnail/2020/08/Illustration-of-light-bulb-icon-on-transparent-background-PNG.png',
                  width: size.width * .30,
                  height: MediaQuery.of(context).size.height * .2,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text("Success!",
                      style: TextStyle(
                          color: Color(0xff063057),
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.all(7.0),
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffFFAC38), width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: SelectableText(
                          "${widget.transactionId}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Text(' Transaction Id ', style: TextStyle(color: Colors.black),),
                        )),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(85, 20, 85, 20),
                  child: widget.done?Text(
                      "You have successfully your transaction of amount ${widget.amount}",
                      style: TextStyle(color: Color(0xff063057), fontSize: 14),
                      textAlign: TextAlign.center):
                  Text(
                      "You transaction of amount ${widget.amount} has Failed",
                      style: TextStyle(color: Color(0xff063057), fontSize: 14),
                      textAlign: TextAlign.center),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                child: SizedBox(
                  width: double.infinity,
                  child: blueButton(
                    "Copy Token",
                    () {
                      Clipboard.setData(
                          new ClipboardData(text: "${widget.transactionId}"));
                      Flushbar(
                        title: "Ok",
                        message: "Token copied successfully",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: SizedBox(
                      width: double.infinity,
                      child: blueButton("Go Home", () => {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_){
                          return HomePage();
                        }))
                      }))),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: viewMoreButtons("View Transaction Details",
                      () => {showPowerBottomSheet(context, widget.transactionId, widget.amount, widget.done)}),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

MaterialButton viewMoreButtons(String title, Function fun) {
  return MaterialButton(
    onPressed: fun,
    textColor: Colors.white,
    color: const Color(0xffFFAC38),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.left,
      ),
    ),
    height: 55,
    minWidth: 700,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  );
}

RaisedButton blueButton(String label, Function fun) {
  return RaisedButton(
    onPressed: fun,
    textColor: Colors.white,
    color: Color(0xfff063057),
    padding: const EdgeInsets.all(15.0),
    child: Text(label),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

showPowerBottomSheet(BuildContext context, String transactionId, int amount, bool done) => showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Container(
        height: 600,
        color: Color(0xFF737373),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
              )),
          child: Column(
            children: <Widget>[
              viewMoreButtons(
                  "Close Transaction", () => {Navigator.pop(context)}),
              SizedBox(height: 10),
              listItemContainer("Date of Transaction", "${DateTime.now()}"),
              listItemContainer("Transaction Id", "${transactionId}"),
              listItemContainer("Amount", "$amount"),
              listItemContainer("Transaction Type", "${done?"Success":"Failed"}"),
            ],
          ),
        ),
      );
    });

Widget listItemContainer(String title, String value) => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(196, 196, 196, 1)),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
        ],
      ),
      decoration: BoxDecoration(
          border: new Border(
              bottom: new BorderSide(width: 1.0, color: Color(0xffC4C4C4)))),
    );
