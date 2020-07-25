import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future f;
  var fireStore = Firestore.instance;
  initState(){
    super.initState();
    f = getNotifications();
  }
  getNotifications() async{
    FirebaseUser user =  await FirebaseAuth.instance.currentUser();
    QuerySnapshot q = await fireStore.collection('user')
        .document(user.uid).collection("savedNotification").getDocuments();
    return q.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    if (snapshot.data.length == 0 ||
                        snapshot.data.length == null) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text("you dont have any notifications"),);
                    } else {
                      final item = snapshot.data[i].data['title'];
                      if(snapshot.data[i].data['notification']['data']['image'] == null) {
                        return Dismissible(
                          key: Key(item),
                          onDismissed: (direction) async {
                            FirebaseUser user = await FirebaseAuth.instance
                                .currentUser();
                            fireStore.collection('user').document(user.uid)
                                .collection('savedNotification').document(
                                snapshot
                                    .data[i].documentID)
                                .delete();
                            setState(() {
                              snapshot.data[i].removeAt(i);
                            });
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(content: Text(
                                "$item dismissed")));
                          },
                          background: Container(color: Colors.red),
                          child: Card(
                            child: ListTile(
                              title: Text(snapshot.data[i]
                                  .data['notification']['notification']['title']),
                              subtitle: Text(snapshot.data[i]
                                  .data['notification']['notification']['body']),
                              trailing: GestureDetector(
                                  onTap: () async {
                                    FirebaseUser user = await FirebaseAuth
                                        .instance
                                        .currentUser();
                                    fireStore.collection('user').document(
                                        user.uid)
                                        .collection('savedNotification').document(
                                        snapshot.data[i].documentID)
                                        .delete();
                                    setState(() {
                                      snapshot.data[i].removeAt(i);
                                    });
                                    Scaffold.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                            content: Text("$item dismissed")));
                                  },
                                  child: Icon(Icons.clear)),
                            ),
                          ),
                        );
                      }else{
                        return
                          Dismissible(
                            key: Key(item),
                            onDismissed: (direction) async {
                              FirebaseUser user = await FirebaseAuth.instance
                                  .currentUser();
                              fireStore.collection('user').document(user.uid)
                                  .collection('savedNotification').document(
                                  snapshot
                                      .data[i].documentID)
                                  .delete();
                              setState(() {
                                snapshot.data[i].removeAt(i);
                              });
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text(
                                  "$item dismissed")));
                            },
                            background: Container(color: Colors.red),
                            child: GFCard(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              image: Image.network(snapshot.data[i]
                                  .data['notification']['data']['image']),
                              title: GFListTile(
                                title: Text(snapshot.data[i]
                                    .data['notification']['notification']['title']),
                                subtitleText: snapshot.data[i]
                                    .data['notification']['notification']['body'],
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          );
                      }
                    }
                  }
              );
          }else{
            return Container(
              alignment: Alignment.center,
              child: Text("loading notifications"),);
          }
        }
      ),
    );
  }
}
