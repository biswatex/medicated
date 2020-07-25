import 'dart:async';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicated/components/CustomKFDrawer.dart';
import 'package:medicated/components/Customloder.dart';

class MyAppointment extends KFDrawerContent {
  final bool fromDrawer;
  MyAppointment({this.fromDrawer});
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
  Future<bool> _onBackPressed() {
    if (widget.fromDrawer == true) {
      return showDialog(
        context: context,
        builder: (context) =>
        new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("YES"),
            ),
          ],
        ),
      ) ??
          false;
    }else{
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              if (widget.fromDrawer == true) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: widget.onMenuPressed,);
              }else{
                return IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed:(){Navigator.pop(context);},);
              }
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.waiting){
              return ListView.builder(
                itemCount: snapshot.data.length,
                  itemBuilder: (_,index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Details(docId: snapshot.data[index].data['doctorID'],appoSnap: snapshot.data[index],)));
                      },
                      child: Card(
                        elevation:3,
                        child: GFListTile(
                          title: Text(snapshot.data[index].data['StartTime'].toString()),
                          subTitle: Text("Doctor Name : "+snapshot.data[index].data['doctorName']),
                          description: Text("Token No : "+snapshot.data[index].data['tokenNo'].toString()),
                          icon: Icon(Icons.access_time),
                        ),
                      ),
                    );
                  }
              );
            }else{
                return Container();
              }
            }
          ),
        ),
      ),
    );
  }
}
class Details extends StatefulWidget {
  final docId;
  final appoSnap;
  const Details({Key key, this.docId, this.appoSnap}) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  bool accepted = true;

  getData() async {
    DocumentSnapshot q = await Firestore.instance.collection('doctors')
        .document(widget.docId).get();
    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: (accepted==true)? FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.hasData|| !snapshot.hasError) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView(
                      children: [
                        GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(snapshot.data['image']),
                            shape: GFAvatarShape.standard,),
                          padding: EdgeInsets.all(0),
                          title: Text("Doctor Name : " + snapshot.data['name'],
                              style: TextStyle(fontFamily: 'Museo')),
                          description: Text(snapshot.data['Department']),
                        ),
                        GFListTile(
                          padding: EdgeInsets.all(0),
                          title: Text("Time : " + widget.appoSnap.data['StartTime'].toString(),
                              style: TextStyle(fontFamily: 'Museo')),
                          subtitleText: "Token No : " +
                              widget.appoSnap.data['tokenNo'].toString(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 3,
                            child: GFListTile(
                              padding: const EdgeInsets.all(0),
                              title: Center(child: Text("Access Code")),
                              subTitle: Center(child: Text("5467",
                                  style: TextStyle(
                                      fontFamily: 'Museo', fontSize: 22)),),
                            ),
                          ),
                        ),
                        GFListTile(
                          padding: EdgeInsets.all(0),
                          subtitleText: "Mankundu",
                          title: Text(
                              "Location", style: TextStyle(fontFamily: 'Museo')),
                          description: Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: GoogleMap(
                              liteModeEnabled: true,
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      snapshot.data['address']['geopoint']
                                          .latitude,
                                      snapshot.data['address']['geopoint']
                                          .longitude), zoom: 15),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              markers: ({Marker(
                                markerId: MarkerId(snapshot.data['name']),
                                position: LatLng(
                                    snapshot.data['address']['geopoint']
                                        .latitude,
                                    snapshot.data['address']['geopoint']
                                        .longitude),
                                infoWindow: InfoWindow(title: snapshot
                                    .data['name']),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueViolet,
                                ),
                              )}),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GFButton(
                                size: GFSize.LARGE,
                                      onPressed: () {
                                        Event event = Event(
                                          title: 'You Have a appointment',
                                          description: 'Doctor name '+widget.appoSnap.data['doctorName'],
                                          location: 'Medicative',
                                          startDate: DateTime.fromMicrosecondsSinceEpoch(widget.appoSnap.data['StartTime'].microsecondsSinceEpoch),
                                          endDate: DateTime.fromMicrosecondsSinceEpoch(widget.appoSnap.data['EndTime'].microsecondsSinceEpoch),
                                          allDay: false,
                                        );
                                        Add2Calendar.addEvent2Cal(event).then((success) {
                                          scaffoldState.currentState.showSnackBar(
                                              SnackBar(content: Text(success ? 'Success' : 'Error')));
                                        });
                                      },
                                      color: Colors.green,
                                      child: Text("Add to calender",
                                          style: TextStyle(fontFamily: 'Museo',
                                              color: Colors.white)),),
                              SizedBox(width:10,),
                              GFButton(
                                size: GFSize.LARGE,
                                onPressed: () {
                                  cancelFunction(context, widget.appoSnap.data['uid'],widget.appoSnap.data['documentId'], widget.docId);
                                },
                                color: Colors.redAccent,
                                child:Text("Cancel Appointment",
                                          style: TextStyle(fontFamily: 'Museo',
                                              color: Colors.white)),),

                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                      alignment: Alignment.center,
                      child: Image(image: AssetImage(
                          'assets/images/notFound.png'))
                  );
                }
              } else {
                return Container(
                  child: ColorLoader(),
                );
              }
            }
        ):Container(
            alignment: Alignment.center,
            child: Image(image: AssetImage(
                'assets/images/notFound.png'))
        ),
      ),
    );
  }
  cancelFunction(context,appoUid, documentUid, docId) async => await
    FirebaseAuth.instance.currentUser().then((value) =>
    Firestore.instance.collection('user')
        .document(value.uid)
        .collection('appointments').document(documentUid).delete()
        .whenComplete(() =>
        Firestore.instance.collection('doctors')
            .document(docId)
            .collection('Appointments')
            .document(appoUid).get().then((value) =>
        {
          if(value.data['maxBooking']>value.data['ConfirmBooked']){
            Firestore.instance.collection('doctors')
                .document(docId)
                .collection('Appointments')
                .document(appoUid)
                .updateData({'ConfirmBooked':value.data['ConfirmBooked']-1,})
                .whenComplete(() =>
                Firestore.instance.collection('doctors')
                    .document(docId)
                    .collection('Bookings')
                    .document(documentUid).delete()
                    .whenComplete(() => {showAlertDialog(context)}))
          }else{
            print("error")
          }
        })
    ));
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 180,
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/delete.gif')),
            Text(
              "Booking Cancelled\nSuccessfully",
              style: TextStyle(fontFamily: 'Museo',
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
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
            Navigator.pop(context);
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

