import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
import 'package:medicated/Screens/Login/index.dart';
import 'package:medicated/components/Customloder.dart';
import 'Screens/Home/Utility.dart';

void main() {
  ClassBuilder.registerClasses();
  runApp(MyApp());
}
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

class _SplashPageState extends State<Auth> with TickerProviderStateMixin {

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
            MaterialPageRoute(builder: (context) => HomePage(title:value['name'],uid:value['phoneNo'],image:value['profilePics'],)),
          )),
          }
    })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text("medicative")),
                  Padding(
                    padding: const EdgeInsets.only(bottom:100),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ColorLoader()),
                  ),
                ],
              )),
        ),
    );
  }
}
