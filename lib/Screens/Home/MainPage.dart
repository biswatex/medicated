import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:medicated/Screens/profile/MyAppointment.dart';
import 'package:medicated/Screens/profile/PeofileScreen.dart';
import 'package:medicated/components/CustomKFDrawer.dart';
import 'package:medicated/drawerFragments/FragmentAbout.dart';
import 'package:medicated/drawerFragments/FragmentContactUs.dart';
import 'package:medicated/drawerFragments/FragmentFeedback.dart';
import 'package:medicated/drawerFragments/FragmentSettings.dart';
import 'package:medicated/drawerFragments/fragmentHome.dart';
import 'package:medicated/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utility.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future f;
  Future getData()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snapshot = await Firestore.instance.collection('user').document(user.uid).get();
    return snapshot;
  }
  @override
  void initState() {
    f = getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: f,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return  HomePage(title: snapshot.data['name'], uid: snapshot.data['uid'], imageo: snapshot.data['profilePics'],);
        }else{
          return Container();
        }
      }
    );
  }
}

class HomePage extends StatefulWidget {
  final title;
  final uid;
  final imageo;
  HomePage({Key key, this.title, this.uid, this.imageo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int counter = 10;
  KFDrawerController _drawerController;
  @override
  initState(){
    getSF();
    super.initState();
    String name ;
    String uide;
    String image;
    if(widget.title!=null && widget.uid != null && widget.imageo!=null) {
      name = widget.title;
      uide = widget.uid;
      image = widget.imageo;
    }
    else if(widget.imageo==null && widget.title!=null && widget.uid!= null){
      name = widget.title;
      uide = widget.uid;
      image = "https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png";
    }else{
      uide ="+91 1800000100";
      name = "User";
      image = "https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png";
    }
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('FragmentHome'),
      items: [
        KFDrawerItem.initWithPage(
          text: AutoSizeText(name,
              maxLines: 1,
              minFontSize: 12,
              maxFontSize: 16,
              style: TextStyle(color: Colors.white)),
          subtitle: AutoSizeText(uide,
            maxLines: 1,
            minFontSize: 8,
            maxFontSize: 12,
            style: TextStyle(color: Colors.white),),
          icon:GFAvatar(
            backgroundImage: NetworkImage(image)),
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
          text: Text('Appointments', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.calendar_today, color: Colors.white),
          page: MyAppointment(fromDrawer:true),
          header: false,
        ),
        KFDrawerItem.initWithPage(
          divider: true,
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
    prefs.setString('email',widget.uid);
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authu())));
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