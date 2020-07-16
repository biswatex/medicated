import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicated/components/Customloder.dart';
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
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Details(docId: snapshot.data[index].data['doctorID'],appoId: snapshot.data[index].data['uid'],)));
                    },
                    child: GFListTile(
                      title: Text(snapshot.data[index].data['time']),
                      subTitle: Text("Doctor Name : "+snapshot.data[index].data['doctorName']),
                      description: Text("Token No : "+snapshot.data[index].data['tokenNo'].toString()),
                      icon: Icon(Icons.access_time),
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
    );
  }
}
class Details extends StatefulWidget {
  final docId;
  final appoId;
  const Details({Key key, this.docId, this.appoId}) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Completer<GoogleMapController> _controller = Completer();
  getData() async{
    DocumentSnapshot q = await Firestore.instance.collection('doctors')
        .document(widget.docId).get();
    return q;
  }
  getAppo() async{
    DocumentSnapshot e = await Firestore.instance.collection('doctors')
        .document(widget.docId).collection("Bookings").document(widget.appoId).get();
    return e;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
           if(snapshot.connectionState != ConnectionState.waiting) {
             if (snapshot.hasData) {
               return Container(
                 padding: EdgeInsets.symmetric(horizontal:8),
                 child: ListView(
                   children: [
                     ListTile(
                         title:Text("Doctor Name : "+snapshot.data['name']),
                       subtitle: Text("Location") ,
                     ),
                     Container(
                       padding: EdgeInsets.all(20),
                       height: 300,
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
                         onMapCreated: (
                             GoogleMapController controller) {
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
           }else{
             return Container(
               child: ColorLoader(),
             );
           }
        }
      ),
    );
  }
}

