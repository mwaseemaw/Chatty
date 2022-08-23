import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:chatty/Firebase/authentication.dart';
import 'package:chatty/Pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');
  CollectionReference usernameReference = FirebaseFirestore.instance.collection('username');
  Reference storage = FirebaseStorage.instance.ref();
  TextEditingController emailC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  bool usernameAvailable = true;

  Future usernameValidity()async{
      DocumentSnapshot doc = await usernameReference.doc(usernameC.text).get();
      doc.exists?
      Provider.of<SignUpPageProvider>(context,listen: false).updateUsername(false)
          :
      Provider.of<SignUpPageProvider>(context,listen: false).updateUsername(true);
  }
  @override
  void dispose() {
    emailC.dispose();
    usernameC.dispose();
    passwordC.dispose();
    nameC.dispose();
    super.dispose();
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
                    TextSpan(text: 'Re',style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
                    TextSpan(text: 'gister',style: TextStyle(fontSize: 35))
                  ],
                  style: TextStyle(color: Colors.black,fontFeatures: [FontFeature.enable('sups'),FontFeature.superscripts()])
              ), ),
              SizedBox(
                width: MediaQuery.of(context).size.width-80,
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: usernameC,
                  decoration: InputDecoration(
                    suffix: Provider.of<SignUpPageProvider>(context,listen: true).usernameAvailable == true ? const Icon(Icons.gpp_good_rounded,color: Colors.green,): const Icon(Icons.cancel,color: Colors.red,),
                      labelText: 'Username'
                  ),
                ),
              ),
              // TextButton(onPressed: ()async{
              //   usernameValidity();
              // }, child: const Text('Check Username available',style: TextStyle(color: Colors.indigoAccent),)),
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

                    try{
                      Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(true);
                      await usernameValidity();
                      if(Provider.of<SignUpPageProvider>(context,listen: false).usernameAvailable == true){
                        if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty && nameC.text.isNotEmpty && usernameC.text.isNotEmpty){
                          XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(file != null){
                            var u = FileImage(File(file.path));
                           // File f = File(file.path);
                           // var result = await FirebaseAuthenticationClass().signUp(email: emailC.text, password: passwordC.text);
                            if(emailC.text == await FirebaseAuthenticationClass().signUp(email: emailC.text, password: passwordC.text)){
                              await storage.child(emailC.text).putFile(u.file);
                              String url = await storage.child(emailC.text).getDownloadURL();
                              var token = await FirebaseMessaging.instance.getToken();
                              usernameReference.doc(usernameC.text).set({'username':usernameC.text});
                              await userReference.doc(emailC.text).set({
                                'username':usernameC.text,
                                'name':nameC.text,
                                'email':emailC.text,
                                'token':token,
                                'profile':url
                              });
                              Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
                            }
                          }else{
                            Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                            buildShowDialog(context, 'Please Upload a profile picture to continue');
                          }

                        }else{
                          Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                          buildShowDialog(context, 'Please Enter all details');
                        }
                      }else{
                        Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                        buildShowDialog(context, 'Check username validity');
                      }
                      Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                    }on FirebaseException catch(ex){
                      Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                      buildShowDialog(context, ex.toString());
                    }catch(e){
                      Provider.of<SignUpPageProvider>(context,listen: false).updateLoading(false);
                      buildShowDialog(context, e.toString());
                    }
                  },
                  child:
                  Provider.of<SignUpPageProvider>(context,listen: false).isLoading == true ?
                      const CircularProgressIndicator(color: Colors.white,)
                      :
                      const Text('REGISTER',textScaleFactor: 1.2,style: TextStyle(color: Colors.white),),
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

class SignUpPageProvider extends ChangeNotifier{
  bool usernameAvailable = true;
  bool isLoading = false;
  updateUsername(bool value){
    usernameAvailable = value;
    notifyListeners();
  }

  updateLoading(value){
    isLoading = value;
    notifyListeners();
  }

}