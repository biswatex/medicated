import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicated/auth/auth.dart';
import 'package:medicated/components/Customloder.dart';
import 'package:medicated/components/flipView.dart';
import 'package:medicated/components/googleSignIn.dart';
import 'package:medicated/components/passwordReset.dart';
import 'package:path/path.dart' as Path;
import 'styles.dart';
import 'dart:io';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final formKeyReg = GlobalKey<FormState>();
  bool showProgress = false;
  String email, password,confPassword,phoneNo,displayName,surName;
  AnimationController _animationController;
  Animation<double> _curvedAnimation;
  FocusNode _focusNode = FocusNode();
  var animationStatus = 0;
  int _state = 0;
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
  Future UpdateProfile() async {
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
            }
        ));
  }
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.addStatusListener((AnimationStatus status) {
      if (!_focusNode.hasFocus && _animationController.isCompleted) {
        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
          print('complete  ${_focusNode.hasFocus}');
        });
      }else if(_focusNode.hasFocus && !_animationController.isCompleted){
        _focusNode.unfocus();
      }
    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Are you want to exit?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
  }
  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (ctx) {
          return PasswordReset();
        });
  }
  void _flip(bool reverse) {
    if (_animationController.isAnimating) return;
    if (reverse) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  @override
  Widget build(BuildContext context) {
    //var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    timeDilation = 0.4;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return
        (new WillPopScope(
          onWillPop: _onWillPop,
               child : Scaffold(
                body: new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: <Color>[
                        Colors.pink,
                        Colors.purple[900],
                      ],
                      stops: [0.2, 1.0],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 1.0),
                    )),
                child: new Container(
                    decoration: new BoxDecoration(
                      image: backgroundImage,
                    ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right:width*0.02 ,
                                    top:width*0.09,
                                    bottom:width*0.02 ,
                                    left:width*0.02),
                                child: FlipView(
                                  animationController: _curvedAnimation,
                                  front: _login(),
                                  back: _register(),
                                ),
                              ),
                          ),
                        ),
                      ),
                    )
        );
  }
  Widget _register(){
    var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Colors.transparent,
              child: ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                children:<Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin:EdgeInsets.symmetric(vertical:10),
                      child: Text('Mediacative',style:
                      TextStyle(
                        fontFamily: 'Museo',
                        fontSize:22,
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  Form(
                     key:formKeyReg,
                      child: Container(
                        margin: new EdgeInsets.symmetric(horizontal:width*0.07),
                        child: Column(
                          children:<Widget>[
                            Container(
                              height:MediaQuery.of(context).size.height*0.6,
                              child: ListView(
                                padding: EdgeInsets.all(0),
                                children: <Widget>[
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
                                        prefixIcon: new Icon(Icons.email,color:Colors.white),
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
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical:2.0),
                                    child: TextFormField(
                                      obscureText: false,
                                      decoration: new InputDecoration(
                                        prefixIcon: new Icon(Icons.vpn_key,color:Colors.white),
                                        labelText: 'Password',
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
                                        if(val.length==0) {
                                          return "Password cannot be empty";
                                        }else{
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        password = value; //get the value entered by user.
                                      },
                                      keyboardType: TextInputType.visiblePassword,
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
                                        prefixIcon: new Icon(Icons.vpn_key,color:Colors.white),
                                        labelText: 'Confirm Password',
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
                                        if(val.length==0) {
                                          return "password cannot be empty";
                                        }else{
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        confPassword = value; //get the value entered by user.
                                      },
                                      keyboardType: TextInputType.visiblePassword,
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
                                        height: 1.0,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
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
                                            if (password == confPassword) {
                                              await signUp(email,password,displayName,surName,phoneNo,context);
                                              setState(() {
                                                if (_state == 0)
                                                animateButton();
                                              });
                                            }else{
                                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Password and Confirm password are not match')));
                                            }
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
                            ), ////cut
                            FlatButton(
                              padding: EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              onPressed: (){_flip(false);},
                              child: Text(
                                "Already an account? Sign In",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                    fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                ],
              ),
    );
  }
  Widget _login(){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Colors.transparent,
        child: Container(
          child: new ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: width*0.2,
                        height: width*0.2,
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: tick,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width*0.1),
                        child: Form(
                            key:formKey,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin:EdgeInsets.all(5),
                                  child: Text('Mediacative',style:
                                  TextStyle(
                                    fontFamily: 'Museo',
                                    fontSize:22,
                                    color: Colors.white,
                                  ),),
                                ),
                                Padding(
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
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:5.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: new InputDecoration(
                                      prefixIcon: new Icon(Icons.lock,color:Colors.white),
                                      labelText: 'Password',
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
                                      if(val.length==0) {
                                        return "Password cannot be empty";
                                      }else{
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      password = value; //get the value entered by user.
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: new TextStyle(
                                      height: 1.0,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical:5),
                                  child: SizedBox(
                                    height: width*0.15,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: width*0.01),
                                      child :InkWell(
                                        borderRadius: BorderRadius.circular(30),
                                        onTap: () async{
                                          try {
                                            if (formKey.currentState.validate()) {
                                              signIn(email, password, context);
                                              setState(() {
                                                if (_state == 0) {
                                                  animateButton();
                                                }
                                              });}
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
                                            child: setUpButtonChild("SignIn"),
                                          ),
                                        ),
                                      ),
                                    ),
                                )
                                )],
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical:width*0.02),
                        width: width*0.35,
                        alignment: AlignmentDirectional.center,
                        child: GestureDetector(
                          onTap:() =>  displayBottomSheet(context),
                          child:  AutoSizeText(
                            "Forgot password ?",
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: new TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: width*0.55,
                    padding: EdgeInsets.symmetric(vertical:width*0.02),
                    child :GestureDetector(
                      onTap: (){_flip(true);},
                      child: AutoSizeText(
                        "Don't have an account? Sign Up",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Center(child: GoogleSignIn(google: googleimg,facebook:facebookimg)),
                ],
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
