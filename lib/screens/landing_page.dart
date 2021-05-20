import 'package:ecommerce/constants.dart';
import 'package:ecommerce/screens/home_page.dart';
import 'package:ecommerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization =Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if(snapshot.connectionState == ConnectionState.done){

            // streamBuilder can check the login state live
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context,streamSnapshot){
                  if(streamSnapshot.hasError){
                    return Scaffold(
                      body: Center(
                        child: Text("Error: ${streamSnapshot.error}"),
                      ),
                    );
                  }

                  // connection state active do the user login check inside the if statement
                  else if(streamSnapshot.connectionState == ConnectionState.active){

                    // get the user
                    User _user = streamSnapshot.data;

                    // if the user is null
                    if(_user == null){
                      return LoginPage();
                    }else{
                      return HomePage();
                    }

                  }

                  // check the auth state
                  return Scaffold(
                    body: Center(
                      child: Text("check auth",style: Constants.regularHeading,),
                    ),
                  );
                }
            );
          }
          return Scaffold(
            body: Center(
              child: Text("initialized app loading"),
            ),
          );
        }
    );
  }
}