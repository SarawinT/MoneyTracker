import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/services/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../appdata.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    double buttonPadding = MediaQuery.of(context).size.width * 0.10;
    return SizedBox.expand(
      child: Container(
        color: AppData.primaryColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.wallet,
            color: Colors.white,
            size: 96,
          ),
          Text(
            "Money Tracker",
            style: GoogleFonts.kanit(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 36),
          ),
          const SizedBox(
            height: 48,
          ),
          Padding(
            padding: EdgeInsets.only(left: buttonPadding, right: buttonPadding),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start using this app by: ",
                          style: GoogleFonts.kanit(
                              color: Color(0xFF494949),
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSigninProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // Background color
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Link to GitHub issue report
                        },
                        child: Text(
                          "Having problems?",
                          style: GoogleFonts.kanit(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
          ),
        ]),
      ),
    );
  }
}
