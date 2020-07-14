import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:medicated/Screens/profile/MyAppointment.dart';
class Booking extends StatefulWidget {
  final snapshot;
  final docId;
  final docName;
  const Booking({Key key, this.snapshot, this.docId, this.docName}) : super(key: key);
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String month;
  List m = new List();
  Future futureData;
  initState(){
    super.initState();
    futureData = getData();
  }
  getData() async {
    DocumentSnapshot s = await Firestore.instance.collection('doctors').document(widget.docId).get();
    setState(() {
      m = s.data['Timings'];
    });
    return s;
  }
  void displayBottomSheet(BuildContext context,appoId,time,snapshot,confirmBooked,docId,docName) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25)),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.7,
              child: ConfirmBooking(appoId: appoId,time: time,snapshot: snapshot,conf: confirmBooked,docId:docId, docName: docName,));
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back_ios,color: Colors.grey),
              onPressed: (){
                Navigator.pop(context);
              }
            );
          },
        ),
        centerTitle: false,
        titleSpacing: 0,
        title:Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical:8.0),
          child: ListTile(
            contentPadding:EdgeInsets.all(0),
            leading: CircleAvatar(backgroundImage:NetworkImage(widget.snapshot.data['image'])),
            title: Text(widget.snapshot.data["name"]),
          ),
        ),
      ),
      body: Container(
          child:(m != null)?Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text("Available Dates",style: TextStyle(fontFamily: 'Museo'),)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 300,
                    child:
                    ListView.builder(
                          itemCount: m.length,
                            itemBuilder: (_,i) {
                              if(m[i]['maxBooking'] > m[i]['ConfirmBooked']){
                                return GestureDetector(
                                  onTap: (){
                                    displayBottomSheet(
                                      context,
                                      m[i]['uid'],
                                      DateFormat.MMMd().add_jm().format(m[i]['EndTime'].toDate()),
                                      widget.snapshot,
                                      m[i]['ConfirmBooked'],
                                      widget.docId,
                                      widget.docName,
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(DateFormat.MMMd().add_jm().format(m[i]['StartTime'].toDate()).toString()+" - "+DateFormat().add_jm().format(m[i]['EndTime'].toDate()).toString()),
                                      subtitle: Text((m[i]['maxBooking']-m[i]['ConfirmBooked']).toString()+" Sit's Available"),
                                      trailing: GestureDetector(
                                        onTap: () {  },
                                        child: Text("book",style: TextStyle(color:Colors.teal),),
                                      ),
                                    ),
                                  ),
                                );
                              }else{
                                return null;
                              }
                            }
                        )
                    ),
            ],
          ):Container(alignment: Alignment.center,child: Text("Doctor Not Added any Appointments yet"),)
    ),
    );
  }
}
class ConfirmBooking extends StatefulWidget {
  final appoId;
  final time;
  final snapshot;
  final conf;
  final docId;
  final docName;
  const ConfirmBooking({Key key, this.appoId, this.time, this.snapshot, this.conf, this.docId, this.docName}) : super(key: key);
  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  bool accepted = false;
  String user;

  @override
  initState() {
    super.initState();
    getUser();
  }

  getUser() {
    FirebaseAuth.instance.currentUser().then((value) =>
    {
      setState(() {
        user = value.uid;
      })
    });
  }

  void _accepted() {
    setState(() {
      accepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      height: height * 0.4,
      child: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              child: Text("Confirm Booking ?", style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Museo'),)),
          GFListTile(
            title: Text("Appointment Id " + widget.appoId.toString()),
            subtitleText: "Be there within " + widget.time.toString(),
            description: Text("Token no : " + (widget.conf + 1).toString()),
          ),
          GFListTile(
            title: Text("Doctor Name : " + widget.snapshot.data['name']),
            subtitleText: widget.snapshot.data['Department'],
            description: Text("Fees : 300"),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Checkbox(
                  activeColor: Colors.teal,
                  value: accepted,
                  onChanged: (bool value) {
                    setState(() {
                      accepted = value;
                    });
                  },
                ),
                Text("Accept Terms & Conditions")
              ],
            ),
          ),
          Container(
            height: height * 0.12,
            child: RaisedButton(
              color: Colors.teal,
              onPressed: accepted
                  ? () =>
                  bookingFunction(
                      context,
                      widget.appoId,
                      widget.time,
                      widget.docId,
                      widget.conf + 1,
                      widget.docName,
                      user) : null,
              child: Text("Confirm Booking", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Museo',
                  color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  bookingFunction(context, appoUid, time, docId, tokenNo, docName,
      userId) async {
    await Firestore.instance.collection('user')
        .document(userId)
        .collection('appointments')
        .add(
        {
              'uid': appoUid,
              'time': time,
              'doctorID': docId,
              'doctorName': docName,
              'tokenNo': tokenNo,
              'fees': 300,

        }
    ).then((value) =>
        Firestore.instance.collection("doctors")
            .document(docId)
            .collection(appoUid)
            .document(value.documentID)
            .setData(
            {
              'time': time,
              'AppointmentUid': appoUid,
              'User': userId,
              'tokenNo':tokenNo,
              'fees': 300,
            }
        )).then((value) =>
    {
      showAlertDialog(context)
    }
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 180,
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/confirmation.gif')),
            AutoSizeText(
              "Booking Confirmed",
              style:TextStyle(fontFamily: 'Museo',color: Colors.teal,fontWeight:FontWeight.bold),
              maxLines: 1,
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            setState(() {
              accepted = false;
            });
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("View"),
          onPressed: () {
            setState(() {
              accepted = false;
            });
            Navigator.push(context, MaterialPageRoute(
                builder:(BuildContext context) => MyAppointment()));
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

