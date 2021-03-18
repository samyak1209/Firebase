import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/Login/auth.dart';
import 'package:task1/components/HomePage.dart';

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
                  labelText: 'Enter Email'
              ),
              keyboardType: TextInputType.emailAddress,
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


            ),),
          RaisedButton(
            child: Text('LogIn'),
            onPressed: () async {
              if (_formKey.currentState.validate()){
                dynamic result=await _authService.signInWithEmailAndPassword(email.text, pass.text);
                /*if(result!=null){
                  SharedPreferences pref= await SharedPreferences.getInstance();
                  pref.setString('email', email.text);
                  setState(() {
                    Login=true;
                  });
                  if(Login){
                    //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomePage()));
                    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomePage()), (route) => false);
                  }
                }*/
                if (result == null) {
                  print('Errorrr');
                } else {
                  SharedPreferences pref= await SharedPreferences.getInstance();
                  pref.setString('email', email.text);
                  setState(() {
                    Login=true;
                  });
                  Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomePage()), (route) => false);
                }
              }
            },)

        ],
      ),),)
    );
  }
}
