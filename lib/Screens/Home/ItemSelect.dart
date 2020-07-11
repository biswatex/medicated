import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicated/components/Customloder.dart';

class Detail extends StatefulWidget {
  final String docID;
  const Detail({Key key, this.docID}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}
class _DetailState extends State<Detail> {
  Completer<GoogleMapController> _controller = Completer();
  DocumentSnapshot snapshot;
  Future f;
  getData() async {
    DocumentSnapshot snapsho = await Firestore.instance.collection('doctors')
        .document(widget.docID)
        .get();
    setState(() {
      snapshot = snapsho;
    });
    return snapshot;
  }
  initState() {
    super.initState();
    f = getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed:(){
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: f,
          builder:(_,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: ColorLoader(),
              );
            } else {
              return ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            radius: MediaQuery
                                .of(context)
                                .size
                                .width * 0.15,
                            backgroundImage: NetworkImage(
                                snapshot.data['image']),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, right: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GFBadge(
                                  shape: GFBadgeShape.circle,
                                  size: GFSize.LARGE,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30, left: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: AutoSizeText(snapshot.data['name'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,

                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: AutoSizeText(
                                    "  " + snapshot.data['Department'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,

                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, top: 4),
                                child: Container(
                                  height: 20,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('  5.0'),
                                      SizedBox(width: 10,),
                                      Icon(Icons.favorite,
                                        color: Colors.pinkAccent,),
                                      AutoSizeText(' 891 like', maxLines: 1,)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person, color: Colors.blue,),
                                    AutoSizeText('UpTo 4592 Clients')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ) //topDetails
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_turned_in),
                    title: Text(snapshot.data['Description']),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Location"),
                    subtitle: Text("Mankundu Station Road 712139"),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 300,
                    child: GoogleMap(
                      liteModeEnabled: true,
                      zoomControlsEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: LatLng(
                          snapshot.data['address']['geopoint'].latitude,
                          snapshot.data['address']['geopoint'].longitude), zoom: 15),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: ({Marker(
                        markerId: MarkerId(snapshot.data['name']),
                        position: LatLng(
                            snapshot.data['address']['geopoint'].latitude,
                            snapshot.data['address']['geopoint'].longitude),
                        infoWindow: InfoWindow(title: snapshot
                            .data['name']),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet,
                        ),
                      )}),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('all day'),
                    subtitle: Text('Sunday | Monday'),
                  ),
                ],
              );
            }
          }
          ),
        ),
      );
  }
}
