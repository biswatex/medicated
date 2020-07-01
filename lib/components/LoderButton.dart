import 'dart:async';
import 'package:flutter/material.dart';
import 'Customloder.dart';
class LoaderButton extends StatefulWidget {
  final text;
  const LoaderButton({Key key, this.text}) : super(key: key);
  @override
  _LoaderButtonState createState() => _LoaderButtonState();
}

class _LoaderButtonState extends State<LoaderButton> {
  int _state = 0;
  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        _state = 2;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_state == 0) {
      return new Text(widget.text,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else{
      return ColorLoader(
        dotOneColor: Colors.purple,
        dotTwoColor: Colors.pink,
        dotThreeColor: Colors.red,
        dotType: DotType.circle,
        duration: Duration(seconds:2),
      );
    }
  }

}



