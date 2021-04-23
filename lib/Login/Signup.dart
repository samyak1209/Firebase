import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/Login/SignIn.dart';
import 'package:task1/analytics/Analytics.dart';
import 'package:task1/components/HomePage.dart';
import 'package:task1/util/ProgressIndicator.dart';

import 'auth.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _iButt=true;
  TextEditingController name=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController pass=new TextEditingController();
  bool button=false;
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool Login=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Container(padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child:Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.only(bottom: 20,top: 50),
            child: TextFormField(
              controller: name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter name'
            ),
            keyboardType: TextInputType.name,
              validator: validateName,
              autovalidateMode: AutovalidateMode.onUserInteraction,

          ),),
          Container(padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: email,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Email'
              ),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,autovalidateMode: AutovalidateMode.onUserInteraction,
            ),),
          Container(padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _iButt?
                    (Icons.visibility_off):
                    (Icons.visibility)
                  ),
                  onPressed: (){
                    setState(() {
                      _iButt=!_iButt;
                    });
                  },
                )
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _iButt,
              validator: validatePass,autovalidateMode: AutovalidateMode.onUserInteraction,
            ),),
          RaisedButton(
            disabledColor: Colors.grey,
          color: Colors.green,
          onPressed: () async {
              ProgressHelper.displayProgressDialog(context);
              if(_formKey.currentState.validate()){
                await _auth.registerWithEmailAndPassword(email.text, pass.text,name.text).then((value) async {
                print('signed in as ${value.uid}');
                /*var userUpdateInfo = new UserUpdateInfo();
                userUpdateInfo.displayName=name.text;*/

                /*print(userUpdateInfo.displayName);
                await user1.updateProfile(userUpdateInfo); *///update the info
                //await value.reload();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', email.text);
                //print(value.uid.toString());
                prefs.setString('uid', value.uid.toString());
                setState(() {
                  Login=true;
                });
                if(Login){
                  Analytics.analytics.logEvent(name: "home_page",parameters: <String,dynamic>{});
                  ProgressHelper.closeProgressDialog(context);
                  Navigator.pushReplacement(context,MaterialPageRoute(
                      builder:(context)=>HomePage(),
                    settings: RouteSettings(name: "HomePage")
                  ));
                }
                }).catchError((e){
                  print(e);
                });
              }},
            child: Text('SignUp'),
          ),
          Container(padding: EdgeInsets.only(top: 10),
          child: FlatButton(child: Text('LogIn'),
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context)=>SignIm()));
          },),)

        ],
      ),),
      ),
    );
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
  }
  String validateName(String value){
    if(value.isEmpty){return 'Please Enter Valid Name';}
    else if(value.startsWith(" ")){return 'Please Check Again';}
    else if(value.length>30){return 'Length Should not exceed 30';}

  }
  String validatePass(String value){
    if(value.isEmpty){return 'Please Enter Password';}
    else if(value.length>6){return 'Please Enter Short Password';}
  }
}
