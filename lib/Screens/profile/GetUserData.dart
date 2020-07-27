import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicated/components/Customloder.dart';
import 'package:path/path.dart' as Path;


class updateprofile extends StatefulWidget {
  @override
  _UpdateProfile createState() => _UpdateProfile();
}
class _UpdateProfile extends State<updateprofile> {
  File _image;
  String _uploadedFileURL;
  final formKeyUpdate = GlobalKey<FormState>();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  Future UpdateProfile(name,surname,phoneNo) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePics/${uid + Path.extension(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete.then((value) =>
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL;
          });
        })).then((value) =>
        Firestore.instance.collection('user').document(uid).updateData(
            {
              "profilePics": _uploadedFileURL,
              "name":name,
              "surname":surname,
              "phoneNo":phoneNo
            }
        ));
  }
  int _state = 0;
  String surName,displayName,phoneNo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        child: ListView(
          children:<Widget>[
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: (){getImage();},
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: new SizedBox(
                      width: 180,
                      height: 180,
                      child: (_image!=null)?Image.file(
                        _image,
                        fit: BoxFit.fill,
                      ):Image.asset("assets/images/add.png",fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:5.0),
              child: TextFormField(
                obscureText: false,
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.person,color:Colors.blue),
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.blue),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                  focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                ),
                validator: (val) {
                  // ignore: unrelated_type_equality_checks
                  if (val == 0) {
                    return 'First name can not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  displayName = value; //get the value entered by user.
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  height: 1.0,
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:5.0),
              child: TextFormField(
                obscureText: false,
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.person,color:Colors.blue),
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.blue),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                  focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                ),
                validator: (val) {
                  // ignore: unrelated_type_equality_checks
                  if (val == 0) {
                    return 'Last name can not be Empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  surName = value; //get the value entered by user.
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  height: 1.0,
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:5.0),
              child: TextFormField(
                obscureText: false,
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.person,color:Colors.blue),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.blue),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                  focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      )),
                ),
                validator: (val) {
                  // ignore: unrelated_type_equality_checks
                  if (val.length < 10) {
                    return 'phone can not be less than 10';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  phoneNo = value; //get the value entered by user.
                },
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  height: 1.0,
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 60,
                  child: Container(
                    color: Colors.blue,
                    child :InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async{
                        try {
                          setState(() {
                            if (_state == 0) {
                              animateButton();
                            }
                          });
                            await UpdateProfile(displayName,surName,phoneNo);
                            Navigator.of(context).pop();
                        }catch(e){
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: setUpButtonChild("Update Profile"),
                        ),
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
Widget setUpButtonChild(String text) {
  if (_state == 0) {
    return new Text(
      text,
      style: const TextStyle(
        color: Colors.white,
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
}