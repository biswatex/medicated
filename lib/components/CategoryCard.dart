import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCard extends StatefulWidget {
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  Future getDataCat() async {
    var fireStore = Firestore.instance;
    QuerySnapshot data =await fireStore.collection("category").getDocuments();
    return data.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 200,
      child: FutureBuilder(
          future: getDataCat(),
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
                      height: 200,
                      width: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.only(topLeft:Radius.circular(100),topRight: Radius.circular(25),bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25))
                        ),
                        elevation:5,
                        color: Color(int.parse("0xff"+snapshot.data[index].data['color'])),
                          child: ListView(
                            children:<Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color:Color(int.parse("0xff"+snapshot.data[index].data['colorLogo'])),
                                        borderRadius: BorderRadius.all(Radius.circular(200))
                                    ),
                                  height: 80,
                                    width: 80,
                                    child: Image(image:NetworkImage(snapshot.data[index].data['image']),)),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left:25,right: 20,top: 20,bottom: 25),
                                  child: Text(snapshot.data[index].data['title'],style:TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(int.parse("0xff"+snapshot.data[index].data['colorText'])),
                                  ),)),
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
