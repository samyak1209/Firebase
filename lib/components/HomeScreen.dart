import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task1/components/Update.dart';
import 'package:task1/util/ProgressIndicator.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  int curindex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(height: MediaQuery.of(context).size.height*0.8,
            child: StreamBuilder(
              stream: firestoreInstance.collection("data").snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot products = snapshot.data.documents[index];
                      //DocumentSnapshot docSnap = products.get(FieldPath.documentId);
                      /*var doc_id2 = docSnap.reference.id;
                      print(doc_id2);*/
                      //var doc_id=products.get();
                      //var doc_id=firestoreInstance.collection("data").get();
                      //print(doc_id);
                      //DateTime s=DateTime.parse(products['createdDate'].toString());
                      //String format1 = DateFormat('d-MMMM-yyyy HH:mm a ').format(s);
                      return InkWell(
                        child: Card(
                          child: Container(padding: EdgeInsets.all(15),
                            child: Row(children: [
                              Container(child: Column(children: [
                                Text(products['id'].toString()),
                                Text(products['userid']),
                                Text(products['detail']),
                                //Text(format1),
                              ],crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,),width: MediaQuery.of(context).size.width*0.4,),
                              InkWell(child: Container(padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                                color: Colors.grey,
                                child: Center(child: Text(products['type']),),
                              ),onTap: products['type'].toString().contains(pattern)?
                              ( null):
                              (null))
                            ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                          ),
                        ),
                        onTap:(){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>UpdateData(
                          docid: products.id,
                          id: products['id'].toString(),
                          userid: products['userid'].toString(),
                          detail: products['detail'].toString(),
                          createDate: products['createDate'].toString(),
                          type: products['type'].toString(),
                        )));},
                        onLongPress: (){
                          showDialog(context: context,
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Center(child: Container(color: Colors.white,height: 100,
                                child: Column(
                                  children: [
                                    Align(alignment: Alignment.centerRight,child: GestureDetector(child: Icon(Icons.cancel),onTap: (){Navigator.pop(context);},),),
                                   FlatButton(child: Text("Delete Entry",style: TextStyle(color: Colors.red),),
                                   onPressed: (){
                                     firestoreInstance.collection("data").doc(products.id).delete();
                                     Navigator.pop(context);
                                   },)
                                  ],
                                ),),),
                              ));
                        },
                      );
                    },
                  );
                }
                else if(snapshot.hasError){
                  print('error');
                  return null;
                }
                else{
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          )
        ],),
      ),

    );
  }
}