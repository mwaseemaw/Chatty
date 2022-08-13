import 'package:chatty/Firebase/authentication.dart';
import 'package:chatty/Firebase/google_sign_in.dart';
import 'package:chatty/Pages/home_page.dart';
import 'package:chatty/Pages/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');

  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();
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
              RichText(
                text:const TextSpan(
                    children: [
                      TextSpan(text: 'L',style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
                      TextSpan(text: 'ogin',style: TextStyle(fontSize: 35))
                    ],
                    style: TextStyle(color: Colors.black)
                ), ),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  controller: emailC,
                  style: const TextStyle(fontSize: 17),
                  decoration: const InputDecoration(
                      labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  controller: passwordC,
                  style: const TextStyle(fontSize: 17),
                  decoration:const InputDecoration(
                      labelText: 'Password',

                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                      }, child: const Text('New User? Register!',textScaleFactor: 1.1)),
                  TextButton(onPressed: (){
                    if(emailC.text.isNotEmpty){

                    }else{
                      buildShowDialog(context,'Please Enter a valid email');
                    }
                  }, child: const Text('Forgot Password?',textScaleFactor: 1.1)),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20,bottom: 30),
                width: MediaQuery.of(context).size.width-80,
                decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: ()async{
                    if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty){
                      String? result = await FirebaseAuthenticationClass().signIn(email: emailC.text, password: passwordC.text);
                      if(result == emailC.text){ //Check returned email same as entered email
                        var token = await FirebaseMessaging.instance.getToken();
                        await userReference.doc(emailC.text).update({
                          'token':token
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
                      }else{
                        buildShowDialog(context, result!);
                      }
                    }
                  },
                  child: const Text('LOGIN',textScaleFactor: 1.2,style: TextStyle(color: Colors.white),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-80,
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black,spreadRadius: 1,blurRadius: 5)],
                  shape: BoxShape.circle,
                    color: Colors.white,
                ),
                child: TextButton(
                  onPressed: ()async{
                    var result = await GoogleSignInAuthClass().gSignIn();

                  },
                  child: Image.asset('Assets/google-logo.png',height: 30,width: 30,),
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
