import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GetDistance extends StatefulWidget {
  final position;
  const GetDistance({Key key, this.position}) : super(key: key);
  @override
  _GetDistanceState createState() => _GetDistanceState();
}

class _GetDistanceState extends State<GetDistance> {
  Position position;
  double distance;
  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
  Future<double> Distance(GeoPoint pos) async{
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
    Distance(widget.position);
    return Container(
      child: Text(distance.toString()+" Km away",style: TextStyle(color:Colors.grey),),
    );
  }
}
