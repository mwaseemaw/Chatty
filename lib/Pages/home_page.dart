import 'package:chatty/Firebase/authentication.dart';
import 'package:chatty/Pages/chat_screen.dart';
import 'package:chatty/Pages/sign_in.dart';
import 'package:chatty/Pages/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
   @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');
  CollectionReference messageReference = FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: userReference.snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,i){
                  DocumentSnapshot doc = snapshot.data!.docs[i];
                  return doc['email'] != auth.currentUser!.email ? ListTile(
                    title: Text(doc['email']),
                    onTap: ()async{
                      String chatId1= "${auth.currentUser!.email}${doc['email']}";
                      String chatId2= "${doc['email']}${auth.currentUser!.email}";
                      DocumentSnapshot getDoc1 = await messageReference.doc(chatId1).get();
                      if(getDoc1.exists){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (_)=>ChatScreenPage(
                              chatId: chatId1,
                              receiver: doc['email'],)));
                      }else{
                        DocumentSnapshot getDoc2 = await messageReference.doc(chatId2).get();
                        if(getDoc2.exists){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (_)=>ChatScreenPage(
                                chatId: chatId2,
                                receiver: doc['email'],)));
                        }else{// No chatId exists
                          await messageReference.doc(chatId1).set({
                            'chatId':chatId1
                          });
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (_)=>ChatScreenPage(
                                chatId: chatId1,
                                receiver: doc['email'],)));
                        }
                      }

                    },
                  ):Container();
                });
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.logout),
        onPressed: ()async{
          await FirebaseAuthenticationClass().signOut();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>SignInPage()), (route) => false);
        },
        label: Text('Sign Out'),
      ),
    );
  }
}
