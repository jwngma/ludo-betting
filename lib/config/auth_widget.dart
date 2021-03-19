
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/screens/signup_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<User> userSnapshot;

   AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : SignUpPage();
    }
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
