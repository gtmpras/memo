import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memo/pages/signIn_page.dart';
import 'package:memo/provider/memo_provider.dart';

class AuthService {
  //Google sign in
 Future<bool> signInWithGoogle() async {
  try{
    //selection of google account
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if(gUser == null){
      return false;
    }
    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
   
    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    //sign in to firebase with google credentials
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    //check user signed in successfully
    if(userCredential.user != null){
      //save user data to firestore
      await _saveUserData(userCredential.user!);
      return true;
    }
  }
    catch (e){
      print("Google sign-in error: $e");
      return false;
    }
    
    return false;
 }

 //save user data
 Future<void> _saveUserData(User user)async{
  try{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    await users.doc(user.uid).set({
      'uid': user.uid,
      'displayname': user.displayName ?? 'No name',
      'email': user.email ?? 'No Email',
      'photoURL': user.photoURL ?? 'No photo URL',
      'createdAt': FieldValue.serverTimestamp(),
      
    });
  }
  catch(e){
    print('Error saving user data to firestore: $e');
  }
 }

 //Logout
 Future<void> signOut(BuildContext context, WidgetRef ref)async{
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();

  ref.read(memoProvider.notifier);

  Navigator.pushAndRemoveUntil(context,
   MaterialPageRoute(builder: (context)=>SignInPage()),
    (route)=>false);
 }
}
