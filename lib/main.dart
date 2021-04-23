import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/Login/Signup.dart';
import 'package:task1/analytics/Analytics.dart';
import 'package:task1/components/HomePage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var Uid = prefs.getString('uid');
  print(email);
  print(Uid.toString());
  runApp(MaterialApp(home: email == null ? MyApp() : HomePage(uid: Uid.toString(),)));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Signup(),
      navigatorObservers: [Analytics.observer],
      debugShowCheckedModeBanner: false,
    );
  }
}

class UIDUser {
  final String uid;
  UIDUser({ this.uid });

}

