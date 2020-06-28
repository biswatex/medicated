import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:shimmer/shimmer.dart';

class DoctorsCard extends StatefulWidget {
  @override
  _DoctorsCardState createState() => _DoctorsCardState();
}

class _DoctorsCardState extends State<DoctorsCard> {
  Future getData() async {
    var firestore = Firestore.instance;
    QuerySnapshot deta =await firestore.collection("doctors").getDocuments();
    return deta.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 268,
      child: FutureBuilder(
          future: getData(),
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.black12,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_,index){
                      return Container(
                        width: 200.0,
                        child : Card(
                        ),
                      );
                    }),
              );
            }else{
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_,index){
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal:5),
                      width: 180.0,
                      child: Stack(
                        children:<Widget>[
                          Container(
                            padding: EdgeInsets.only(top:30),
                            height: 250,
                            width: 180,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child:ListView(
                                padding: EdgeInsets.only(top:30,right:5,left:10,bottom:10),
                                  children:<Widget>[
                                    Container(
                                        padding: EdgeInsets.only(top:30),
                                        child: Text(snapshot.data[index].data['name'],style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),)),
                                    Container(
                                        padding: EdgeInsets.only(top:1,left:5),
                                        child: Text(snapshot.data[index].data['Department'],style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ))),
                                  ]),
                            ),
                          ),
                          Align(
                            alignment:Alignment.topCenter,
                            child: Container(
                              height: 80,
                              width: 80,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data[index].data['image']),
                                  backgroundColor: Colors.indigoAccent,
                                  child: Visibility(
                                    visible: snapshot.data[index].data['online'],
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: GFBadge(
                                        size: GFSize.MEDIUM,
                                        shape: GFBadgeShape.circle,
                                        color: Colors.green,
                                        border:BorderSide(color: Colors.white,width:2),
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ],
                      )
                    );
                  });
            }
          }),
    );
  }
}

