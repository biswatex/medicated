import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
import 'package:medicated/Screens/Login/index.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
          home:  Auth(),
        );
      }
  }

class Auth extends StatefulWidget {
  Auth({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<Auth> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
      if (currentUser == null)
        {Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginScreen()),)}
      else
        {
          Firestore.instance.collection('user').document(currentUser.uid).get().then((value) =>
              Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(title:value['name'],uid:value['email'],)),
          )),
          }
    })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
