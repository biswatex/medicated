import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:getflutter/getflutter.dart';
class PathologyCard extends StatefulWidget {
  @override
  _PathologyCardState createState() => _PathologyCardState();
}

class _PathologyCardState extends State<PathologyCard> {
  Future data;
  Future getDataCat() async {
    var fireStore = Firestore.instance;
    QuerySnapshot data =await fireStore.collection("Pathology").getDocuments();
    return data.documents;
  }
  @override
  void initState() {
    super.initState();
    data = getDataCat();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 200,
      child: FutureBuilder(
          future: data,
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
                        width: MediaQuery.of(context).size.width*0.5,
                        child:   GFCard(
                          padding: EdgeInsets.all(0),
                          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                          boxFit: BoxFit.cover,
                          title: GFListTile(
                            padding: EdgeInsets.all(0),
                            title: Text("Title"),
                            subTitle: Text('subtitle'),
                          ),
                          buttonBar: GFButtonBar(
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              GFButton(
                                size: GFSize.SMALL,
                                onPressed: () {},
                                text: 'View',
                              )
                            ],
                          ),
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
                      width: MediaQuery.of(context).size.width*0.5,
                      child:   GFCard(
                        padding: EdgeInsets.all(0),
                        colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                        boxFit: BoxFit.cover,
                        imageOverlay: NetworkImage(snapshot.data[index].data['image'],scale:0.4),
                        title: GFListTile(
                          padding: EdgeInsets.all(0),
                          title: Text(snapshot.data[index].data['title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          subTitle: Text('subtitle',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                        ),
                        buttonBar: GFButtonBar(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          GFButton(
                            size: GFSize.SMALL,
                            onPressed: () {},
                            text: 'View',
                          )
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
