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
              TextButton(onPressed: (){
                if(emailC.text.isNotEmpty){

                }else{
                  buildShowDialog(context,'Please Enter a valid email');
                }
              }, child: const Text('Forgot Password?',textScaleFactor: 1.1)),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
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
                      }, child: const Text('Login',textScaleFactor: 1.2,)),
                  ElevatedButton(
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
                      }, child: const Text('Register',textScaleFactor: 1.2)),
                  GestureDetector(
                    onTap: ()async{
                      var result = await GoogleSignInAuthClass().gSignIn();
                    },
                    child: Image.asset('Assets/google-logo.png',height: 50,width: 50,),
                  )
                ],
              )
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
