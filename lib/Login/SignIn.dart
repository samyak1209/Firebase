import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/Login/Signup.dart';
import 'package:task1/Login/auth.dart';
import 'package:task1/analytics/Analytics.dart';
import 'package:task1/components/HomePage.dart';
import 'package:task1/util/ProgressIndicator.dart';

class SignIm extends StatefulWidget {
  @override
  _SignImState createState() => _SignImState();
}

class _SignImState extends State<SignIm> {
  bool _iButt=true;
  TextEditingController email=new TextEditingController();
  TextEditingController pass=new TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool Login=false;
  String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: Container(padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: email,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Email',
              ),
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              validator: validatePass,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),),
          RaisedButton(
            child: Text('LogIn'),
            onPressed: () async {
              ProgressHelper.displayProgressDialog(context);
              if (_formKey.currentState.validate()){
                dynamic result=await _authService.signInWithEmailAndPassword(email.text, pass.text).then((value) async {
                  if (value == null) {
                    print('Errorrr');
                    ProgressHelper.closeProgressDialog(context);
                  } else {
                    SharedPreferences pref= await SharedPreferences.getInstance();
                    pref.setString('email', email.text);
                    print(value.uid);
                    pref.setString('uid', value.uid.toString());
                    setState(() {
                      Login=true;
                    });
                    Analytics.analytics.logLogin(loginMethod: "email");
                    ProgressHelper.closeProgressDialog(context);
                    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomePage(uid: value.uid.toString(),)), (route) => false);
                  }
                });

              }
            },)
        ],
      ),),)
    );
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
  }
  String validatePass(String value){
    if(value.isEmpty){return 'Please Enter Password';}
    else if(value.length>6){return 'Please Enter Short Password';}
  }
}
