import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicated/Screens/Home/QueryList.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCard extends StatefulWidget {
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  Future Data;
  Future getDataCat() async {
    var fireStore = Firestore.instance;
    QuerySnapshot data =await fireStore.collection("category").getDocuments();
    return data.documents;
  }
  double longitude;
  double latitude;
  getLocation() async{
    Position p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      longitude = p.longitude;
      latitude = p.latitude;
    });
  }
  @override
  void initState() {
    super.initState();
    Data = getDataCat();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.3,
      child: FutureBuilder(
          future: Data,
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
                    return GestureDetector(
                      onTap: (){
                        String s = snapshot.data[index].data['title'];
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            QueryList(longitude:longitude,latitude:latitude,q:Firestore.instance.collection("doctors").where('Department' ,isEqualTo:s))));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left:8,right: 8,bottom: 10),
                        height: MediaQuery.of(context).size.height*0.6,
                        width: MediaQuery.of(context).size.width*0.4,
                            child: Stack(
                              children:<Widget>[
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: EdgeInsets.only(top:20),
                                    height: MediaQuery.of(context).size.height*0.3,
                                    width: MediaQuery.of(context).size.width*0.4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [BoxShadow(
                                              color: Color(int.parse("0xff"+snapshot.data[index].data['color'])),
                                              blurRadius: 10.0,
                                            ),],
                                            borderRadius: BorderRadius.only(
                                              topLeft:Radius.circular(10),
                                              topRight:Radius.circular(80),
                                              bottomRight:Radius.circular(10),
                                              bottomLeft:Radius.circular(10),
                                            ),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(int.parse("0xff"+snapshot.data[index].data['color'])), Color(int.parse("0xff"+snapshot.data[index].data['color_2']))])
                                        ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                        borderRadius: BorderRadius.all(Radius.circular(200))
                                    ),
                                    padding: EdgeInsets.all(0),
                                    height: MediaQuery.of(context).size.height*0.125,
                                      width: MediaQuery.of(context).size.height*0.125,
                                      child: Image(image:NetworkImage(snapshot.data[index].data['image']),)),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal:2),
                                      child: ListTile(
                                        title: AutoSizeText(
                                         snapshot.data[index].data['title'],
                                          maxLines: 1,
                                          style:TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(left:2.0),
                                          child: AutoSizeText(
                                            snapshot.data[index].data['description'],
                                            maxLines:3,
                                            style:TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )),
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
