import 'package:flutter/material.dart';
import 'package:ludobettings/models/CoinModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static List<String> withdrawalServices = ["Paytm", "Google Pay"];

  static List<CoinModel> coinList = [
    CoinModel(
        title: "Basic Entry Coin",
        desc: "You Will get 50 Entry Coins",
        coins: 50,
        price: 1),
    CoinModel(
        title: "Bronze Entry Coin",
        desc: "You Will get 100 Entry Coins",
        coins: 100,
        price: 100),
    CoinModel(
        title: "Silver Entry Coin",
        desc: "You Will get 200 Entry Coins",
        coins: 200,
        price: 200),
    CoinModel(
        title: "Gold Entry Coin",
        desc: "You Will get 300 Entry Coins",
        coins: 300,
        price: 300),
    CoinModel(
        title: "Diamond Entry Coin",
        desc: "You Will get 500 Entry Coins",
        coins: 500,
        price: 500),
    CoinModel(
        title: "Platinum Entry Coin",
        desc: "You Will get 1000 Entry Coins",
        coins: 1000,
        price: 1000),
  ];

  static const String app_name = "Ludo Contest";
  static const String desc_about_app =
      '''Ludo Contest is a fun app for Playing Ludo Match .We have developed this application to let the users toparticipate in a ludo match in a fun way. We are planning to add more fun games and events in near future''';
  static List<String> ludoMatchRules = [
    "1. You will get the Reward within 24 hours after the end of the match.",
    "2, Be Attentive to get your room code before 5 to 10 minutes of the match time from the MY PARTICIPATION tab",
    "3. Join the room as soon as Possible to grab your desired place . If you fail to join the room , then admin  will not be responsible for it & refund will not done in this case",
    "4. Use Mobile device only for playing the Match, Anyone found using any hacks or emulators will be banned immediately.",
    "4. Do not share the Room Id and the Room Password with anyone found doing so will be disqualified from the tournament or may be banned.",
    "5 Match will start at the mentioned time, or may start 5-10 mins after the time,but you should join the room on time.",
    "6. If due to your network issues , you get offline during the game, your opponent will win the match, so be carefull with your network",
    " 7. This is  a paid Match, To participate , you have to pay and join the match before the spots are filled.",
    "8. The Entry Fees are for the individual player.",
    "9. Spots are given on first come first serve basis.",
    "10. After Joining the room, do not keep changing the positions, doing so will disturb the admin in maintaining the game, actions will be taken accordingly(probably kick out  from the match",
    "11. You will be awarded for Winning the match , according to the above mentioned.",
    "12. If anyone found Violating the  rules , actions will be taken immediately, or may be after the match accordingly",
    "13. For any queries you contact us, from the help section.",
  ];
  static const String app_version = "1";
  static const String app_color = "#ffd71667";

  static Color primaryAppColor = Colors.white;
  static Color secondaryAppColor = Colors.black;
  static const String google_sans_family = "OpenSans";
  static bool isDebugMode = true;

//Image

  static const String ludo_banner = "assets/images/ludo_banner.png";
  static const String ludo_card_image = "assets/images/ludo_image.png";
  static const String ludo_bannertwo = "assets/images/ludo_banner_two.png";
  static const String ludo_bannerfive = "assets/images/ludo_banner.png";

  static const String profile_icon_placeholder =
      "assets/images/profile_icon.png";
  static const String app_logo = "assets/images/ludo_contest_icon.png";
  static const String nodata_icon = "assets/images/no_data_icon.png";

  //*  Texts
  static const String ludoEvents = "Ludo Events";
  static const String events = "Events";
  static const String participants = "participants";
  static const String winner = "winner";
  static const String ludo = "ludo";

  static const Color darkBG = Color(0xff1F2533);
  static const List<Color> darkBGColors = [darkBG, darkBG];
  static const List<Color> lightBGColors = [
    Color(0xff0D5F64),
    Color(0xff219077),
    Color(0xffA5CDCC)
  ];
  static OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.transparent),
  );
  static const String tournament_text = "Tournaments";
  static const String live_tournaments = "Live Tournaments";
  static const String descText1 =
      ''' Ludo Contest is Ultimate Solution to all your Favorite eSports Games.''';
  static const String share_link =
      "Download the  Ludo Contest App, particpate in  Ludo Tournaments. "
      "We can earn Money by playing the tournament, "
      "for Winning the matches, as Much as You can."
      " Link- https://play.google.com/store/apps/details?id=com.jwngma.ludobettings";
  static const String loading_text = "Loading...";
  static const String try_again_text = "Try Again";
  static const String some_error_text = "Some error";
  static const String signInText = "Sign In";
  static const String signInGoogleText = "Sign in with google";
  static const String signOutText = "Sign Out";
  static const String wrongText = "Something went wrong";
  static const String confirmText = "Confirm";
  static const String supportText = "Support Needed";
  static const String featureText = "Feature Request";
  static const String moreFeatureText = "More Features coming soon.";
  static const String updateNowText =
      "Please update your app for seamless experience.";
  static const String checkNetText =
      "It seems like your internet connection is not active.";
  static const String contaxt_us = "Contact Us";
  static const String app_link =
      "https://play.google.com/store/apps/details?id=com.jwngma.ludobettings";

  static const String loggedInPref = "loggedInPref1";
  static const String uid = "uid";
  static const String name = "name";
  static const String displayNamePref = "displayNamePref";
  static const String emailPref = "emailPref";
  static const String phonePref = "phonePref";
  static const String photoPref = "photoPref";
  static const String isAdminPref = "isAdminPref";
  static const String darkModePref = "darkModePref";

  // game Type
  static const String status_upcoming = "Upcoming";
  static const String status_ended = "Ended";
  static const String status_live = "Live";

  // Firebase Collections
  static const String Users = "Users";

  static const String terms_condition =
      "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore"
      " that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks "
      "in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other "
      "languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property "
      "rights related to it, still belong to The Developer of the App. The Developer of the App is committed to ensuring that the app is as useful and efficient as "
      "possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. "
      "We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for. The Ludo Contest app"
      " stores and processes personal data that you have provided to us,"
      " in order to provide my Service. It’s your responsibility to keep your phone and access to the app secure."
      " We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and "
      "limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious "
      "programs, compromise your phone’s security features and it could mean that the Ludo Contest app won’t work properly or at all. The"
      " app does use third party services that declare their own Terms and Conditions. Link to Terms and Conditions of third party service "
      "providers used by the app \n  1. Google Play Services \n  2. Google Analytics for Firebase \n  3. Firebase Crashlytics "
      "\n  4. Facebook You should be aware that there are certain things that The Developer of the App will not take responsibility for."
      " Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, "
      "or provided by your mobile network provider, but The Developer of the App cannot take responsibility for the app not working at full functionality if "
      "you don’t have access to Wi-Fi, and you don’t have any of your data allowance left. If you’re using the app outside of an area with Wi-Fi, you"
      " should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your "
      "mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app,"
      " you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of"
      " your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re "
      "using the app, please be aware that we assume that you have received permission from the bill payer for using the app. Along the same lines,"
      " The Developer of the App cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – "
      "if it runs out of battery and you can’t turn it on to avail the Service, The Developer of the App cannot accept responsibility. With respect to Jwngma "
      "basumatary’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure "
      "that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. "
      "The Developer of the App accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of"
      " the app. At some point, we may wish to update the app. The app is currently available on Android – the requirements for system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Jwngma basumatary does not promise that it will always update the app so that it is relevant to you and/or works with the Android version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use "
      "of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted "
      "to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device";

  static const String privacy =
      "The Developer of the App built the  Ludo Contest app as a Commercial app. This SERVICE is provided by Jwngma basumatary  and his team and "
      "is intended for use as is. This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal"
      " Information if anyone decided to use my Service. If you choose to use my Service, then you agree to the collection and use of information "
      "in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share"
      " your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in "
      "our Terms and Conditions, which is accessible at  Ludo Contest unless otherwise defined in this Privacy Policy.";
  static const String information_collection =
      "For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information"
      " that I request will be retained on your device and is not collected by me in any way.The app does use third party services that may collect"
      " information used to identify you.Link to privacy policy of third party service providers used by the ap\n 1. Google Play Service"
      "\n 2. Google Analytics for Firebase \n 3.  Firebase Crashlytics \n 4. Facebook";
  static const String log_data =
      "I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.";
  static const String cookies =
      "Cookies are files with a small points of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.";
  static const String services_provider =
      "I may employ third-party companies and individuals due to the following reasons: \n   1. To facilitate our Service; \n   2. To provide the Service on our behalf; \n   3. To perform Service-related services; or \n   4.  To assist us in analyzing how our Service is used. \n I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.";
  static const String security =
      "I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.";
  static const String links_to_ohters =
      "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.";
  static const String changes_to_policies =
      "I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. This policy is effective as of 2020-05-03";
  static const String contact_us =
      "If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at ludofantasy2021@gmail.com.";
}
