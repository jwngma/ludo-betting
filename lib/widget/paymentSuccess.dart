import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentSuccess extends StatelessWidget {
  final String title, description, primaryButtonText, primaryButtonRoute;

  static const double padding = 20.0;
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);

  const PaymentSuccess(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      this.primaryButtonRoute});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: const Offset(0.0, 10))
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 150,
                    width: 70,
                    child: Image.asset("assets/images/ludo_banner.png"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AutoSizeText(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  AutoSizeText(
                    description,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: AutoSizeText(
                        "Ok",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w200),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (primaryButtonRoute != null) {
                          Navigator.of(context)
                              .pushReplacementNamed(primaryButtonRoute);
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
