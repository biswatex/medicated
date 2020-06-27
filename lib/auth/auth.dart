
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Home/MainPage.dart';

signIn(String email, String password,context) {
  try {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password).then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage())));
  } catch (e){
    print(e.toString());
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())));
  }
}

signUp(String email, String password,String name ,String phno,context) {
  try {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password)
        .then((value) =>
        Firestore.instance.collection('user').document(value.user.uid).setData({
          "uid": value.user.uid,
          "email": value.user.email,
          "name": name,
          "phno": phno,
        })).then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage())));
  } catch (e){
      print(e.toString());
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
  }
}