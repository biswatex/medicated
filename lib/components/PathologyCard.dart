import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
      height: 200,
      child: FutureBuilder(
          future: data,
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.black12,
                child: CarouselSlider.builder(
                    itemCount:5,
                    options: CarouselOptions(
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 2,
                      enableInfiniteScroll: true,
                      reverse: true,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (_,index){
                      return Container(
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
              return Container(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider.builder(
                    itemCount:snapshot.data.length,
                    options: CarouselOptions(
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 1,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (_,index){
                      return Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        child:Stack(
                          children: [
                            GFCard(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.all(0),
                              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                              boxFit: BoxFit.cover,
                              imageOverlay: NetworkImage(snapshot.data[index].data['image'],scale:0.4),
                              title: GFListTile(
                                padding: EdgeInsets.all(0),
                                title: Text(snapshot.data[index].data['title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                subTitle: Text('subtitle',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.only(
                                      topLeft:Radius.circular(30),
                                      bottomRight:Radius.circular(10),
                                      bottomLeft:Radius.circular(0),
                                      topRight:Radius.circular(0),
                                    ),
                                  ),
                                  child: FlatButton(
                                      onPressed: null,
                                      child: Icon(Icons.arrow_forward,color: Colors.white),
                                  ),
                                ))
                          ],
                        ),
                      );
                    }),
              );
            }
          }),
    );
  }
}
