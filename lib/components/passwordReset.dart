import 'package:flutter/material.dart';

class PasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25),
          topRight: const Radius.circular(25),),
      ),
      padding: EdgeInsets.all(50),
      height: MediaQuery.of(context).size.height  * 0.5,
      child: ListView(
        children:<Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 50,top: 20,left: 20,right: 20),
            child: Text('Enter email id we will send password reset link',style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
          ),
          Container(
            height:60,
            padding: EdgeInsets.only(left: 50,right: 50),
            child: new TextFormField(
              obscureText: false,
              decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.email,color:Colors.white),
                labelText: 'Email ID',
                labelStyle: TextStyle(color: Colors.purple),
                fillColor: Colors.white12,
                filled: true,
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      width: 3,
                      color: Colors.purple,
                    )),
                focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      width: 3,
                      color: Colors.purple,
                    )),
                enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      width: 3,
                      color: Colors.purple,
                    )),
              ),
              validator: (val) {
                if(val.length==0) {
                  return "Email cannot be empty";
                }else{
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 50,right: 50,top: 20),
            child :InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {},
              splashColor: Colors.blue,
              highlightColor: Colors.blue,
              child: Container(
                height: 36,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text("Send Link",style: TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
