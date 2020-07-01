
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:medicated/components/CustomKFDrawer.dart';
import 'package:medicated/components/Customloder.dart';

import 'GetUserData.dart';

class ProfilePage extends KFDrawerContent {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  GFAvatar userDefult;
  Future getData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    var firestore = Firestore.instance;
    DocumentSnapshot deta =await firestore.collection("user").document(uid).get();
    return deta.data;
  }
  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (context) {
          return Container(
              height:550,
              child: updateprofile());
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: widget.onMenuPressed),
      ),
      body: Container(
        child: ListView(
          children:<Widget>[
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                color: Colors.blue,
                height:300,
                padding: EdgeInsets.all(10),
                  child: FutureBuilder(
                  future: getData(),
                  builder: (_,snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: ColorLoader(),
                        );
                    } else {
                      if(snapshot.data['profilePics']==""||snapshot.data['profilePics']==null){
                          userDefult = GFAvatar(backgroundImage: AssetImage('assets/images/userDefault.png'),radius: 60,);
                      }else{
                        userDefult = GFAvatar(backgroundImage:NetworkImage(snapshot.data['profilePics']),radius: 60,);}
                      return Container(
                        height: 200,
                        child: Column(
                          children: [
                            userDefult,
                            Text(snapshot.data['name'],style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),),
                            Text(snapshot.data['email'],style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),),
                            Text(snapshot.data['phoneNo'],style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),),
                            FlatButton(onPressed: (){displayBottomSheet(context);}, child:
                            Text("update profile",style: TextStyle(
                              fontSize:12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),),)
                          ],
                        ),
                      );
                    }
                  }
                  ),
                ),
              ),
            ListTile(
              title: Text('My Doctors'),
              leading: Icon(Icons.local_hospital),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('My Appointments'),
              leading: Icon(Icons.calendar_today),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('Payments'),
              leading: Icon(Icons.account_balance_wallet),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('My Health'),
              leading: Icon(Icons.timeline),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('Delete Account'),
              leading: Icon(Icons.delete),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
