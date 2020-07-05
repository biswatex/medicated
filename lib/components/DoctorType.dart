import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DoctorType extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color color_1;
  final Color color_2;

  const DoctorType({Key key, this.image, this.title, this.subtitle, this.color_1, this.color_2}) : super(key: key);
  @override
  _DoctorTypeState createState() => _DoctorTypeState();
}

class _DoctorTypeState extends State<DoctorType> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
