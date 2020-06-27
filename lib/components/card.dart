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
                      width: 220.0,
                      child: GFCard(
                        elevation: 10,
                        boxFit: BoxFit.cover,
                        title: GFListTile(
                          avatar: GFAvatar(backgroundImage:NetworkImage(snapshot.data[index].data['image']), size:GFSize.LARGE,),
                          title: Text(snapshot.data[index].data['name']),
                          subTitle: Text(snapshot.data[index].data['dept']),
                        ),
                        content: Text(snapshot.data[index].data['Description'],maxLines:5,),
                        buttonBar: GFButtonBar(
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Icon(Icons.star,color: Colors.yellow,),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Icon(Icons.favorite,color: Colors.pink),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}

