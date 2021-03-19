import 'package:flutter/material.dart';
import 'package:ludobettings/inapp_purchase/CoinStoreNewPage.dart';
import 'package:ludobettings/screens/account_page.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/screens/profile_page.dart';
import 'package:ludobettings/screens/redeem_page.dart';
import 'package:ludobettings/screens/signup_page.dart';
import 'package:ludobettings/screens/splash_screen_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'auth_widget_builder.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthServices>(
      create: (_) => FirebaseAuthServices(),
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.indigo,
                primaryColor: Colors.deepPurpleAccent),
            routes: {
              HomePage.routeName: (context) => HomePage(),
              SignUpPage.routeName: (context) => SignUpPage(),
              AccountScreen.routeName: (context) => AccountScreen(),
              CoinStoreNewPage.routeName: (context) => CoinStoreNewPage(),
              ProfilePage.routeName: (context) => ProfilePage(),
              RedeemScreen.routeName: (context) => RedeemScreen(),
            },
            home: SplashScreenPage(userSnapshot: userSnapshot)
            );
      }),
    );
  }
}
