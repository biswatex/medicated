import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
import 'package:medicated/Screens/Login/CompleteRegister.dart';

signInE(String email, String password,context) {
  try {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((currentUser) => Firestore.instance.collection("user").document(currentUser.user.uid).get())
        .then((DocumentSnapshot result) =>
          (result["CompleteRegister"]==true)?
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title:result['name'],uid:result['phoneNo'],image:result['profilePics']))):
          Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteRegistration(isNumber:false,data:email,)))
    );
  } catch (e){
   return AlertDialog(
        title: Text('error'),
        content: SingleChildScrollView(
          child: ListBody(
        children: <Widget>[
              Text(e),],),),
       actions: <Widget>[
         FlatButton(
           child: Text('Retry'),
           onPressed: () {
             Navigator.of(context).pop();})]);
  }
}

signUp(email, password,context) {
  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,)
      .then((currentUser) =>
      FirebaseAuth.instance.currentUser().then((value) =>
          Firestore.instance.collection('user').document(value.uid).setData({
            "CompleteRegister":false,
          }).then((value) =>
      {Navigator.push(context, MaterialPageRoute(
        builder: (context) => CompleteRegistration(isNumber:false,data:email,)))}
      )
  )
  );
}

