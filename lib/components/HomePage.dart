import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/Login/Signup.dart';
import 'package:task1/Login/auth.dart';
import 'package:task1/analytics/Analytics.dart';
import 'package:task1/components/HomeScreen.dart';
import 'package:task1/util/ProgressIndicator.dart';

import 'Form.dart';

class HomePage extends StatefulWidget {
  final uid;
  HomePage({this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  int curindex=0;

  @override
  Widget build(BuildContext context) {
    final tabs=[HomeScreen(),FormPage(uid:widget.uid,)];
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () async {
            ProgressHelper.displayProgressDialog(context);
            AuthService().signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('email');
            prefs.remove('uid');
            Analytics.analytics.logEvent(name: "logout",parameters: {"app_bar":"logout_button"});
            ProgressHelper.closeProgressDialog(context);
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Signup()));
          })
        ],
      ),
      body: tabs[curindex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
            curindex=index;
            Analytics.analytics.logEvent(name: curindex==0?"home_screen":"form_screen",parameters: {"homepage":"after_auth"});
          });},
          currentIndex: curindex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),

            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.text_format),
                title: Text('Enter Text')
            ),
          ],
    ),

    );
  }
}
