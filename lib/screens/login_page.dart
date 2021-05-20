
import 'dart:ui';

import 'package:ecommerce/constants.dart';
import 'package:ecommerce/screens/register_page.dart';
import 'package:ecommerce/widgets/custom_input.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title:Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Close Dialog")
              ),
            ],
          );
        }
    );
  }

  // create a new user account
  Future<String> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginEmail,
        password: _loginPassword,
      );
      return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    }catch(e){
      return e.toString();
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFromLoading = true;
    });

    String _loginFeedBack = await _loginAccount();
    if(_loginFeedBack != null){
      _alertDialogBuilder(_loginFeedBack);

      setState(() {
        _loginFromLoading = false;
      });
    }else{
      Navigator.pop(context);
    }
  }

  //default form loading state
  bool _loginFromLoading = false;

  // 1-form input field values
  String _loginEmail = "";
  String _loginPassword= "";

  //2-focus node for input fields
  FocusNode _passwordFocusNode;


  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  "Welcome Dear ,\n Login to your account",
                  style: Constants.boldHeading,
                  textAlign:TextAlign.center ,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email....",
                    onChanged: (value){
                      _loginEmail = value;
                    },
                    onSubmitted: (value){
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next ,
                  ),
                  CustomInput(
                    hintText: "Password....",
                    onChanged: (value){
                      _loginPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value){
                      _submitForm();
                    },
                  ),
                  CustomButton(
                    text: "Login",
                    onPressed: (){
                      _submitForm();
                    },
                    isLoading: _loginFromLoading,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 18.0,
                ),
                child: CustomButton(
                  text: "Create New Account",
                  onPressed: (){
                    var route =MaterialPageRoute(builder: (context)=> RegisterPage());
                    Navigator.push(context,route);
                  },
                  outLineBtn: true,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
