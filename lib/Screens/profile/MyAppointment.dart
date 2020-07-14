import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
class MyAppointment extends StatefulWidget {
  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  Future f;
  getData() async{
    FirebaseUser user =  await FirebaseAuth.instance.currentUser();
    QuerySnapshot q = await Firestore.instance.collection('user')
        .document(user.uid).collection("appointments").getDocuments();
    return q.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: (){Navigator.pop(context);},
            );
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.waiting){
            return ListView.builder(
              itemCount: snapshot.data.length,
                itemBuilder: (_,index){
                  return GFListTile(
                    title: Text(snapshot.data[index].data['time']),
                    subTitle: Text("Doctor Name : "+snapshot.data[index].data['doctorName']),
                    description: Text("Token No : "+snapshot.data[index].data['tokenNo'].toString()),
                    icon: Icon(Icons.access_time),
                  );
                }
            );
          }else{
              return Container();
            }
          }
        ),
      ),
    );
  }
}
