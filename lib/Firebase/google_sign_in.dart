import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAuthClass{
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future gSignIn()async
  {
    try{
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuth = await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth?.accessToken,
        idToken: googleSignInAuth?.idToken,
      );
      UserCredential userCredential = await firebaseAuthInstance.signInWithCredential(credential);
      return firebaseAuthInstance.currentUser!.email; //RETURNS NULL IF NO USER OR FAILED AUTHENTICATION

    }catch(ex) {
      return ex;
    }
  }
  gSignOut()async
  {
    try{
      await googleSignIn.signOut();
      await firebaseAuthInstance.signOut();
      return null;

    }catch(e){
      return e;
    }

  }

}