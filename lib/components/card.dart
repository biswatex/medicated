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
  @override
  _DoctorsCardState createState() => _DoctorsCardState();
}

class _DoctorsCardState extends State<DoctorsCard> {
  Future futureData;
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
    futureData = getData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: futureData,
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
                    height:MediaQuery.of(context).size.height*0.55 ,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_,index){
                          return Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            child: GestureDetector(
                              onTap: ()=>naviagteToDetail(snapshot.data[index]),
                              child: GFListTile(
                                color: Colors.black12,
                                avatar: GFAvatar(
                                  backgroundColor: Colors.transparent,
                                  shape: GFAvatarShape.standard,
                                    radius: MediaQuery.of(context).size.width*0.1,
                                    backgroundImage:NetworkImage( snapshot.data[index].data['image']),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: GFBadge(
                                          shape: GFBadgeShape.circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                ),
                                  titleText:snapshot.data[index].data['name'],
                                  subtitleText:"  "+snapshot.data[index].data['Department'],
                                description: GetDistance(position:snapshot.data[index].data['address'],),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                icon: Container(child: Column(
                                  children: [
                                    Icon(Icons.star,color: Colors.amberAccent,),
                                     Text("5.0"),
                                  ],
                                )),
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

