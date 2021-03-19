import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
Widget showLoadingDialog() {
  return Container(
    child: Center(
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Column(
          children: <Widget>[
            SpinKitWave(
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please Wait...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    ),
  );
}
