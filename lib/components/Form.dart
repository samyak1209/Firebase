import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final uid;
  FormPage({this.uid});
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController id=TextEditingController();
  TextEditingController detail=TextEditingController();
  TextEditingController type=TextEditingController();
  DateTime time=DateTime.now();

  void _onPressed() {
    firestoreInstance.collection("data").add(
        {
          "detail" : detail.text,
          "id":id.text,
          "type" : type.text,
          "createDate" : time,
          "userid":widget.uid,
        }).then((value){
      print(value.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(padding: EdgeInsets.only(left: 10,right: 10),
        child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                    labelText: 'Enter Detail'
                ),
                keyboardType: TextInputType.name,
              ),),
            Container(padding: EdgeInsets.only(bottom: 10,top: 10),
              child: TextFormField(
                controller: type,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Type'
                ),
                keyboardType: TextInputType.name,
              ),),
            RaisedButton(
              onPressed: _onPressed,
              child: Text('Post Data'),
            ),
          ],
        ),
      ),),
    );
  }
}
