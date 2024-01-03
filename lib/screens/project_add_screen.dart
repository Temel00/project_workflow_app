import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ProjectAddScreen extends StatefulWidget {
  const ProjectAddScreen({super.key});

  @override
  State<ProjectAddScreen> createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen> {
  final _addFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final problemController = TextEditingController();
  final descriptionController = TextEditingController();
  double _value = 0;
  String _status = 'sm';
  Color _statusColor = Colors.lightBlue;
  String _dropdownValue = "Patentable Idea";

  void sliderCallback(double? value) {
    setState(() {
      _value = value as double;
      switch (value) {
        case 0:
          {
            _status = 'sm';
            _statusColor = Colors.lightBlue;
            break;
          }
        case 1:
          {
            _status = 'md';
            _statusColor = Colors.yellow;
            break;
          }
        case 2:
          {
            _status = 'lg';
            _statusColor = Colors.orange;
            break;
          }
        case 3:
          {
            _status = 'xl';
            _statusColor = Colors.green;
            break;
          }
        default:
          {
            break;
          }
      }
    });
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {}
    setState(() {
      _dropdownValue = selectedValue as String;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    problemController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Project")),
        body: Form(
          key: _addFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Project Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: problemController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Problem Statement',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Project Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Project Size",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _status,
                    style: TextStyle(color: _statusColor),
                  ),
                  Slider(
                    min: 0,
                    max: 3,
                    value: _value,
                    divisions: 3,
                    onChanged: sliderCallback,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Project Goal",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton(
                      value: _dropdownValue,
                      items: [
                        DropdownMenuItem(
                            value: "Patentable Idea",
                            child: Text(
                              "Patentable Idea",
                              style:
                                  TextStyle(backgroundColor: Colors.green[100]),
                            )),
                        DropdownMenuItem(
                            value: "Personal Goal",
                            child: Text(
                              "Personal Goal",
                              style:
                                  TextStyle(backgroundColor: Colors.blue[100]),
                            )),
                        DropdownMenuItem(
                            value: "Learning",
                            child: Text(
                              "Learning",
                              style:
                                  TextStyle(backgroundColor: Colors.pink[100]),
                            )),
                      ],
                      onChanged: dropdownCallback)
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_addFormKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adding Data')),
                      );
                      debugPrint(
                          "Name: ${nameController.text}, Problem: ${problemController.text}, Desc: ${descriptionController.text}");

                      addProject(
                        Project(
                          name: nameController.text,
                          problem: problemController.text,
                          description: descriptionController.text,
                          size: _status,
                          goal: _dropdownValue,
                          user: ModalRoute.of(context)?.settings.arguments
                              as String,
                          milestones: [],
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
