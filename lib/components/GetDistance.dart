import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GetDistance extends StatefulWidget {
  final data;
  const GetDistance({Key key, this.data}) : super(key: key);
  @override
  _GetDistanceState createState() => _GetDistanceState();
}

class _GetDistanceState extends State<GetDistance> {
  Position position;
  double distance;
  Future f;
  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
  initState(){
    super.initState();
    GeoPoint m = widget.data['geopoint'];
    f = getDistance(m);
  }
  Future<double> getDistance(GeoPoint pos) async{
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = await Geolocator().distanceBetween(pos.latitude,pos.longitude,position.latitude,position.longitude);
    setState(() {
      distanceInMeters = distanceInMeters/1000;
      distance = roundDouble(distanceInMeters, 2);
    });
    return distanceInMeters;
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder(
        future: f,
        builder:(_,context) {
          if(context.connectionState == ConnectionState.waiting) {
            return Container(
              child: Text("calculating distance ..",
                style: TextStyle(color: Colors.white),),
            );
        }else{
            return Container(
              child: Text("  " + distance.toString() + " Km away",
                style: TextStyle(color: Colors.white),),
            );
          }
        })
    );
  }
}
