import 'package:ludobettings/screens/help_page.dart';
import 'package:ludobettings/screens/policy_page.dart';
import 'package:ludobettings/screens/profile_page.dart';
import 'package:ludobettings/screens/redeem_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share/share.dart';

import 'address_page.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = "/accountScreen";

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut(BuildContext context) async {
      ProgressDialog progressDialog =
      ProgressDialog(context, isDismissible: false);
      await progressDialog.show();
      try {
        var firebaseAuthServices = FirebaseAuthServices();
        GoogleSignIn _googleSignIn = GoogleSignIn();


        if (_googleSignIn!= null) {
          print("Google is called");
          await firebaseAuthServices.signOutWhenGoogle();
          progressDialog.hide();
        } else {
          print("Auth is Called");
          await firebaseAuthServices.signOut();
          progressDialog.hide();
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfilePage();

                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_box),
                            SizedBox(
                              width: 20,
                            ),
                            Text("My Profile"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RedeemScreen();
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_box),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Wallet"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                       return AddressPage();

                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.help),
                            SizedBox(
                              width: 20,
                            ),
                            Text("My Wallet Address"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HelpPage();
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.help),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Help/Support"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PolicyPage();
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.security),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Policies"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Share.share(Constants.share_link);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.share),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Share App"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    _signOut(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.signOutAlt),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Log Out"),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
