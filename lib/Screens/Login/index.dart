import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_register/firebase_login_register.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
import 'package:medicated/auth/auth.dart';
import 'package:medicated/components/Customloder.dart';
import 'package:medicated/components/googleSignIn.dart';
import 'CompleteRegister.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String email,password,displayName,surName,phoneNo,confPassword;
  final formKeyPhone = new GlobalKey<FormState>();
  String verificationId, smsCode;
  bool codeSent = false;
  int _state = 0;
  final formKeyReg = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  Widget Home() {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:height*0.2),
            child: Center(
              child: Icon(
                Icons.local_hospital,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Medicated",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top:50.0,bottom:10),
            child: TextFormField(
              obscureText: false,
              decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.phone,color:Colors.white),
                labelText: 'Phone Number',
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
                if(val.length!=10) {
                  return "phone cannot be empty";
                }else{
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  this.phoneNo = value;
                });//get the value entered by user.
              },
              keyboardType: TextInputType.phone,
              style: new TextStyle(
                height: 1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Museo",
                color: Colors.white,
              ),
            ),
          ),
          codeSent ?Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top:10.0,bottom:10),
            child: TextFormField(
              obscureText: false,
              decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.lock,color:Colors.white),
                labelText: 'OTP',
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
                if(val.length==null) {
                  return "OTP cannot be empty";
                }else{
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  this.smsCode = value;
                });//get the value entered by user.
              },
              keyboardType: TextInputType.number,
              style: new TextStyle(
                height: 1.0,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Museo",
                color: Colors.white,
              ),
            ),
          ):Container(),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top:10.0,bottom: 20),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed: () {
                      codeSent ? signInWithOTP(smsCode, verificationId):verifyPhone(phoneNo);
                    },
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: codeSent ? Text(
                              "VERIFY",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),):Text(
                              "SEND OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GoogleSignIn(
            google: DecorationImage(image:AssetImage('assets/images/google.png')),
            facebook: DecorationImage(image:AssetImage('assets/images/facebook.png')),
            onEmail:(){
              gotoLogin();
            },
          ),
        ],
      ),
    );
  }
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds).then((value) =>
    {
      if(value.additionalUserInfo.isNewUser){
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => CompleteRegistration(isNumber:true,data:this.phoneNo,)))
      }else{
        Firestore.instance.collection("user").document(value.user.uid).get()
            .then((DocumentSnapshot result) =>
        (result["CompleteRegister"]==true)?
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title:result['name'],uid:result['phoneNo'],image:result['profilePics']))):
        Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteRegistration(isNumber:true,data:this.phoneNo,)))
        )
      }
    }
    );
  }
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 120),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
  Widget LoginPage() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.withOpacity(0.3),
      child: new ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin:EdgeInsets.only(top: width*0.3),
                    padding: EdgeInsets.symmetric(horizontal: width*0.1),
                    child: Form(
                        key:formKey,
                        child: new Column(
                          children: <Widget>[
                            Container(
                              margin:EdgeInsets.all(5),
                              child: Text('Login',style:
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
                                  height: 56,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: width*0.01),
                                    child :InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () async{
                                        try {
                                          if (formKey.currentState.validate()) {
                                            signInE(email, password, context);
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
                ],
              ),
              Container(
                width: width*0.55,
                padding: EdgeInsets.symmetric(vertical:width*0.02),
                child :GestureDetector(
                  onTap: (){gotoSignup();},
                  child: Text(
                    "Don't have an account? Sign Up",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget SignupPage() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.withOpacity(0.3),
      child: new ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin:EdgeInsets.only(top: width*0.3),
                    padding: EdgeInsets.symmetric(horizontal: width*0.1),
                    child: Form(
                        key:formKeyReg,
                        child: new Column(
                          children: <Widget>[
                            Container(
                              margin:EdgeInsets.all(5),
                              child: Text('Register',style:
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
                                  color: Colors.white,
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
                                    return "Password cannot be empty";
                                  }else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  confPassword = value; //get the value entered by user.
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                  color: Colors.white,
                                  height: 1.0,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical:5),
                                child: SizedBox(
                                  height: 56,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: width*0.01),
                                    child :InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () async{
                                        try {
                                          if (formKeyReg.currentState.validate()) {
                                            if (password == confPassword) {
                                              signUp(email, password, context);
                                              setState(() {
                                                if (_state == 0) {
                                                  animateButton();
                                                }
                                              });
                                            }else{
                                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Password and Confirm password did not match')));
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
                            )],
                        )
                    ),
                  ),
                ],
              ),
              Container(
                width: width*0.55,
                padding: EdgeInsets.symmetric(vertical:width*0.02),
                child :GestureDetector(
                  onTap: (){
                    gotoLogin();
                  },
                  child: Text(
                    "Don't have an account? Sign In",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage('assets/images/appbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: PageView(
              controller: _controller,
              physics: new AlwaysScrollableScrollPhysics(),
              children: <Widget>[LoginPage(), Home(), SignupPage()],
              scrollDirection: Axis.horizontal,
            )),
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