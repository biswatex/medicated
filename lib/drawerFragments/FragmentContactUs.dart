import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/components/CustomKFDrawer.dart';

// ignore: must_be_immutable
class ContactUs extends KFDrawerContent {
  @override
  _ContactUsState createState() =>
      _ContactUsState();
}

class _ContactUsState
    extends State<ContactUs> {
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