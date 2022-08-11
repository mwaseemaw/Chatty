import 'package:chatty/Firebase/sendNotification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreenPage extends StatelessWidget {
  String chatId;
  String receiver;
  ChatScreenPage({required this.chatId, required this.receiver});
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference messageReference = FirebaseFirestore.instance.collection('messages');
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');
  TextEditingController messageC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiver),),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: messageReference.doc(chatId).collection('messages').snapshots(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 55),
                  alignment: Alignment.topCenter,
                  child: ListView.builder(shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context,i){
                        DocumentSnapshot doc = snapshot.data!.docs[i];
                        return auth.currentUser!.email == doc['sender'] ?
                        Container(
                        //  padding: EdgeInsets.all(10),
                          margin:  EdgeInsets.all(2),
                          width: MediaQuery.of(context).size.width-100,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Colors.grey.shade300
                          ),
                          alignment: Alignment.centerRight,
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 50,right: 10),
                            title: Text(doc['message'],textScaleFactor: 1.1,textAlign: TextAlign.end,),
                            subtitle: Text(doc['date time'].toString().substring(0,16),textAlign: TextAlign.end),
                          ),
                        ):
                        Container(
                        //  padding: EdgeInsets.all(10),
                          margin:  EdgeInsets.all(2),
                          width: MediaQuery.of(context).size.width/2,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                              ),
                              color: Colors.white
                          ),
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                            contentPadding: EdgeInsets.only(right: 50,left: 10),
                            title: Text(doc['message'],textScaleFactor: 1.1),
                            subtitle: Text(doc['date time'].toString().substring(0,16)),
                          ),
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
                controller: messageC,
                textInputAction: TextInputAction.send,
                onSubmitted: (value)async{
                  String currentTime = DateTime.now().toString();
                  if(messageC.text.isNotEmpty){
                    messageReference.doc(chatId).collection('messages').doc(currentTime).set(
                        {
                          'message':messageC.text,
                          'date time':currentTime,
                          'sender': auth.currentUser!.email,
                          'to': receiver
                        });
                    DocumentSnapshot doc = await userReference.doc(receiver).get();
                    String token = doc.get('token');
                    UserNotification().sendNotificationToUser(token: token, by:auth.currentUser!.email , message: messageC.text);
                    messageC.clear();
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'Type message here...',
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none),
              ))
        ],
      ),
    );
  }
}
