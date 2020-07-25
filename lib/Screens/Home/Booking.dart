import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:medicated/Screens/profile/MyAppointment.dart';
import 'package:medicated/components/Customloder.dart';
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
  Future futureData;
  initState(){
    super.initState();
    futureData = getData();
  }
  getData() async {
    QuerySnapshot s = await Firestore.instance.collection('doctors').document(widget.docId).collection('Appointments').getDocuments();
    return s.documents;
  }
  void displayBottomSheet(BuildContext context,appoId,startTime,endTime,snapshot,confirmBooked,docId,docName,fees) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25)),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.7,
              child: ConfirmBooking(appoId: appoId,startTime:startTime,endTime:endTime,snapshot: snapshot,conf: confirmBooked,docId:docId, docName: docName,fees:fees,));
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
          child:Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text("Available Dates",style: TextStyle(fontFamily: 'Museo'),)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 300,
                    child:
                    FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                         if(snapshot.hasError || !snapshot.hasError) {
                           if (snapshot.connectionState != ConnectionState.waiting) {
                             return ListView.builder(
                                 itemCount: snapshot.data.length,
                                 itemBuilder: (_, i) {
                                   if (snapshot.data[i]
                                       .data['maxBooking'] >
                                       snapshot.data[i]
                                           .data['ConfirmBooked']) {
                                     return GestureDetector(
                                       onTap: () {
                                         displayBottomSheet(
                                             context,
                                             snapshot.data[i].data['uid'],
                                             snapshot.data[i].data['StartTime'],
                                             snapshot.data[i].data['EndTime'],
                                             widget.snapshot,
                                             snapshot.data[i].data['ConfirmBooked'],
                                             widget.docId,
                                             widget.docName,
                                             snapshot.data[i].data['fees']
                                         );
                                       },
                                       child: Card(
                                         child: ListTile(
                                           title: Text(
                                               DateFormat.MMMd().add_jm()
                                                   .format(snapshot.data[i]
                                                   .data['StartTime']
                                                   .toDate())
                                                   .toString() + " - " +
                                                   DateFormat().add_jm()
                                                       .format(
                                                       snapshot.data[i]
                                                           .data['EndTime']
                                                           .toDate())
                                                       .toString()),
                                           subtitle: Text((snapshot.data[i]
                                               .data['maxBooking'] -
                                               snapshot.data[i]
                                                   .data['ConfirmBooked'])
                                               .toString() +
                                               " Sit's Available"),
                                           trailing: GestureDetector(
                                             onTap: () {},
                                             child: Text("book",
                                               style: TextStyle(
                                                   color: Colors.teal),),
                                           ),
                                         ),
                                       ),
                                     );
                                   } else {
                                     return Container(
                                         alignment: Alignment.center,
                                         child: Image(image: AssetImage(
                                             'assets/images/notFound.png'))
                                     );
                                   }
                                 }
                             );
                           } else {
                             return Container(
                                 alignment: Alignment.center,
                                 child: ColorLoader()
                             );
                           }
                         }else {
                           return Container(
                               alignment: Alignment.center,
                               child: Image(image: AssetImage(
                                   'assets/images/notFound.png'))
                           );
                         }
                      }
                    )
                    ),
            ],
          ),
    ),
    );
  }
}
class ConfirmBooking extends StatefulWidget {
  final appoId;
  final startTime;
  final endTime;
  final snapshot;
  final conf;
  final docId;
  final docName;
  final fees;

  const ConfirmBooking({Key key, this.appoId, this.snapshot, this.conf, this.docId, this.docName,this.fees, this.startTime, this.endTime}) : super(key: key);
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
            subtitleText: "Be there within " + widget.startTime.toString(),
            description: Text("Token no : " + (widget.conf + 1).toString()),
          ),
          GFListTile(
            title: Text("Doctor Name : " + widget.snapshot.data['name']),
            subtitleText: widget.snapshot.data['Department'],
            description: Text("Fees : "+widget.fees.toString()),
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
                      widget.startTime,
                      widget.endTime,
                      widget.docId,
                      widget.conf + 1,
                      widget.docName,
                      user,
                      widget.fees) : null,
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

  bookingFunction(context, appoUid, startTime,endTime, docId, tokenNo, docName,
      userId,fees) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString()+userId;
    await Firestore.instance.collection('user')
        .document(userId)
        .collection('appointments')
        .document(id)
        .setData(
        {
              'uid': appoUid,
              'StartTime': startTime,
              'EndTime':endTime,
              'doctorID': docId,
              'doctorName': docName,
              'tokenNo': tokenNo,
              'fees': fees,
              'documentId':id
        }
    ).then((value) =>
        Firestore.instance.collection("doctors")
            .document(docId)
            .collection("Bookings")
            .document(id)
            .setData(
            {
              'documentId':id,
              'time': startTime,
              'uid': appoUid,
              'User': userId,
              'tokenNo':tokenNo,
              'fees': fees,
            }
        )).then((value) =>
        Firestore.instance.collection('doctors')
            .document(docId)
            .collection('Appointments')
            .document(appoUid).get().then((value) =>
            {
              if(value.data['maxBooking']>value.data['ConfirmBooked']){
                Firestore.instance.collection('doctors')
                    .document(docId)
                    .collection('Appointments')
                    .document(appoUid).
                updateData({'ConfirmBooked':value.data['ConfirmBooked']+1,})
                    .then((value) => {showAlertDialog(context)})
              }else{
                    showErrorAlertDialog(context)
              }
            }
        )
    );
  }
  showErrorAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 200,
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/error.gif')),
            AutoSizeText(
              "Booking Canceled",
              style:TextStyle(fontFamily: 'Museo',color: Colors.red,fontWeight:FontWeight.bold),
              maxLines: 1,
            ),
            Text(
              "No sits available",
              style:TextStyle(fontSize: 10,fontFamily: 'Museo',color: Colors.grey,fontWeight:FontWeight.normal),
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
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 180,
        width:100,
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
                builder:(BuildContext context) => MyAppointment(fromDrawer:false)));
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

