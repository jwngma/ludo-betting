import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {


    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Widget socialActions(context) => FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
  /*        IconButton(
            icon: Icon(FontAwesomeIcons.facebookF),
            onPressed: () async {
              await _launchURL("https://facebook.com/");
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.youtube),
            onPressed: () async {
              await _launchURL("https://youtube.com/");
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.whatsapp),
            onPressed: () async {
              await _launchURL("https://whatsapp.com/");
            },
          ),*/
          IconButton(
            icon: Icon(FontAwesomeIcons.envelope),
            onPressed: () async {
              var emailUrl =
              '''mailto:ludofantasy2021@gmail.com?subject=Support Needed For Ludo Contest&body=""''';
              var out = Uri.encodeFull(emailUrl);
              await _launchURL(out);
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.red),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child:


                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.greenAccent,
                        child: Image.asset(
                          Constants.app_logo,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      ),
                    ),
                  ),
                  AutoSizeText(
                    Constants.app_name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "About ${Constants.app_name} App",
                maxLines: 2,
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Constants.desc_about_app,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Constants.contaxt_us,
                textAlign: TextAlign.center,
              ),
            ),
            socialActions(context),
          ],
        ),
      ),
    );
  }
}
