import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final googleSignIn = GoogleSignIn();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Please Sign In'),
        ),
        // body is the majority of the screen.
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await signInWithGoogle();
            },
            child: const Text("Click Here"),
          ),
        ));
  }
}
