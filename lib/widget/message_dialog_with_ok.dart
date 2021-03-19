import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDialogWithOk extends StatelessWidget {
  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute

  ;

  static const double padding = 20.0;
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);

  const CustomDialogWithOk(
      {@required this.title,
        @required this.description,
        @required this.primaryButtonText,
        this.primaryButtonRoute
   });

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),color: Colors.indigoAccent
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: AutoSizeText(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  AutoSizeText(
                    description,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: AutoSizeText(
                        primaryButtonText,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w200),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if(primaryButtonRoute!=null){
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
