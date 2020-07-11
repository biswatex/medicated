import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicated/components/DocumentData.dart';
import 'package:medicated/components/GetDistance.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'ItemSelect.dart';
class QueryList extends StatefulWidget {
  final Query q;
  final longitude;
  final latitude;

  const QueryList({Key key, this.q, this.longitude, this.latitude}) : super(key: key);
  @override
  _QueryListState createState() => _QueryListState();
}
class _QueryListState extends State<QueryList> {
  GoogleMapController _mapController;
  List<Color> colorSet;
  List<Color> acentColorSet;
  var randomizer = new Random();
  Geoflutterfire geo;
  bool state = false;
  double _value = 20.0;
  String _label = '';
  int index =0;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject<double>.seeded(20.0);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  initState(){
    super.initState();
    acentColorSet = [Colors.blue,Colors.yellow];
    colorSet = [Colors.pink,Colors.green];
    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude:widget.latitude, longitude:widget.longitude);
    stream = radius.switchMap((rad) {
      return geo.collection(collectionRef: widget.q).within(
          center: center, radius: rad, field: 'address', strictMode: true);
    });
  }
  @override
  void dispose() {
    super.dispose();
    radius.close();
  }
  naviagteToDetail(DocumentSnapshot documentSnapshot){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Detail(docID:documentSnapshot.documentID)));
  }
  Widget main(){
    if(state == false){
      return  Container(
          child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? ListView.builder(
                  itemCount: 20,
                  itemBuilder:(_,index){
                    return Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.black12,
                      child: GFListTile(
                          titleText:'Title',
                          subtitleText:'Lorem ipsum dolor sit amet, consectetur adipiscing',
                          icon: Icon(Icons.favorite)
                      ),
                    );
                  }
              )
                  : ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data =
                  snapshot.data[index];
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
                            colorSet[randomizer.nextInt(2)].withOpacity(0.7),
                            acentColorSet[randomizer.nextInt(2)].withOpacity(0.7)
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
                          backgroundImage:NetworkImage(data['image']),
                        ),
                        title:Text(data['name'],style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                        subTitle:Container(
                          child: Row(
                            children: [
                              Icon(Icons.assignment_turned_in,size:12,color: Colors.white,),
                              Text("  "+data['Department'],style: TextStyle(
                                color:Colors.white,
                                fontWeight: FontWeight.normal,
                              )),
                            ],
                          ),
                        ),
                        description: Container(child: Row(
                          children: [
                            Icon(Icons.location_on,size: 12,color: Colors.white,),
                            GetDistance(data:data['address']),
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
                },
              );
            },
          ),
        );
    }else {
      return Container(
        color: Colors.white,
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: GoogleMap(
                  mapToolbarEnabled:false,
                  myLocationEnabled: true,
                  buildingsEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 12.0,
                  ),
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width:MediaQuery.of(context).size.width*0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Card(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.red[700],
                          inactiveTrackColor: Colors.red[100],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.redAccent,
                          overlayColor: Colors.red.withAlpha(32),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.red[700],
                          inactiveTickMarkColor: Colors.red[100],
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.redAccent,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          min: 10,
                          max: 200,
                          divisions: 4,
                          value: _value,
                          label: _label,
                          onChanged: (double value) => changed(value),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       leading: Builder(
         builder: (BuildContext context) {
           return IconButton(
             icon: const Icon(Icons.arrow_back_ios),
             onPressed: (){Navigator.pop(context);},
           );
         },
       ),
       actions:<Widget>[
         Switch(
           inactiveThumbImage: new NetworkImage('https://image.flaticon.com/icons/png/512/355/355980.png'),
           activeThumbImage: new NetworkImage('https://freeiconshop.com/wp-content/uploads/edd/list-flat.png'),
           value:state,
           onChanged: (bool value) {
             setState(() {
               state = value;
             });
           },
         )
       ],
     ),
     body: main(),
   );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  void _addMarker(double lat, double lng,data) {
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(snippet: '$lat,$lng'),
      onTap: (){
        displayBottomSheet(context,data);
      }
    );
    setState(() {
      index = markers.length;
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['address']['geopoint'];
      _addMarker(point.latitude, point.longitude,document.documentID);
    });
  }

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }
  void displayBottomSheet(BuildContext context,data) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        context: context,
        builder: (ctx) {
          return DocumentData(docId:data);
        });
  }
}
