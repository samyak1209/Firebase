import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task1/util/ProgressIndicator.dart';

class UpdateData extends StatefulWidget {
  final docid;
  final String id;
  final String userid;
  final String detail;
  final String type;
  final String createDate;
  UpdateData({this.id,this.userid,this.type,this.detail,this.createDate,this.docid});

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController id=TextEditingController();
  TextEditingController detail=TextEditingController();
  TextEditingController type=TextEditingController();
  DateTime time=DateTime.now();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;


  @override
  void initState() {
    setState(() {
      id.text=widget.id;
      detail.text=widget.detail;
      type.text=widget.type;
    });
    _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
    var android=AndroidInitializationSettings('mipmap/ic_launcher');
    var ios =IOSInitializationSettings();
    var init=InitializationSettings(android: android,iOS: ios);
    _flutterLocalNotificationsPlugin.initialize(init);
  }

  void _onPressedUpdate() {
    firestoreInstance
        .collection("data")
        .doc(widget.docid)
        .update({
        "detail" : detail.text,
        "type" : type.text,
        "createDate" : time,
        "userid":widget.userid,
      }).then((_) {
      print("success!");
    });
    Navigator.pop(context);
    showNotification();
  }

  showNotification() async {
    var android =AndroidNotificationDetails("id","name","description");
    var ios= IOSNotificationDetails();
    var platform=NotificationDetails(android: android,iOS: ios);
    await _flutterLocalNotificationsPlugin.show(0,"Data","Data updated successfully", platform);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(padding: EdgeInsets.only(bottom: 10,top: 30),
              child: TextFormField(
                controller: id,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter id'
                ),
                keyboardType: TextInputType.name,
              ),),
            Container(padding: EdgeInsets.only(bottom: 10,top: 10),
              child: TextFormField(
                controller: detail,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter detail'
                ),
                keyboardType: TextInputType.name,
              ),),
            Container(padding: EdgeInsets.only(bottom: 10,top: 10),
              child: TextFormField(
                controller: type,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter type'
                ),
                keyboardType: TextInputType.name,
              ),),
            RaisedButton(
              onPressed: _onPressedUpdate,
              child: Text('Update Data'),
            ),

          ],),
        ),
      ),
    );
  }
}
