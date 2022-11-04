import 'package:flutter/material.dart';
import 'package:moneytracker_app/pages/homepage.dart';
import 'package:page_transition/page_transition.dart';

import '../appdata.dart';

class AppDrawer extends StatelessWidget {
  final int pageIndex;
  const AppDrawer({Key? key, required this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        child: Column(
          children: [
            const DrawerProfile(),
            const SizedBox(
              height: 24,
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            DrawerRow(
              iconData: Icons.wallet_rounded,
              text: "Transactions",
              onTap: () {
                if (pageIndex == 0) {
                  Navigator.pop(context);
                  return;
                }
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: Homepage(),
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 300)));
              },
            ),
            DrawerRow(iconData: Icons.book, text: "Reports", onTap: () {}),
            DrawerRow(iconData: Icons.settings, text: "Settings", onTap: () {})
          ],
        ),
      ),
    );
  }
}

class DrawerProfile extends StatelessWidget {
  const DrawerProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: Colors.black)),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.black,
            size: 56,
          ),
        ),
        Text(
          AppData.username,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class DrawerRow extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  const DrawerRow(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 32,
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
