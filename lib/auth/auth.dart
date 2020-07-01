import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Home/MainPage.dart';

signIn(String email, String password,context) {
  try {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((currentUser) => Firestore.instance.collection("user").document(currentUser.user.uid).get())
        .then((DocumentSnapshot result) => Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HomePage(title: result["name"],uid:result['email'],image:result['profilePics']))));
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

signUp(email, password, displayName,surName, phoneNo,context) {
  FirebaseUser user;
  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,)
      .then((currentUser) => Firestore.instance
      .collection("user")
      .document(currentUser.user.uid)
      .setData({
    "uid": currentUser.user.uid,
    "name": displayName,
    "surname": surName,
    "email": email,
    "phoneNo":phoneNo,
  })).then((result) => {Navigator.push(context, MaterialPageRoute(
      builder: (context) => HomePage(title:displayName,uid:user.email,)))
  }
  );
}
