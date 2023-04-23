import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:moneytracker_app/appdata.dart';
import 'package:moneytracker_app/pages/homepage.dart';
import 'package:moneytracker_app/pages/loading_page.dart';
import 'package:moneytracker_app/pages/login_page.dart';
import 'package:moneytracker_app/services/firestore.dart';
import 'package:moneytracker_app/services/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBCdQO-RdUftZgjrETFGzaFEIIzvRFcGKg",
          appId: "1:69696671792:web:64b22dadcb8024d3529df5",
          messagingSenderId: "69696671792",
          projectId: "moneytracker-e78eb"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    AppData.startDate = DateTime.now();
    if (AppData.startDate.month < 10) {
      AppData.startDate = DateTime.parse(
          "${AppData.startDate.year}-0${AppData.startDate.month}-01");
    } else {
      AppData.startDate = DateTime.parse(
          "${AppData.startDate.year}-${AppData.startDate.month}-01");
    }
    AppData.endDate = Jiffy(Jiffy(AppData.startDate).add(months: 1).dateTime)
        .subtract(days: 1)
        .dateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSigninProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Money Tracker',
          theme: ThemeData(
            primarySwatch: AppData.primaryColor,
            textTheme: GoogleFonts.kanitTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage();
              } else if (snapshot.hasData) {
                AppData.userID = FirebaseAuth.instance.currentUser!.uid;
                AppData.userDisplayName = FirebaseAuth.instance.currentUser!.displayName!;
                FireStore.createUser();
                return Homepage();
              } else {
                return LogInPage();
              }
            },
          )),
    );
  }
}
