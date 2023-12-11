import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final String displayName;
  const HomeScreen({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      // body is the majority of the screen.
      body: Center(
          child: Column(
        children: [
          Text("This is $displayName's home page"),
          const SizedBox(
            height: 20,
          ),
          const ElevatedButton(onPressed: signOut, child: Text("Sign Out")),
        ],
      )),
    );
  }
}
