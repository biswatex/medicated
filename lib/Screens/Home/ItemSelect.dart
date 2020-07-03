import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Detail extends StatefulWidget {
  final DocumentSnapshot details;
  const Detail({Key key, this.details}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}
class _DetailState extends State<Detail> {
  Completer<GoogleMapController> _controller = Completer();
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
        child: ListView(
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
                              widget.details.data['image']),
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
                              child: Text(widget.details.data['name'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,

                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(widget.details.data['Department'],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow,),
                                    Text('5.0'),
                                    SizedBox(width: 10,),
                                    Icon(Icons.favorite,
                                      color: Colors.pinkAccent,),
                                    Text('891 Likes')
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.blue,),
                                  Text('Upto 4592 Clients')
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
                  title: Text(widget.details.data['Description']),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("address"),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(target: LatLng(widget.details.data['address'].latitude,widget.details.data['address'].longitude), zoom: 12),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: ({Marker(
                      markerId: MarkerId(widget.details.data['name']),
                      position: LatLng(widget.details.data['address'].latitude,widget.details.data['address'].longitude),
                      infoWindow: InfoWindow(title:widget.details.data['name']),
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
            ),
        ),
      );
  }
}
