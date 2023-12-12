import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    List<String> milestones = project.milestones as List<String>;
    var milestoneRows = <Row>[];
    for (var milestone in milestones) {
      var newRow = Row(
        children: [Text(milestone), Icon(Icons.collections_bookmark)],
      );
      milestoneRows.add(newRow);
    }

    List<Task> tasks = project.tasks as List<Task>;
    var taskRows = <Row>[];
    for (var task in tasks) {
      var newTask = Row(
        children: [
          Icon(Icons.check_box_outline_blank),
          Text("${task.tname}"),
          SizedBox(
            width: 20,
          ),
          Text("${task.milestone}"),
        ],
      );
      taskRows.add(newTask);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Project Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Name: ${project.name}"),
            Text("Problem: ${project.problem}"),
            Text("Description: ${project.description}"),
            Text("Size: ${project.size}"),
            Text("Goal: ${project.goal}"),
            SizedBox(
              height: 20,
            ),
            Text("Milestones"),
            Column(
              children: milestoneRows,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Tasks"),
            Column(
              children: taskRows,
            )
          ],
        ),
      ),
    );
  }
}
