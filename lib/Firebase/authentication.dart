import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationClass{
  FirebaseAuth instance = FirebaseAuth.instance;

  signIn({required email,required password})async{

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return instance.currentUser!.email;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    
    }

  signUp({required email,required password})async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return instance.currentUser!.email;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  signOut(){
    instance.signOut();
  }

}