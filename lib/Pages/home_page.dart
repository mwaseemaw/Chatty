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

  Widget profileData(name,username,email,image){
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      children: [
        CircleAvatar(backgroundImage: NetworkImage(image),radius: 40,),
        Text("Name:",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey),),
        Text(name,textScaleFactor: 1.2,),
        Text("Email:",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey),),
        Text(email,textScaleFactor: 1.2,),
        Text("Username:",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey),),
        Text(username,textScaleFactor: 1.2,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
      ),
      drawer: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        margin:const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Profile'),
              trailing: Icon(Icons.account_box,color: Colors.indigoAccent,),
            ),
            const ListTile(
              title: Text('Settings'),
              trailing: Icon(Icons.settings,color: Colors.indigoAccent),
            ),
            ListTile(
              title: const Text('Log Out'),
              trailing: const Icon(Icons.logout,color: Colors.red),
              onTap: () {
                FirebaseAuthenticationClass().signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>SignInPage()), (route) => false);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userReference.snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,i){
                  DocumentSnapshot doc = snapshot.data!.docs[i];
                  return doc['email'] != auth.currentUser!.email ?
                  ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(doc['profile']),),
                    title: Text(doc['name']),
                    onTap: ()async{
                      showDialog(
                          context: context,
                          builder: (context)=>profileData(doc['name'], doc['username'], doc['email'],doc['profile']));

                    },
                    trailing: IconButton(
                      onPressed: ()async{
                        String chatId1= "${auth.currentUser!.email}${doc['email']}";
                        String chatId2= "${doc['email']}${auth.currentUser!.email}";
                        DocumentSnapshot getDoc1 = await messageReference.doc(chatId1).get();
                        if(getDoc1.exists){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (_)=>ChatScreenPage(
                                chatId: chatId1,
                                receiver: doc['email'],)));
                        }else{
                          DocumentSnapshot getDoc2 = await messageReference.doc(chatId2).get();
                          if(getDoc2.exists){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_)=>ChatScreenPage(
                                  chatId: chatId2,
                                  receiver: doc['email'],)));
                          }else{// No chatId exists
                            await messageReference.doc(chatId1).set({
                              'chatId':chatId1
                            });
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_)=>ChatScreenPage(
                                  chatId: chatId1,
                                  receiver: doc['email'],)));
                          }
                        }
                      },
                      icon: const Icon(Icons.message_rounded,color: Colors.indigoAccent,),
                    ),
                  ):Container();
                });
          }
          return Container();
        },
      ),

    );
  }
}
