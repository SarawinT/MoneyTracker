import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/appdata.dart';
import 'package:moneytracker_app/main.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';

import '../widgets/app_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(title: "Settings"),
      ),
      drawer: const AppDrawer(
        pageIndex: 2,
      ),
      body: ListView(
        children: [
          SizedBox(height: 16,),
          SettingTapButton(
              icon: Icons.exit_to_app,
              title: "Sign out",
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return AlertDialog(
                        title: Text(
                          "Sign out Confirmation",
                          style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
                        ),
                        content: Text(
                          "Are you sure you want to sign out?",
                          style: GoogleFonts.kanit(),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No", style: GoogleFonts.kanit())),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                FirebaseAuth.instance.signOut().then((value) {
                                  AppData.resetUserData();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MyApp()));
                                });
                              },
                              child: Text("Yes", style: GoogleFonts.kanit()))
                        ],
                      );
                    });
              })
        ],
      ),
    );
  }
}

class SettingTapButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final void Function()? onTap;

  SettingTapButton(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onTap,
      this.subTitle = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: subTitle.isEmpty
                  ? Text(
                      title,
                      style: TextStyle(fontSize: 20),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
