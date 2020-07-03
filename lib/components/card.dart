import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getflutter/getflutter.dart';
import 'package:medicated/Screens/Home/ItemSelect.dart';
import 'package:shimmer/shimmer.dart';

class DoctorsCard extends StatefulWidget {
  @override
  _DoctorsCardState createState() => _DoctorsCardState();
}

class _DoctorsCardState extends State<DoctorsCard> {
  Future Data;
  Position position;
  String distance;
  Future getData() async {
    var fireStore = Firestore.instance;
    Query query = fireStore.collection("doctors").limit(4);
    QuerySnapshot q = await query.getDocuments();
    return q.documents;
  }
  naviagteToDetail(DocumentSnapshot documentSnapshot){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(details:documentSnapshot)));
  }
  @override
  void initState() {
    super.initState();
    Data = getData();
  }
  Distance(pos) async{
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = await Geolocator().distanceBetween(pos.latitute,pos.longitude,position.latitude,position.longitude);
    setState(() {
      distance = distanceInMeters.toString();
    });
    return distanceInMeters.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: Data,
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.black12,
                child: GFListTile(
                    titleText:'Title',
                    subtitleText:'Lorem ipsum dolor sit amet, consectetur adipiscing',
                    icon: Icon(Icons.favorite)
                ),
              );
            }else{
              Distance(snapshot.data['address']);
              return Column(
                children:<Widget>[
                  Container(
                    height:350 ,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_,index){
                          return Container(
                            width: 180.0,
                            child: GestureDetector(
                              onTap: ()=>naviagteToDetail(snapshot.data[index]),
                              child: GFListTile(
                                color: Colors.white,
                                avatar: GFAvatar(
                                    radius: 40,
                                    backgroundImage:NetworkImage( snapshot.data[index].data['image']),
                                    child:Padding(
                                      padding: const EdgeInsets.only(bottom:4.0,right:4.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: GFBadge(
                                          shape: GFBadgeShape.circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                ),
                                  titleText:snapshot.data[index].data['name'],
                                  subtitleText:snapshot.data[index].data['Department'],
                                description: Text(distance),
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.all(5),
                                icon: Container(child: Row(
                                  children: [
                                    Icon(Icons.star),
                                    Padding(
                                      padding: const EdgeInsets.only(left:4.0),
                                      child: Text("5.0"),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: 20,
                    child: FlatButton(
                      onPressed: null,
                      child: Text("View all"),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

