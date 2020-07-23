import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicated/Screens/Home/MainPage.dart';
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

  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
      if (currentUser == null)
        {Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginScreen()),)}
      else
        {
          Firestore.instance.collection('user').document(currentUser.uid).get().then((value) =>
              Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(title:value['name'],uid:value['phoneNo'],image:value['profilePics'],)),
          )),
          }
    })
        .catchError((err) => print(err));
    super.initState();
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
