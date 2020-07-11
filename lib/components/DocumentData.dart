import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:medicated/Screens/Home/ItemSelect.dart';
import 'package:medicated/components/Customloder.dart';
import 'package:medicated/components/GetDistance.dart';
class DocumentData extends StatefulWidget {
  final docId;
  const DocumentData({Key key, this.docId}) : super(key: key);
  @override
  _DocumentSnapshotState createState() => _DocumentSnapshotState();
}

class _DocumentSnapshotState extends State<DocumentData> {
  DocumentSnapshot snapshot;
  List<Color> ColorSet;
  List<Color> AcentColorSet;
  var randomizer = new Random();
  Future f;
  getData() async {
    DocumentSnapshot snapsho = await Firestore.instance.collection('doctors')
        .document(widget.docId)
        .get();
    setState(() {
      snapshot = snapsho;
    });
    return snapshot;
  }

  initState() {
    super.initState();
    f = getData();
    AcentColorSet = [Colors.blue,Colors.yellow];
    ColorSet = [Colors.pink,Colors.green];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future:f,
            builder:(_,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 70,
              margin:EdgeInsets.all(4) ,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: ColorLoader(
                  dotThreeColor: Colors.green,
                  dotTwoColor: Colors.blue,
                  dotOneColor: Colors.red,
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(docID:widget.docId)));},
              child: Container(
                height: 70,
                margin:EdgeInsets.all(4) ,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        ColorSet[randomizer.nextInt(2)],
                        AcentColorSet[randomizer.nextInt(2)]
                      ],
                    )
                ),
                width: MediaQuery.of(context).size.width*0.8,
                child: GestureDetector(
                  onTap:null,
                  child: GFListTile(
                    color: Colors.transparent,
                    avatar: GFAvatar(
                      backgroundColor: Colors.transparent,
                      shape: GFAvatarShape.standard,
                      radius: MediaQuery.of(context).size.width*0.1,
                      backgroundImage:NetworkImage( snapshot.data['image']),
                    ),
                    title:Text(snapshot.data['name'],style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                    subTitle:Container(
                      child: Row(
                        children: [
                          Icon(Icons.assignment_turned_in,size:12,color: Colors.white,),
                          Text("  "+snapshot.data['Department'],style: TextStyle(
                            color:Colors.white,
                            fontWeight: FontWeight.normal,
                          )),
                        ],
                      ),
                    ),
                    description: Container(child: Row(
                      children: [
                        Icon(Icons.location_on,size: 12,color: Colors.white,),
                        GetDistance(data:snapshot.data['address']),
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
              ),
            );
          }
        }
        )
    );
  }
}
