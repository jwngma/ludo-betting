import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ludobettings/utils/Constants.dart';


class PolicyPage extends StatefulWidget {
  static const String routeName = "/PolicyPage";
  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Policies "),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Privacy Policy",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.privacy),
              SizedBox(
                height: 5,
              ),
              Text("Information Collection and Use",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.information_collection),
              SizedBox(
                height: 5,
              ),
              Text("Log Data",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.log_data),
              SizedBox(
                height: 5,
              ),
              Text("Cookies",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.cookies),
              SizedBox(
                height: 5,
              ),
              Text("Service Providers",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.services_provider),
              SizedBox(
                height: 5,
              ),
              Text("Security",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.security),
              SizedBox(
                height: 5,
              ),
              Text("Links to Other Sites",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.links_to_ohters),
              SizedBox(
                height: 5,
              ),
              Text("Changes to This Privacy Policy",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.changes_to_policies),
              SizedBox(
                height: 5,
              ),
              Text("Contact Us",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.oranienbaum(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(Constants.contact_us),
            ],
          ),
        ),
      ),
    );
  }
}
