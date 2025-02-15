
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo/pages/home_page.dart';
import 'package:memo/pages/signIn_page.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  // Function to check if user data exists in Firestore
  Future<bool> _checkUserDataExists(String uid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
      
      // If the user document doesn't exist, return false
      return userDoc.exists;
    } catch (e) {
      print("Error checking user data: $e");
      return false;  // If there's any error, assume the user doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is signed in
        if (snapshot.hasData) {
          String uid = snapshot.data!.uid;
          
          // Check if the user data exists in Firestore
          return FutureBuilder<bool>(
            future: _checkUserDataExists(uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // If user data doesn't exist, sign them out and show the SignInPage
              if (userSnapshot.hasData && !userSnapshot.data!) {
                FirebaseAuth.instance.signOut();
                return const SignInPage();
              }

              // If user data exists, navigate to the HomePage
              return HomePage();
            },
          );
        }

        // If the user is not signed in, show the SignInPage
        return const SignInPage();
      },
    );
  }
}