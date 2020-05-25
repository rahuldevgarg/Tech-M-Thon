import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pcttechnician/Adapters/globals.dart';
import 'package:pcttechnician/Fonts/RDGFontsAndIcons.dart';

import 'package:pcttechnician/Providers/TechnicianProvider.dart';
import 'package:pcttechnician/database/FirebaseDirectory.dart';
import 'package:provider/provider.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import '../main.dart';
import 'package:pcttechnician/Screens/MyNavigation.dart';

class Login extends StatefulWidget {
  static const name = '/Login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseDirectory _firebaseDirectory = new FirebaseDirectory();
  bool isLoading = false;
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool obscure = true;

  final _loginFormKey = GlobalKey<FormState>();

  decoration(String text, IconData iconData) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(bottom: 0,left: 10),
      hintText: text,
      hintStyle: GoogleFonts.poppins(
          fontSize: getDeviceHeight(context)<=800?getDeviceHeight(context) * 0.025875:getDeviceHeight(context) * 0.021875,
          color: Colors.redAccent),
      hoverColor: Colors.red,
//      focusedBorder:
//      OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      focusColor: Colors.redAccent,
enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      labelStyle: TextStyle(color: Colors.black38),
      suffixIcon: iconData!=null?IconButton(
          icon: Icon(
            iconData,
            color: Colors.redAccent,
          ),
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          }):null,
    );
  }
  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }
  @override
  void initState() {
    LoginFromPrefs();
  }

  Future LoginFromPrefs() async {
    setState(() {
      isLoading =true;
    });
    await _firebaseDirectory.CheckLogin().then((value) async {

      if (value != null) {
        await Provider.of<TechnicianProvider>(context, listen: false)
            .getTechnicianFromUid(value).then((tuser) {
              signTechnician = tuser;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyNavigation()));
        });
      }else{
        setState(() {
          isLoading=false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        _exitAlert(context);
      },
      child: Scaffold(
        body: isLoading == true
            ? Container(
          height: getDeviceHeight(context),
              width: getDeviceWidth(context),
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
            )
            : Builder(
                builder: (context) => SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: getDeviceHeight(context),
                      width: getDeviceWidth(context),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: getDeviceWidth(context),
                            height: MediaQuery.of(context).padding.top,
                            color: Theme.of(context).accentColor,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: getDeviceHeight(context) * 0.03,
                                bottom: getDeviceHeight(context) * 0.03,
                                left: getDeviceWidth(context) * 0.311111111,
                                right: getDeviceWidth(context) * 0.311111111),
                            height: getDeviceHeight(context) * 0.2015625,
                            child: Center(
                                child: Image.asset('assets/images/logos/techmahindra.png')),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: getDeviceHeight(context) *
                                              0.021875,
                                          bottom: getDeviceHeight(context) *
                                              0.046875),
                                      child: Text(
                                        "Sign In",
                                        style: GoogleFonts.poppins(
                                            fontSize: getDeviceHeight(context)<=800?getDeviceHeight(context) * 0.038375:getDeviceHeight(context) *
                                                0.034375,
                                            color: Colors.red),
                                      ),
                                    )
                                  ],
                                ),
                                Form(
                                  key: _loginFormKey,
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: getDeviceWidth(context) *
                                                0.055555556,
                                            right: getDeviceWidth(context) *
                                                0.055555556),
                                        child: TextFormField(
                                          onEditingComplete: () {
                                            FocusNode().requestFocus(focusNode);
                                          },
                                          style: GoogleFonts.poppins(
                                              fontSize:
                                              getDeviceHeight(context)<=800?getDeviceHeight(context) * 0.025875:getDeviceHeight(context) *
                                                      0.021875,
                                              color: Colors.red),
                                          controller: user,
                                          cursorColor: Colors.redAccent,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          enableSuggestions: true,
                                          decoration:
                                              decoration("Username", null),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getDeviceHeight(context) * 0.040625,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: getDeviceWidth(context) *
                                                0.055555556,
                                            right: getDeviceWidth(context) *
                                                0.055555556),
                                        child: TextFormField(
                                          focusNode: focusNode,
                                          controller: password,
                                          cursorColor: Colors.redAccent,
                                          //cursorRadius: Radius.circular(0),
                                          style: GoogleFonts.poppins(
                                              fontSize:
                                              getDeviceHeight(context)<=800?getDeviceHeight(context) * 0.025875:getDeviceHeight(context) *
                                                      0.021875,
                                              color: Color(0xff464E4D)),
                                          obscureText: obscure,
                                          decoration: decoration(
                                              "Password",
                                              obscure == true
                                                  ? Icons.remove_red_eye
                                                  : Icons.remove_red_eye),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),

                                      SizedBox(
                                        height:
                                            getDeviceHeight(context) * 0.0625,
                                      ),
                                      GestureDetector(
                                        onTap: () {

                                          emailSignIn(mediaQuery);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: getDeviceWidth(context) *
                                                  0.041666667,
                                              right: getDeviceWidth(context) *
                                                  0.041666667),
                                          width: getDeviceWidth(context) *
                                              0.805555556,
                                          height: getDeviceHeight(context) *
                                              0.059375,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(color: Theme.of(context).accentColor)
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Sign In",
                                            style: GoogleFonts.poppins(
                                                color: Theme.of(context).accentColor,
                                                fontSize:
                                                getDeviceHeight(context)<=800?getDeviceHeight(context) * 0.025875:getDeviceHeight(context) *
                                                        0.021875,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
Future emailSignIn(mediaQuery)async{
  setState(() {
    isLoading =true;
  });
  await _firebaseDirectory.signInWithEmail(user.text.trim(), password.text).then((value) async {
    if(value!=null){
      await Provider.of<TechnicianProvider>(context, listen: false)
          .getTechnicianFromUid(value)
          .then((value) {
        if(value!=null){
          signTechnician = value;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyNavigation()));
        }else{
          Fluttertoast.showToast(
              msg: "User Not Found",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            isLoading = false;
          });
        }
      },onError: (userError)=>print(userError.toString()));
    }else{
      Fluttertoast.showToast(
          msg: _firebaseDirectory.errorMessage,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading = false;
      });
    }
  },onError: (error)=>Fluttertoast.showToast(
      msg: "Try Again",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 10.0));
}
  Future gsignin(mediaQuery) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _firebaseDirectory.signInWithGoogle().then((fireBaseUser) async {

        if(fireBaseUser!=null){
          await Provider.of<TechnicianProvider>(context, listen: false)
              .getTechnicianFromUid(fireBaseUser).then((value) {
            if(value!=null){
              print(value.name);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyNavigation()));

            }else{
              print("User Not Found");
              Fluttertoast.showToast(
                  msg: "Please Sign Up before Login",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black54,
                  toastLength: Toast.LENGTH_LONG,
                  textColor: Colors.white,
                  fontSize: 16);
              setState(() {
                isLoading =false;
              });

            }
          });

        }
      }
          );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Try Again",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: mediaQuery.height * 0.035);
    }
  }

  Future<void> _exitAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          content: const Text(
            'Do You want To Exit',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
