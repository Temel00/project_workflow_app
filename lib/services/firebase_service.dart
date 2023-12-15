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

  factory Task.fromFirestore(Map<String, dynamic> data) {
    return Task(
      tname: data['tname'],
      milestone: data['milestone'],
    );
  }

  /// Add a toFirestore method to convert Task object to a Map
  Map<String, dynamic> toFirestore() {
    return {
      "tname": tname,
      "milestone": milestone,
    };
  }

  Task({
    this.tname,
    this.milestone,
  });
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
  final String? user;
  final String? id;

  Project({
    this.name,
    this.problem,
    this.description,
    this.size,
    this.goal,
    this.milestones,
    this.tasks,
    this.user,
    this.id,
  });

  // Convert data to and from Firestore and into Project objects
  factory Project.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Project(
      name: data?['name'],
      problem: data?['problem'],
      description: data?['description'],
      size: data?['size'],
      goal: data?['goal'],
      milestones: data?['milestones'] is Iterable
          ? List.from(data?['milestones'])
          : null,
      tasks: data?['tasks'] is Iterable
          ? List.from(data?['tasks'])
              .map((taskData) => Task.fromFirestore(taskData))
              .toList()
          : null,
      user: data?['user'],
      id: data?['id'],
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
      if (tasks != null)
        "tasks": tasks!.map((task) => task.toFirestore()).toList(),
      if (user != null) "user": user,
      if (id != null) "id": id,
    };
  }
}

// Create root Firestore instance
var db = FirebaseFirestore.instance;

// Method to get projects with user
Stream<QuerySnapshot> getProjects(String uuid) async* {
  yield* db.collection("projects").where("user", isEqualTo: uuid).snapshots();
}

// // Method to get projects with user
// Future<List<Project>?> getProjects(String uuid) async {
//   var currentProjects = <Project>[];
//   var currentProject = Project();
//   await db
//       .collection("projects")
//       .where("user", isEqualTo: uuid)
//       .withConverter(
//         fromFirestore: Project.fromFirestore,
//         toFirestore: (Project project, _) => project.toFirestore(),
//       )
//       .get()
//       .then(
//     (querySnapshot) {
//       debugPrint("Successfully got projects");
//       for (var docSnapshot in querySnapshot.docs) {
//         debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
//         currentProject = docSnapshot.data();
//         currentProjects.add(currentProject);
//       }
//       return currentProjects;
//     },
//     onError: (e) => debugPrint("Error getting projects: $e"),
//   );
//   return currentProjects;
// }

// Method to add projects with user
Future<void> addProject(Project proj) async {
  late DocumentReference docRef;
  if (proj.id == null || proj.id == "") {
    docRef = db
        .collection("projects")
        .withConverter(
          fromFirestore: Project.fromFirestore,
          toFirestore: (Project project, _) => project.toFirestore(),
        )
        .doc();
    var newProj = Project(
        name: proj.name,
        problem: proj.problem,
        description: proj.description,
        size: proj.size,
        goal: proj.goal,
        user: proj.user,
        milestones: proj.milestones,
        tasks: proj.tasks,
        id: docRef.id);

    await docRef.set(newProj);
  } else {
    debugPrint("Project tasks: ${proj.tasks}");
    docRef = db
        .collection("projects")
        .withConverter(
          fromFirestore: Project.fromFirestore,
          toFirestore: (Project project, _) => project.toFirestore(),
        )
        .doc(proj.id);

    await docRef.set(proj);
  }
}

Future<void> deleteProject(Project proj) async {
  await db.collection("projects").doc(proj.id).delete().then(
        (doc) => debugPrint("Document deleted"),
        onError: (e) => debugPrint("Error updating document $e"),
      );
}
