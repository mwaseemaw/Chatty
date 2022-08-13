import 'dart:ui';
import 'package:chatty/Firebase/authentication.dart';
import 'package:chatty/Pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');
  TextEditingController emailC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  bool usernameAvailable = true;
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
                    TextSpan(text: 'Re',style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
                    TextSpan(text: 'gister',style: TextStyle(fontSize: 35))
                  ],
                  style: TextStyle(color: Colors.black,fontFeatures: [FontFeature.enable('sups'),FontFeature.superscripts()])
              ), ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  controller: usernameC,
                  onChanged: (usernameValue)async{
                    DocumentSnapshot doc = await userReference.doc(usernameC.text).get();
                    if(doc.exists){
                      
                    }
                  },
                  decoration: InputDecoration(
                    suffix: usernameAvailable? const Icon(Icons.gpp_good_rounded,color: Colors.green,): const Icon(Icons.cancel,color: Colors.red,),
                      labelText: 'Username'
                  ),
                ),
              ),
              BoxTextField(controller: nameC, label: 'Name'),
              BoxTextField(controller: emailC, label: 'Email'),
              BoxTextField(controller: passwordC, label: 'Password'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width-80,
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: ()async{
                    if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty && nameC.text.isNotEmpty && usernameC.text.isNotEmpty){
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
                  child: const Text('REGISTER',textScaleFactor: 1.2,style: TextStyle(color: Colors.white),),
                ),
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: const Text('Go To Login Page',textScaleFactor: 1.1)),
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


class BoxTextField extends StatelessWidget {
  TextEditingController controller;
  String label;
  BoxTextField({
    required this.controller,
    required this.label
});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width-80,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label
        ),
      ),
    );
  }
}

// class SignUpPageProvider extends ChangeNotifier{
//   bool usernameAvailable = true;
//
//   updateUsername(bool value){
//     usernameAvailable = value;
//     notifyListeners();
//   }
//
// }