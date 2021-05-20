
import 'package:ecommerce/widgets/custom_input.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // alertDialog to used in an errors
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
  Future<String> _createAccount() async{
    try{
       await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword,
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
      _registerFromLoading = true;
    });

    String _createAccountFeedBack = await _createAccount();
    if(_createAccountFeedBack != null){
      _alertDialogBuilder(_createAccountFeedBack);

      setState(() {
        _registerFromLoading = false;
      });
    }else{
      Navigator.pop(context);
    }
  }

  //default form loading state
  bool _registerFromLoading = false;

  // 1-form input field values
  String _registerEmail = "";
  String _registerPassword= "";

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
                    "Create A New Account",
                    style: Constants.boldHeading,
                    textAlign:TextAlign.center ,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(
                      hintText: "Email....",
                      onChanged: (value){
                        _registerEmail = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next ,
                    ),
                    CustomInput(
                      hintText: "Password....",
                      onChanged: (value){
                        _registerPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value){
                        _submitForm();
                      },
                    ),
                    CustomButton(
                      text: "Create Account",
                      onPressed: (){
                        _submitForm();
                      },
                       isLoading: _registerFromLoading,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18.0,
                  ),
                  child: CustomButton(
                    text: "Back to Login",
                    onPressed: (){
                     Navigator.pop(context);
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
