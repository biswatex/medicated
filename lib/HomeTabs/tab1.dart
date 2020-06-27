import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'file:///B:/biswatex/medicated/lib/components/card.dart';
class tabHome extends StatefulWidget {
  @override
  _tabHomeState createState() => _tabHomeState();
}

class _tabHomeState extends State<tabHome> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
        return Scaffold(

            body: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal:width*0.01),
              child: ListView(
                children: <Widget>[
                  Image(image: AssetImage('assets/images/mainBar.png'),fit: BoxFit.cover,),
                  Container(
                    margin: EdgeInsets.only(bottom:height*0.01,left:width*0.05,right:width*0.05),
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      elevation: 10,
                      child: TextField(
                        decoration: new InputDecoration(
                          hintText: 'Search..',
                          suffixIcon: new Icon(Icons.search,color:Colors.grey),
                          labelStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          filled: true,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: new BorderSide(
                                color: Colors.white,
                              )),
                          focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: new BorderSide(
                                color: Colors.white,
                              )),
                          enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: new BorderSide(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:10),
                    child: Text('Category',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sriracha',
                      fontSize: 22,
                      color: Colors.black54,
                    ),),
                  ),
                  chips(),
                  DoctorsCard(),
                ],
              ),
            ),
        );
  }
}
class chips extends StatefulWidget {
  @override
  _chipsState createState() => _chipsState();
}

class _chipsState extends State<chips> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child :ListView(
      scrollDirection: Axis.horizontal,
      children:<Widget>[
        _Chips(title:'child',icon:'',),
      ],
    ),
    );
  }

}
class _Chips extends StatelessWidget {
  final String title;
  final String icon;
  _Chips({this.title,this.icon});
  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(title),
    avatar: CircleAvatar(
      child:Image(image:NetworkImage(icon),),
    ),);
  }
}

