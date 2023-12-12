import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// FIREBASE AUTH
// Google and Firebase Sign in method
Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

// Google and Firebase Sign out method
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();

  // Optionally, sign out of other providers
  // await GoogleSignIn().signOut();
}

// FIREBASE FIRESTORE
// Creating task object for use in Projects
class Task {
  final String? tname;
  final String? milestone;

  Task({
    this.tname,
    this.milestone,
  });

  factory Task.fromMap(
    Map<String, dynamic> data,
  ) {
    return Task(tname: data['tname'], milestone: data['milestone']);
  }
  Map<String, dynamic> toMap() {
    return {
      'tname': tname,
      'milestone': milestone,
    };
  }
}

// Creating Project object to convert Firebase data
class Project {
  final String? name;
  final String? problem;
  final String? description;
  final String? size;
  final String? goal;
  final List<String>? milestones;
  final List<Task>? tasks;

  Project({
    this.name,
    this.problem,
    this.description,
    this.size,
    this.goal,
    this.milestones,
    this.tasks,
  });

  // Convert data to and from Firestore and into Project objects
  factory Project.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    var currentTasks = data?['tasks'].map((i) {
      var z = Map<String, dynamic>.from(i);
      return Task.fromMap(z);
    }).toList();
    return Project(
      name: data?['name'],
      problem: data?['problem'],
      description: data?['description'],
      size: data?['size'],
      goal: data?['goal'],
      milestones: data?['milestones'] is Iterable
          ? List.from(data?['milestones'])
          : null,
      tasks: List<Task>.from(currentTasks),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (problem != null) "problem": problem,
      if (description != null) "description": description,
      if (size != null) "size": size,
      if (goal != null) "goal": goal,
      if (milestones != null) "milestones": milestones,
      if (tasks != null) "tasks": tasks,
    };
  }
}

// Create root Firestore instance
var db = FirebaseFirestore.instance;

// Method to get Name of projects
Future<void> getName(String uuid) async {
  await db.collection("projects").where("user", isEqualTo: uuid).get().then(
    (querySnapshot) {
      debugPrint("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    },
    onError: (e) => debugPrint("Error completing: $e"),
  );
}

Future<void> getProjects(String uuid) async {
  var currentProjects = <Project>[];
  var currentProject = Project();
  await db
      .collection("projects")
      .where("user", isEqualTo: uuid)
      .withConverter(
        fromFirestore: Project.fromFirestore,
        toFirestore: (Project project, _) => project.toFirestore(),
      )
      .get()
      .then(
    (querySnapshot) {
      debugPrint("Successfully got projects");
      for (var docSnapshot in querySnapshot.docs) {
        debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
        currentProject = docSnapshot.data();
        currentProjects.add(currentProject);
      }
      var ts = currentProjects.first.tasks;
      if (ts != null) {
        for (var task in ts) {
          debugPrint("Task name: ${task.tname}");
          debugPrint("Task milestone: ${task.milestone}");
        }
      }
    },
    onError: (e) => debugPrint("Error getting projects: $e"),
  );
}
