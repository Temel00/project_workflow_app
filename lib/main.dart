import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Show loading screen
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ),
  ));

  // Initialize Firebase Core
  var app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  FirebaseAuth.instanceFor(app: app);

  // Replace loading screen with actual app
  runApp((const MyApp()));
}

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();

  // Optionally, sign out of other providers
  // await GoogleSignIn().signOut();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is signed in, show Home Screen
            return HomeScreen(displayName: snapshot.data!.displayName!);
          } else {
            // User is not signed in, show Login Screen
            return LoginScreen();
          }
        },
      ),
    );
  }
}

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
