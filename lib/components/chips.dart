import 'package:flutter/material.dart';
class Chips extends StatefulWidget {
  final String title;
  final String icon;
  const Chips({Key key, this.title,this.icon}) : super(key: key);
  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child :ListView(
        scrollDirection: Axis.horizontal,
        children:<Widget>[
          _Chips(title:widget.title,icon:widget.icon,),
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