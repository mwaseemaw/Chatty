import 'dart:convert';

import 'package:chatty/Firebase/authentication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  String myEmail;
  ChatScreen({required this.myEmail});
  CollectionReference messageReference = FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
       // IconButton(onPressed: FirebaseAuthenticationClass().signOut(), icon: const Icon(Icons.logout))
      ],),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: messageReference.snapshots(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Container(
                  margin: EdgeInsets.only(bottom: 55),
                  alignment: Alignment.topCenter,
                  child: ListView.builder(shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context,i){
                        DocumentSnapshot? doc = snapshot.data?.docs[i];
                        return myEmail == doc?['sender'] ?
                        Container(
                          padding: EdgeInsets.all(20),
                          margin:  EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightGreenAccent
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(doc?['message']),
                        ):
                        Container(
                          padding: EdgeInsets.all(20),
                          margin:  EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.redAccent
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(doc?['message']),
                        );
                      }),
                );
              }
              return Container();
            },
          ),
          Positioned(
            height: 55,
            width: MediaQuery.of(context).size.width,
            bottom: 1,
              child: TextField(
                textInputAction: TextInputAction.send,
                onSubmitted: (value){
                  messageReference.doc(DateTime.now().toString()).set({
                    'message':value,
                    'sender':myEmail
                  });

                },
                decoration: InputDecoration(
                  hintText: 'Type message here...',
                  fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    )),
              ))
        ],
      ),
    );
  }
}
