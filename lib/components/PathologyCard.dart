import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class PathologyCard extends StatefulWidget {
  @override
  _PathologyCardState createState() => _PathologyCardState();
}

class _PathologyCardState extends State<PathologyCard> {
  Future getDataCat() async {
    var fireStore = Firestore.instance;
    QuerySnapshot data =await fireStore.collection("Pathology").getDocuments();
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
                        height: 200,
                        width: 150.0,
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
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(snapshot.data[index].data['image']),fit:BoxFit.fill),
                      ),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15),bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15))
                          ),
                          elevation:5,
                          color: Colors.transparent,
                          child: Align(
                                alignment: Alignment.center,
                                  child: Text(snapshot.data[index].data['title'],style:TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(int.parse("0xff"+snapshot.data[index].data['colorText'])),
                                  ),)),

                      ),
                    );
                  });
            }
          }),
    );
  }
}
