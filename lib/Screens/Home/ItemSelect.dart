import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicated/Screens/Home/Booking.dart';
import 'package:medicated/components/Customloder.dart';

class Detail extends StatefulWidget {
  final  docID;
  const Detail({Key key, this.docID}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}
class _DetailState extends State<Detail> {
  Completer<GoogleMapController> _controller = Completer();
  DocumentSnapshot snapshot;
  Future f;
  getData() async {
    DocumentSnapshot snapsho = await Firestore.instance.collection('doctors')
        .document(widget.docID)
        .get();
    setState(() {
      snapshot = snapsho;
    });
    return snapshot;
  }
  initState() {
    super.initState();
    f = getData();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: f,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: ColorLoader(),
          );
        } else {
          return Container(
            color: Colors.blue,
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context,
                    bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        expandedHeight:height*0.4,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            height: height*0.4,
                            child: Stack(
                              children: [
                                Container(
                                  height: height*0.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage("https://www.rnz.co.nz/assets/news_crops/85269/eight_col_medicine.jpg?1565217199"),fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.pinkAccent.withOpacity(0.7),Colors.blue.withOpacity(1)]
                                      )
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: height*0.3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width*0.35,
                                          height: width*0.35,
                                          child: CircleAvatar(
                                              radius: width * 0.15,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data['image']),
                                            ),
                                        ),
                                        Container(
                                          width: width*0.6,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              AutoSizeText(
                                                    snapshot.data['name'],
                                                    maxLines: 1,
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
                                              AutoSizeText(
                                                    "  " + snapshot.data['Department'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ) //topDetails
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ];
                },
                body: Container(
                  color: Colors.blue,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top:35),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft:Radius.circular(25),
                                topRight:Radius.circular(25),
                              ),
                            color: Colors.white
                          ),
                          child: ListView(
                                    children: <Widget>[
                                      Container(
                                        padding:EdgeInsets.only(top:35) ,
                                        child: ListTile(
                                          leading: Icon(Icons.assignment_turned_in),
                                          title: Text(snapshot.data['Description']),
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.location_on),
                                        title: Text("Location"),
                                        subtitle: Text("Mankundu Station Road 712139"),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        height: 300,
                                        child: GoogleMap(
                                          liteModeEnabled: true,
                                          zoomControlsEnabled: true,
                                          mapType: MapType.normal,
                                          initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                  snapshot.data['address']['geopoint']
                                                      .latitude,
                                                  snapshot.data['address']['geopoint']
                                                      .longitude), zoom: 15),
                                          onMapCreated: (
                                              GoogleMapController controller) {
                                            _controller.complete(controller);
                                          },
                                          markers: ({Marker(
                                            markerId: MarkerId(snapshot.data['name']),
                                            position: LatLng(
                                                snapshot.data['address']['geopoint']
                                                    .latitude,
                                                snapshot.data['address']['geopoint']
                                                    .longitude),
                                            infoWindow: InfoWindow(title: snapshot
                                                .data['name']),
                                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                              BitmapDescriptor.hueViolet,
                                            ),
                                          )}),
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.access_time),
                                        title: Text('all day'),
                                        subtitle: Text('Sunday | Monday'),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.blue[200],
                            ),
                            height: 65,
                            width: width*0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Container(
                                    width: width*0.2,
                                    child: Column(
                                      children: [
                                        Icon(Icons.star,
                                          color: Colors.yellow,),
                                        Text('5.0',style: TextStyle(color:Colors.white),),
                                      ],
                                    ),
                                  ),
                                VerticalDivider(
                                  color: Colors.blue,
                                  thickness: 2,
                                ),
                                Container(
                                  width: width*0.2,
                                  child: Column(
                                    children: [
                                      Icon(Icons.favorite,
                                        color: Colors.pinkAccent,),
                                      AutoSizeText(
                                        '891', maxLines: 1,style: TextStyle(color:Colors.white),)
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.blue,
                                  thickness: 2,
                                ),
                                Container(
                                  width: width*0.2,
                                  child: Column(
                                    children: [
                                      Icon(Icons.person,
                                        color: Colors.white,),
                                      AutoSizeText('4592',style: TextStyle(color:Colors.white),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Booking(snapshot:snapshot,docId:widget.docID,docName: snapshot.data['name'],)));
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft:Radius.circular(25),
                          topRight:Radius.circular(25),
                        ),
                        color: Colors.blue
                    ),
                  height: 56,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Book Now",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Museo',
                      ),))
                ),
              ),
            ),
          );
        }
      }
      );
  }
}
