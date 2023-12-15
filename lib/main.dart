import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_workflow_app/screens/project_add_screen.dart';
import 'package:project_workflow_app/screens/project_details_screen.dart';
import 'package:project_workflow_app/services/firebase_service.dart';
import 'firebase_options.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Workflow',
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // User is signed in, show Home Screen
                  return HomeScreen(
                      displayName: snapshot.data!.displayName!,
                      uuid: snapshot.data!.uid);
                } else {
                  // User is not signed in, show Login Screen
                  return LoginScreen();
                }
              },
            ),
        '/details': (context) => const ProjectDetailsScreen(),
        '/add': (context) => const ProjectAddScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
