import 'package:flutter/material.dart';
import 'package:memo/pages/home_page.dart';
import 'package:memo/services/auth_services.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 217, 217),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Welcome back to Memo!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: _handleGoogleBtnClick,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('images/google.png',height:50 ,),
                       Text(
                        "Sign In with Google",
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  _handleGoogleBtnClick()async{
    bool isSignedIn = await AuthService().signInWithGoogle(); 
    if(isSignedIn){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context)=>HomePage()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signed-in failed. Please try again"))
      );
    }}
}
