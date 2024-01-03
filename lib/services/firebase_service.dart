import 'dart:developer';

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

// Create all the database object classes
// Creating the ProjectId object for use in Owners
class ProjectId {
  final String? pname;
  final String? projectId;

  ProjectId({this.pname, this.projectId});

  factory ProjectId.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ProjectId(pname: data?['pname'], projectId: data?['projectId']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (pname != null) "pname": pname,
      if (projectId != null) "projectId": projectId,
    };
  }
}

// Creating the owners object for use in Owners

class Owner {
  final String uuid;
  final List<ProjectId>? projectIds;

  Owner({required this.uuid, this.projectIds});

  factory Owner.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Owner(
      uuid: data?['uuid'],
      projectIds: data?['projectIds'] is Iterable
          ? List.from(data?['projectIds'])
              .map((projectIdData) =>
                  ProjectId.fromFirestore(projectIdData, options))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uuid": uuid,
      "projectIds": projectIds,
    };
  }
}

// Creating task object for use in Projects
class Task {
  final String? tname;
  final bool? isComplete;

  Task({
    this.tname,
    this.isComplete,
  });

  factory Task.fromFirestore(Map<String, dynamic> data) {
    // debugPrint("Returning Task: ${data["tname"]} and ${data["isComplete"]}.");
    return Task(
      tname: data['tname'] as String,
      isComplete: data['isComplete'] as bool,
    );
  }

  /// Add a toFirestore method to convert Task object to a Map
  Map<String, dynamic> toFirestore() {
    return {
      "tname": tname,
      "isComplete": isComplete,
    };
  }
}

class Milestone {
  final String? mname;
  final List<Task>? tasks;

  Milestone({
    this.mname,
    this.tasks,
  });

  factory Milestone.fromFirestore(Map<String, dynamic> data) {
    // debugPrint("Returning Task: ${data["mname"]} and ${data["tasks"]}.");
    return Milestone(
      mname: data['mname'] as String,
      tasks: (data['tasks'] as List? ?? [])
          .map((taskData) => Task.fromFirestore(taskData))
          .toList(),
    );
  }

  /// Add a toFirestore method to convert Task object to a Map
  Map<String, dynamic> toFirestore() {
    return {
      "mname": mname,
      "tasks": tasks?.map((task) => task.toFirestore()).toList(),
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
  final List<Milestone>? milestones;
  final String? user;
  final String? id;

  Project({
    this.name,
    this.problem,
    this.description,
    this.size,
    this.goal,
    this.milestones,
    this.user,
    this.id,
  });

  // Convert data to and from Firestore and into Project objects
  factory Project.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    // debugPrint("This is the data in Project.fromFirestore: ${data}");

    return Project(
      name: data?['name'] as String,
      problem: data?['problem'],
      description: data?['description'],
      size: data?['size'],
      goal: data?['goal'],
      milestones: (data?['milestones'] as List? ?? [])
          .map((milestoneData) => Milestone.fromFirestore(milestoneData))
          .toList(),
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
      if (milestones != null)
        "milestones":
            milestones?.map((milestone) => milestone.toFirestore()).toList(),
      if (user != null) "user": user,
      if (id != null) "id": id,
    };
  }
}

// Create root Firestore instance
var db = FirebaseFirestore.instance;

// Method to get user's owner document
Stream<QuerySnapshot> getOwners(String uuid) async* {
  yield* db.collection("owners").where("user", isEqualTo: uuid).snapshots();
}

// Method to get projects with user
Stream<QuerySnapshot> getProjects(String uuid) async* {
  yield* db.collection("projects").where("user", isEqualTo: uuid).snapshots();
}

Future<bool> projectExists(String projectId, String user) async {
  final ownerDoc = await db.collection("owners").doc(user).get();
  final projectList = ownerDoc.data()!["projectIds"] as List<ProjectId>;
  return projectList.any((map) => "projectId" == projectId);
}

Future<void> addMilestone(Project proj, Milestone milestone) async {
  try {
    final reference = db.collection("projects").doc(proj.id);

    List<Milestone> currentMilestones =
        (await reference.get()).data()?['milestones'] is Iterable
            ? List.from(
                (await reference.get()).data()?['milestones'],
              )
                .map((milestoneData) => Milestone.fromFirestore(milestoneData))
                .toList()
            : [];

    currentMilestones.add(milestone);

    await reference.update({
      'milestones': currentMilestones.map((m) => m.toFirestore()).toList(),
    });
  } catch (error) {
    debugPrint('Error adding milestone: $error');
  }
}

// Method to add projects with user
Future<void> addProject(Project proj) async {
  try {
    late DocumentReference docRef;
    if (proj.id == null || proj.id == "") {
      debugPrint("Project Id was null or empty");
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
          id: docRef.id);

      await docRef.set(newProj);
    } else {
      docRef = db
          .collection("projects")
          .withConverter(
            fromFirestore: Project.fromFirestore,
            toFirestore: (Project project, _) => project.toFirestore(),
          )
          .doc(proj.id);

      await docRef
          .set(proj)
          .then((x) => {debugPrint("Successfully sent to Firebase")});
    }
  } catch (error) {
    debugPrint("Error adding project: $error");
  }
}

Future<void> deleteProject(Project proj) async {
  await db.collection("projects").doc(proj.id).delete().then(
        (doc) => debugPrint("Document deleted"),
        onError: (e) => debugPrint("Error updating document $e"),
      );
}
