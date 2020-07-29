import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
import 'package:medicated/Screens/Login/CompleteRegister.dart';
import 'package:medicated/Screens/Login/index.dart';
import 'package:medicated/components/Customloder.dart';
import 'NotificationHelper.dart';
import 'Screens/Home/Utility.dart';

Future<void> main() async{
  ClassBuilder.registerClasses();
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medicative Demo',
        home:  Auth(),
  ));
}
class Auth extends StatefulWidget {
  Auth({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<Auth> with TickerProviderStateMixin {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
      if (currentUser == null)
        {Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginScreen()),)}
      else
        {
          Firestore.instance.collection('user').document(currentUser.uid).get().then((value) =>
            (value['CompleteRegister']==true||value['CompleteRegister']!=null)?
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage(title:value['name'],uid:value['phoneNo'],image:value['profilePics'],)),
              ):Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CompleteRegistration()),
            )
          ),
        }
    });
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print('on message $message');
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);
        saveNotification(message);
        // _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message)async {
        print('on resume $message');
        saveNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('on launch $message');
        saveNotification(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });
  }
  Future<void> saveNotification(massage) async {
    FirebaseAuth.instance.currentUser().then((value) =>
        Firestore.instance.collection('user')
            .document(value.uid)
            .collection('savedNotification').add({'notification':massage}));
  }
  Future displayNotification(Map<String, dynamic> message) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'medicated', 'fcm', 'medicated notification channel',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',);
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)));
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Container(
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text("medicative")),
                    Padding(
                      padding: const EdgeInsets.only(bottom:100),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GoogleLoder()),
                    ),
                  ],
                ),
              )),
        ),
    );
  }
}
