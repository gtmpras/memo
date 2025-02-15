import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memo/pages/signIn_page.dart';
import 'package:memo/services/auth_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Function to fetch user data from Firestore
  Future<DocumentSnapshot> _getUserData(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(uid).get();
    return userDoc;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<DocumentSnapshot>(
          future: _getUserData(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No user data found.'));
            }

            // Get the data from Firestore document
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String displayName = userData['displayname'] ?? 'No name';
            String email = userData['email'] ?? 'No Email';
            String photoURL = userData['photoURL'] ?? '';
            Timestamp createdAt = userData['createdAt'] ?? '';

            DateTime registrationDate = createdAt.toDate();
            String formattedCreationDate =
                DateFormat('dd MMMM yyy HH:mm').format(registrationDate);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.25),
                  child: Container(
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(photoURL.isNotEmpty
                            ? photoURL
                            : ' https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/86.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(displayName,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(email,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Text("Created At: $formattedCreationDate",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              ],
            );
          },
        ),
        floatingActionButton: Consumer(
          builder: (context, ref, child){
            return FloatingActionButton(
              child: Icon(Icons.exit_to_app),
              onPressed: () async {
                await AuthService().signOut(context, ref);
          
                //navigate back to signinpage
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInPage()));
              });
          }
        ));
         
       
  }
}
