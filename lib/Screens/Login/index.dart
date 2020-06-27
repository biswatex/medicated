import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:medicated/auth/auth.dart';
import 'package:medicated/components/flipView.dart';
import 'package:medicated/components/googleSignIn.dart';
import 'package:medicated/components/passwordReset.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'styles.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _checking = false;
  bool _checkReg = false;
  final formKey = GlobalKey<FormState>();
  final formKeyReg = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password,confPassword,phoneNo;
  AnimationController _animationController;
  Animation<double> _curvedAnimation;
  FocusNode _focusNode = FocusNode();
  var animationStatus = 0;
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    timeDilation = 0.4;
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
                                padding: const EdgeInsets.all(30.0),
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
    var height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Colors.transparent,
            child: ModalProgressHUD(
              inAsyncCall: _checkReg,
              child: Column(
                children:<Widget>[
                  Container(
                    width: width*0.4,
                    margin: EdgeInsets.only(top: 50),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: tick,
                    ),
                  ),
                  Container(
                    margin:EdgeInsets.only(bottom: 10),
                    child: Text('medicated',style:
                    TextStyle(
                      fontFamily: 'Sriracha',
                      fontSize:22,
                      color: Colors.white,
                    ),),
                  ),
                  Form(
                     key:formKeyReg,
                      child: Container(
                        padding: EdgeInsets.only(top: 2),
                        margin: new EdgeInsets.symmetric(horizontal: 70.0),
                        child: Column(
                          children:<Widget>[
                            Container(
                              height: 500,
                              child: new ListView(
                                children: <Widget>[
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
                                      obscureText: false,
                                      decoration: new InputDecoration(
                                        prefixIcon: new Icon(Icons.person,color:Colors.white),
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
                                    padding: const EdgeInsets.symmetric(vertical:5.0),
                                    child: TextFormField(
                                      obscureText: false,
                                      decoration: new InputDecoration(
                                        prefixIcon: new Icon(Icons.person,color:Colors.white),
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
                                    padding: const EdgeInsets.symmetric(vertical:5.0),
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
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 60,
                                width: 320,
                                child: FlatButton(onPressed: () async {
                                  if (formKeyReg.currentState.validate()) {
                                    if (password == confPassword) {
                                        signUp(email, password,'default', phoneNo,context);
                                    }
                                  }else{
                                    Scaffold
                                        .of(context)
                                        .showSnackBar(SnackBar(content: Text('Password and Confirm password are not match')));                                }
                                  },
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                    color: Colors.white,
                                    child: Text('SignUp',style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold),)),
                              ),
                            )
                          ],
                        ),
                      ),
                  ),
                  FlatButton(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      onPressed: (){_flip(false);},
                      child: new Text(
                        "Already an account? Sign In",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: new TextStyle(
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontSize: 14.0),
                      ),
                    ),
                ],
              ),
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
      child: ModalProgressHUD(
          inAsyncCall: _checking,
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
                        width: width*0.5,
                        height: height*0.2,
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
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
                                  margin:EdgeInsets.only(bottom: 15),
                                  child: Text('medicated',style:
                                  TextStyle(
                                    fontFamily: 'Sriracha',
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
                                  padding: EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    height: 60,
                                    width: width*0.7,
                                    child: FlatButton(onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        _checking = true;
                                        signIn(email, password, context);
                                      }
                                    },
                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                        color: Colors.white,
                                        child: Text('SignIn',style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold),),
                                  ),
                                )
                                )],
                            )
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.center,
                        child: FlatButton(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            right: 10,
                          ),
                          onPressed:() =>  displayBottomSheet(context),
                          child: new Text(
                            "Forgot password ?",
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: new TextStyle(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5,
                                color: Colors.white,
                                fontSize: 14.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child :FlatButton(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      onPressed: (){_flip(true);},
                      child: new Text(
                        "Don't have an account? Sign Up",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: new TextStyle(
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  Center(child: GoogleSignIn(google: googleimg,facebook:facebookimg)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
