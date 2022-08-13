import 'dart:ui';

import 'package:chatty/Firebase/authentication.dart';
import 'package:chatty/Firebase/google_sign_in.dart';
import 'package:chatty/Pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  checkIfSignedIn(){
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if(user==null){

      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
      }

    });
  }
  @override
  initState(){
    checkIfSignedIn();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Superscript',
                style: TextStyle(
                  fontFeatures: [
                    FontFeature.enable('sups'),
                  ],
                ),
              ),
              Text('data', style: TextStyle(color: Colors.black,fontFeatures: [FontFeature.randomize()])),
              RichText(
                text:const TextSpan(
                  children: [
                    TextSpan(text: 'Re',style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
                    TextSpan(text: 'gister',style: TextStyle(fontSize: 35,fontFeatures: [FontFeature.enable('sups'),FontFeature.superscripts()]))
                  ],
                  style: TextStyle(color: Colors.black,fontFeatures: [FontFeature.superscripts()])
              ), ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                      labelText: 'Name'
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  controller: emailC,
                  decoration: const InputDecoration(
                    labelText: 'Email'
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  controller: passwordC,
                  decoration:const InputDecoration(
                      labelText: 'Password'
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: (){

                  }, child: const Text('Login Page',textScaleFactor: 1.1)),
                  TextButton(onPressed: (){
                    if(emailC.text.isNotEmpty){

                    }else{
                      buildShowDialog(context,'Please Enter a valid email');
                    }
                  }, child: const Text('Forgot Password?',textScaleFactor: 1.1)),
                ],
              ),
              // ListTile(
              //   tileColor: Colors.indigoAccent,
              //   textColor: Colors.white,
              //   title: Text('Login',textScaleFactor: 1.2,textAlign: TextAlign.center,),
              // ),
              Container(
                width: MediaQuery.of(context).size.width-80,
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: ()async{
                    if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty){
                      var result = await FirebaseAuthenticationClass().signUp(email: emailC.text, password: passwordC.text);
                      if(result == emailC.text){
                        var token = await FirebaseMessaging.instance.getToken();
                        await userReference.doc(emailC.text).set({
                          'email':emailC.text,
                          'token':token
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
                      }
                    }
                  },
                  child: Text('REGISTER',textScaleFactor: 1.2,style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context,String message) {
    return showDialog(context: context,
                    builder: (context){
                  return SimpleDialog(
                    title:const Text('Warning',textAlign: TextAlign.center),
                    children: [
                      Text(message,textAlign: TextAlign.center,)
                    ],
                  );
                    });
  }
}
