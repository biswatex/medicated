import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:medicated/Screens/Home/ItemSelect.dart';
import 'package:medicated/components/GetDistance.dart';
import 'package:shimmer/shimmer.dart';

class DoctorsCard extends StatefulWidget {
  final int demoCount;
  const DoctorsCard({Key key, this.demoCount}) : super(key: key);
  @override
  _DoctorsCardState createState() => _DoctorsCardState();
}

class _DoctorsCardState extends State<DoctorsCard> {
  List<Color> ColorSet;
  List<Color> AcentColorSet;
  var randomizer = new Random();
  Future futureData;
  Future getData() async {
    var fireStore = Firestore.instance;
    Query query = fireStore.collection("doctors").limit(3);
    QuerySnapshot q = await query.getDocuments();
    return q.documents;
  }
  naviagteToDetail(DocumentSnapshot documentSnapshot){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(docID:documentSnapshot.documentID)));
  }
  @override
  void initState() {
    super.initState();
    futureData = getData();
      AcentColorSet = [Colors.blue,Colors.yellow];
      ColorSet = [Colors.pink,Colors.green];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: futureData,
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                height:MediaQuery.of(context).size.height*0.55 ,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder:(_,index){
                    return Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.black12,
                      child: GFListTile(
                          titleText:'$index+Title',
                          subtitleText:'Lorem ipsum dolor sit amet, consectetur adipiscing',
                          icon: Icon(Icons.favorite)
                      ),
                    );
                  }
                ),
              );
            }else{
              return Column(
                children:<Widget>[
                  Container(
                    height:MediaQuery.of(context).size.height*0.55 ,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_,index){
                          return Container(
                            margin:EdgeInsets.all(4) ,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      ColorSet[randomizer.nextInt(2)].withOpacity(0.7),
                                      AcentColorSet[randomizer.nextInt(2)].withOpacity(0.7)
                                    ],
                                  )
                              ),
                            width: MediaQuery.of(context).size.width*0.8,
                            child: GestureDetector(
                              onTap: ()=>naviagteToDetail(snapshot.data[index]),
                              child: GFListTile(
                                color: Colors.transparent,
                                avatar: GFAvatar(
                                  backgroundColor: Colors.transparent,
                                  shape: GFAvatarShape.standard,
                                    radius: MediaQuery.of(context).size.width*0.1,
                                    backgroundImage:NetworkImage( snapshot.data[index].data['image']),
                                ),
                                  title:Text(snapshot.data[index].data['name'],style: TextStyle(
                                          color:Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  subTitle:Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.assignment_turned_in,size:12,color: Colors.white,),
                                        Text("  "+snapshot.data[index].data['Department'],style: TextStyle(
                                          color:Colors.white,
                                          fontWeight: FontWeight.normal,
                                        )),
                                      ],
                                    ),
                                  ),
                                description: Container(child: Row(
                                  children: [
                                    Icon(Icons.location_on,size: 12,color: Colors.white,),
                                    GetDistance(data:snapshot.data[index].data['address']),
                                  ],
                                )),
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.all(5),
                                icon: Container(
                                    padding:EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Icon(Icons.star,color: Colors.amberAccent,),
                                        Text("5.0",style: TextStyle(
                                          color:Colors.white,
                                          fontWeight: FontWeight.normal,
                                        )),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }
}

