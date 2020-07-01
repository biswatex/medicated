import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      width:MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: getData(),
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
              return Column(
                children:<Widget>[
                  Container(
                    height:350 ,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_,index){
                          return Container(
                            width: 180.0,
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
                                  description: Text(snapshot.data[index].data['Description']),
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

