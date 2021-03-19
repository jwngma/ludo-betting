import 'dart:io';

import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ludobettings/games/live/LiveEventsPage.dart';
import 'package:ludobettings/games/live/MyLiveContestPage.dart';
import 'package:ludobettings/games/my_contest/MyContestPage.dart';
import 'package:ludobettings/games/result/ResultPage.dart';
import 'package:ludobettings/games/upcoming/Dashboard.dart';
import 'package:ludobettings/screens/about_us.dart';
import 'package:ludobettings/screens/policy_page.dart';
import 'package:ludobettings/screens/redeem_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ludobettings/wallet/SuccesfulPurchase.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'account_page.dart';
import 'help_page.dart';
import 'notification_page.dart';
import 'package:rating_dialog/rating_dialog.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "HomePage";
  final titles = ['Dashboard', 'Live', 'My Contests', "Results"]; //'Events',
  final colors = [
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.orange,
  ];
  final icons = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.diceOne,
    FontAwesomeIcons.ticketAlt,
    FontAwesomeIcons.rProject
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  Future<void> _signOut(BuildContext context) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    await progressDialog.show();
    try {
      final auth = Provider.of<FirebaseAuthServices>(context, listen: false);
      GoogleSignIn _googleSignIn = GoogleSignIn();

      if (_googleSignIn != null) {
        print("Google is called");
        await auth.signOutWhenGoogle();
        progressDialog.hide();
      } else {
        print("Auth is Called");
        await auth.signOut();
        progressDialog.hide();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  void dispose() {
    _menuPositionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  final List<Widget> _screens = [
    new DashboardPage(),
    new LiveEventsScreen(),
    new MyContestsScreen(),
    new ResultsScreen()
  ];
  String app_bar_title = "Ludo Contest";

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      if (newVersion < currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available, They have added some more interesting faeatures. please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(Constants.app_link),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(Constants.app_link),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }

  void _showRatingDialog() {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            icon: Image.asset(
              "assets/images/app_logo.jpg",
              fit: BoxFit.contain,
              height: 50,
            ),
            // set your own image/icon widget
            title: " Rating Dialog",
            description:
                "Tap a star to set your rating. Add more description here if you want.",
            submitButton: "SUBMIT",
            alternativeButton: "Contact us instead?",
            // optional
            positiveComment: "We are so happy to hear :)",
            // optional
            negativeComment: "We're sad to hear :(",
            // optional
            accentColor: Colors.red,
            // optional
            onSubmitPressed: (int rating) {
              print("onSubmitPressed: rating = $rating");
              _launchURL(Constants.app_link);
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HelpPage();
              }));
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(Constants.app_name),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NotificationPage();
                  }));
                }),
            SizedBox(
              width: 10,
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: BubbledNavigationBar(
              controller: _menuPositionController,
              initialIndex: 1,
              itemMargin: EdgeInsets.symmetric(horizontal: 8),
              defaultBubbleColor: Colors.red,
              backgroundColor: Colors.grey[800],
              onTap: (index) {
                print(index.toString());
                _pageController.animateToPage(index,
                    curve: Curves.easeInOutQuad,
                    duration: Duration(milliseconds: 200));
              },
              items: widget.titles.map((title) {
                var index = widget.titles.indexOf(title);
                var color = widget.colors[index];
                return BubbledNavigationBarItem(
                  icon: getIcon(index, color),
                  activeIcon: getIcon(index, Colors.white),
                  bubbleColor: color,
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
          },
          child: PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: (page) {
              print(page);
              setState(() {
                switch (page) {
                  case 0:
                    app_bar_title = "Ludo Contest";
                    break;
                  case 1:
                    app_bar_title = "Live";
                    break;
                  case 2:
                    app_bar_title = "My Contest";
                    break;
                  default:
                    app_bar_title = "Results";
                    break;
                }
              });
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  Constants.app_name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  "Play more Earn more",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                currentAccountPicture: new CircleAvatar(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(Constants.app_logo),
                  ),
                  backgroundColor: Colors.greenAccent,
                ),
              ),
              ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("My Contest"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyLiveContestPage();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AccountScreen();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Wallet"),
                leading: Icon(Icons.account_balance_wallet),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RedeemScreen();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("About us"),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AboutUsScreen();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Policies"),
                leading: Icon(Icons.security),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PolicyPage();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Help"),
                leading: Icon(Icons.help),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HelpPage();
                  }));
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Rate The App"),
                leading: Icon(Icons.help),
                onTap: () {
                  Navigator.of(context).pop();
                  _showRatingDialog();
                },
              ),
              ListTile(
                title: Text("Join Telegram Group"),
                leading: Icon(FontAwesomeIcons.telegram),
                onTap: () {
                  Navigator.of(context).pop();
                  _launchURL("https://www.telegram.me/ludofantasy2021");
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Share App"),
                leading: Icon(Icons.share),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.share(Constants.share_link);
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
              ListTile(
                title: Text("Logout"),
                leading: Icon(FontAwesomeIcons.signOutAlt),
                onTap: () {
                  Navigator.of(context).pop();
                  _signOut(context);
                },
              ),
              Divider(
                height: 1,
                color: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(widget.icons[index], size: 30, color: color),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
