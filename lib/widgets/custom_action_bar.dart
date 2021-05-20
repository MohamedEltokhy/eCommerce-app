
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/screens/cart_page.dart';
import 'package:ecommerce/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;

  CustomActionBar({this.title, this.hasBackArrow,this.hasTitle,this.hasBackground});

  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _userRef =
  FirebaseFirestore.instance.collection("Users");



  @override
  Widget build(BuildContext context) {

    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle =hasTitle ?? true;
    bool _hasBackground = hasBackground ?? true;


    return  Container(
      decoration: BoxDecoration(
        gradient: _hasBackground ? LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0)
            ],
          begin: Alignment(0,0),
          end: Alignment(0,1),
        ):null,
      ),
      padding: EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(_hasBackArrow)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 6.0,),
                height: 42.0,
                width: 42.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 18,),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                 ),
              ),
            ),
          if(_hasTitle)
            Text(
            title ?? "Action Bar",
            style: Constants.boldHeading,
            ),
          GestureDetector(
            onTap: (){
             var route = MaterialPageRoute(builder: (context)=> CartPage());
             Navigator.push(context, route);
            },
            child: Container(
              height: 42.0,
              width: 42.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius:BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: _userRef.doc(_firebaseServices.getUserId()).collection("Cart").snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;

                  if(snapshot.connectionState == ConnectionState.active){
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }

                  return Text(
                    "$_totalItems" ?? "0",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
