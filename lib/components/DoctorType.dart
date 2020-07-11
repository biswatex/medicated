import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicated/Screens/Home/QueryList.dart';
class DoctorType extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color color_1;
  final Color color_2;
  final String queryType;

  const DoctorType({Key key, this.image, this.title, this.subtitle, this.color_1, this.color_2,this.queryType}) : super(key: key);
  @override
  _DoctorTypeState createState() => _DoctorTypeState();
}
class _DoctorTypeState extends State<DoctorType> {
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
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              QueryList(longitude:longitude,latitude:latitude,q:Firestore.instance.collection("doctors").where('type' ,isEqualTo:widget.title))));
        },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(2),
        height: MediaQuery.of(context).size.height*0.4,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Image(
                  image:NetworkImage(widget.image),
                  fit:BoxFit.fill,height:MediaQuery.of(context).size.height*0.4,)
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        widget.color_1.withOpacity(0.7),
                        widget.color_2.withOpacity(0.7)
                      ],
                    )
                )),
            Align(
              alignment: Alignment.center,
              child: ListTile(
                subtitle: AutoSizeText(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Museo',
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 10,
                ),
                title: AutoSizeText(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Museo',
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
