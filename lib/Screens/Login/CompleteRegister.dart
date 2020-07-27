import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
import 'package:medicated/components/Customloder.dart';
import 'package:path/path.dart' as Path;


class CompleteRegistration extends StatefulWidget {
  @override
  _CompleteRegistrationState createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {

  String email,password,displayName,surName,phoneNo,confPassword;
  int _state = 0;
  final formKeyReg = GlobalKey<FormState>();
  String birthDateInString;
  final format = DateFormat("yyyy-MM-dd");
  String _result = "";
  int _radioValue = 0;
  DateTime dob;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _result = "Male";
      break;
      case 1:
      _result = "Female";
      break;
      case 2:
      _result = "Others";
      break;
      }
      });
  }
  File _image;
  String _uploadedFileURL;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  Future continueRegister(displayName,surName,phoneNo,dob,gender,context)async{
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
        Firestore.instance
            .collection("user")
            .document(uid)
            .setData({
          "profilePics":_uploadedFileURL,
          "uid": uid,
          "name": displayName,
          "surname": surName,
          "email": user.email,
          "phoneNo":phoneNo,
          "dob":dob,
          "gender":gender,
          "CompleteRegister":true,
        })).then((result) => {Navigator.push(context, MaterialPageRoute(
        builder: (context) => HomePage(title:displayName,uid:phoneNo,image:_uploadedFileURL,)))}
    );
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height:MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top:36),
        color: Colors.blueGrey,
          child: Form(
                key:formKeyReg,
                child: Container(
                  margin: new EdgeInsets.symmetric(horizontal:width*0.07),
                  child: Container(
                        child: ListView(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin:EdgeInsets.symmetric(vertical:10),
                                child: Text('Just One More step !',style:
                                TextStyle(
                                  fontFamily: 'Museo',
                                  fontSize:22,
                                  color: Colors.white,
                                ),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: (){getImage();},
                                child: CircleAvatar(
                                  radius: width*0.2,
                                  backgroundColor: Colors.grey,
                                  child: ClipOval(
                                    child: new SizedBox(
                                      width: width*0.3,
                                      height: width*0.3,
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
                              padding: EdgeInsets.symmetric(vertical:2.0),
                              child: TextFormField(
                                obscureText: false,
                                decoration: new InputDecoration(
                                  prefixIcon: new Icon(Icons.person,color:Colors.white),
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white12,
                                  filled: true,
                                  border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                  focusedBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
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
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                  height: 1.0,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:2.0),
                              child: TextFormField(
                                obscureText: false,
                                decoration: new InputDecoration(
                                  prefixIcon: new Icon(Icons.person,color:Colors.white),
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white12,
                                  filled: true,
                                  border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                  focusedBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
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
                              padding: const EdgeInsets.symmetric(vertical:2.0),
                              child: TextFormField(
                                obscureText: false,
                                decoration: new InputDecoration(
                                  prefixIcon: new Icon(Icons.call,color:Colors.white),
                                  labelText: 'Phone No',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white12,
                                  filled: true,
                                  border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                  focusedBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                      )),
                                ),
                                validator: (val) {
                                  if(val.length<10) {
                                    return "Phone No can not be less than 10";
                                  }else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  phoneNo = value; //get the value entered by user.
                                },
                                keyboardType: TextInputType.number,
                                style: new TextStyle(
                                  color: Colors.white,
                                  height: 1.0,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            DateTimeField(
                              validator:(val) {
                                if(val==null) {
                                  return "Select DOB";
                                }else{
                                  return null;
                                }
                              },
                              style: new TextStyle(
                                color: Colors.white,
                                height: 1.0,
                                fontSize: 14,
                                fontFamily: "Poppins",
                              ),
                              decoration:new InputDecoration(
                                prefixIcon: new Icon(Icons.cake,color:Colors.white),
                                labelText: 'Date Of Birth',
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white12,
                                filled: true,
                                border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(
                                      color: Colors.white,
                                    )),
                                focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(
                                      color: Colors.white,
                                    )),
                                enabledBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(
                                      color: Colors.white,
                                    )),
                              ),
                              format: format,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              onChanged: (val){
                                dob = val;
                              },
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Radio(
                                    value: 0,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('Male'),
                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('Female'),
                                  new Radio(
                                    activeColor: Colors.white,
                                    value: 2,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('Others'),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top:10),
                                child: SizedBox(
                                  height: width*0.15,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: width*0.01),
                                    child :InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () async{
                                        try {
                                          if (formKeyReg.currentState.validate()) {
                                            await continueRegister(displayName, surName, phoneNo, dob, _result, context);
                                            setState(() {
                                              if (_state == 0)
                                                animateButton();
                                            });
                                          }
                                        }catch(e){
                                        }
                                      },
                                      splashColor: Colors.blue,
                                      highlightColor: Colors.blue,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: setUpButtonChild("SignUp"),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                ),
          ),
        ),
    );
  }
  Widget setUpButtonChild(String text) {
    if (_state == 0) {
      return new Text(
        text,
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
