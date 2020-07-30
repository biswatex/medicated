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

import '../../main.dart';


class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({Key key}) : super(key: key);
  @override
  _CompleteRegistrationState createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
  String email,password,displayName,surName,phone,confPassword;
  int _state = 0;
  final formKeyReg = GlobalKey<FormState>();
  String birthDateInString;
  bool isNumber;
  String dataa;
  final format = DateFormat("yyyy-MM-dd");
  String _result = "";
  int _radioValue = 0;
  DateTime dob;
  showError(text){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Error'),
        content: new Text(text),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
  getuser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null){
      if(user.email != null){
        setState(() {
          dataa = user.email;
          isNumber = false;
        });
      }else if(user.phoneNumber != null){
        setState(() {
          dataa = user.phoneNumber;
          isNumber = true;
        });
      }else{
        setState(() {
          dataa = null;
          isNumber = null;
        });
      }
    }else{
      setState(() {
        dataa = null;
        isNumber = null;
      });
    }
  }
  @override
  void initState(){
    getuser();
    super.initState();
  }
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
  Future continueRegister(displayName,surName,dob,gender,context,phoneno,email)async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePics/${user.uid + Path.extension(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete.then((value) =>
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL;
          });
        })).then((value) =>
        Firestore.instance
            .collection("user")
            .document(user.uid)
            .updateData({
          "profilePics":_uploadedFileURL,
          "uid": user.uid,
          "name": displayName,
          "surname": surName,
          "email":email,
          "phoneNo":phoneno,
          "dob":dob,
          "gender":gender,
          "CompleteRegister":true,
        })).then((result) => {Navigator.push(context, MaterialPageRoute(
        builder: (context) => Loading()))}
    );
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Authu()));
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation:0,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        title:Text('Just One More step !',style:
          TextStyle(
            fontFamily: 'Museo',
            fontSize:22,
            color: Colors.white,
          ),
        ),
        centerTitle:true,
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        color: Colors.redAccent,
          child: Form(
                key:formKeyReg,
                child: Container(
                  margin: new EdgeInsets.symmetric(horizontal:width*0.07),
                  child: Container(
                        child: ListView(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: (){getImage();},
                                child: CircleAvatar(
                                  radius: width*0.2,
                                  backgroundColor: Colors.red,
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
                                  color:Colors.white,
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
                                  color:Colors.white,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            (isNumber==null)?Padding(
                              padding: const EdgeInsets.symmetric(vertical:5.0),
                              child: TextFormField(
                                obscureText: false,
                                decoration: new InputDecoration(
                                  prefixIcon: new Icon(Icons.person,color:Colors.white),
                                  labelText: 'Email',
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
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(val)) {
                                    return 'Email format is invalid';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  email = value; //get the value entered by user.
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                  height: 1.0,
                                  fontSize: 14,
                                  color:Colors.white,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ):Padding(
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
                                  phone = value; //get the value entered by user.
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
                            Padding(
                              padding: EdgeInsets.symmetric(vertical:5.0),
                              child: DateTimeField(
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
                                  new Text('Male',
                                    style:TextStyle(
                                      color: Colors.white,
                                      height: 1.0,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('Female',
                                    style:TextStyle(
                                      color: Colors.white,
                                      height: 1.0,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),),
                                  new Radio(
                                    activeColor: Colors.white,
                                    value: 2,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('Others',
                                    style:TextStyle(
                                      color: Colors.white,
                                      height: 1.0,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
          ),
        ),
      bottomNavigationBar:Container(
          width: width,
          color: Colors.redAccent,
          child: SizedBox(
            height: width*0.15,
            child: Container(
              color: Colors.redAccent,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal:width*0.2),
              child :InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () async{
                  setState(() {
                    _state = 1;
                  });
                  try {
                    if(_image!=null){
                      if (formKeyReg.currentState.validate()) {
                        if(isNumber == true) {
                          await continueRegister(
                              displayName,
                              surName,
                              dob,
                              _result,
                              context,
                              dataa,
                              email);
                        }else if(isNumber == false){
                          await continueRegister(
                              displayName,
                              surName,
                              dob,
                              _result,
                              context,
                              phone,
                              dataa);
                        }else{
                          await continueRegister(
                              displayName,
                              surName,
                              dob,
                              _result,
                              context,
                              phone,
                              email);
                        }
                      }
                    }else{
                      showError("Please Add Image");
                    }
                  }catch(e){
                    setState(() {
                      _state = 0;
                    });
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
                    child:(_state==0)?Text("SignUp",
                      style: TextStyle(
                        fontFamily: 'Museo',
                        fontSize:22,
                        color: Colors.red,
                      ),
                    ):
                    ColorLoader(
                      dotOneColor: Colors.purple,
                      dotTwoColor: Colors.pink,
                      dotThreeColor: Colors.red,
                      duration: Duration(seconds:2),
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
