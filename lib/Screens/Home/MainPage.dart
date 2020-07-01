import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/components/CustomKFDrawer.dart';
import 'package:medicated/Screens/Login/index.dart';
import 'package:medicated/Screens/profile/PeofileScreen.dart';
import 'package:medicated/drawerFragments/FragmentContactUs.dart';
import 'package:medicated/drawerFragments/FragmentFeedback.dart';
import 'Utility.dart';
import 'package:medicated/drawerFragments/FragmentAbout.dart';
import 'package:medicated/drawerFragments/FragmentSettings.dart';
import 'package:medicated/drawerFragments/fragmentHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String title;
  final String uid;
  final String image;
  HomePage({Key key, this.title,this.uid,this.image}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int counter = 10;
  KFDrawerController _drawerController;
  String _profileURL;
  getData()async{
    SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    return prefs;
  }
  @override
  // ignore: missing_return
  Future<void> initState() {
    getSF();
    super.initState();
    String name ;
    String uide;
    if(widget.title!=null && widget.uid != null) {
      name = widget.title;
      uide = widget.uid;
    }
    else{
      uide ="Default@medicative.com";
      name = "User";
    }
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('FragmentHome'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text(name, style: TextStyle(color: Colors.white)),
          subtitle: Text(uide, style: TextStyle(color: Colors.white)),
          icon:CircleAvatar(
            backgroundImage: NetworkImage(widget.image)),
          page: ProfilePage(),
          header: true,
        ),
        KFDrawerItem.initWithPage(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: FragmentHome(),
          header: false,
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'About',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.info, color: Colors.white),
          page: About(),
          header: false,
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.settings, color: Colors.white),
          page: Settings(),
          header: false,
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Feedback',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.feedback, color: Colors.white),
          page:FeedbackUs(),
          header: false,
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Contact Us',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.contact_phone, color: Colors.white),
          page: ContactUs(),
          header: false,
        ),
      ],
    );
  }
  getSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name',widget.title);
    prefs.setString('email', widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        footer: KFDrawerItem(
          text: Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.input,
            color: Colors.white,
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())));
          },
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink, Colors.blue],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}