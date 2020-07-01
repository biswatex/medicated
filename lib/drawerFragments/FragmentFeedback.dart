import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/components/CustomKFDrawer.dart';

class FeedbackUs extends KFDrawerContent {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState
    extends State<FeedbackUs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.onMenuPressed,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}