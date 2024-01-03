import 'package:flutter/material.dart';
import 'package:project_workflow_app/widgets/milestone_widget.dart';
import '../services/firebase_service.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late bool _isEditting;
  final _detailsFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final problemController = TextEditingController();
  final descriptionController = TextEditingController();
  late double _value;
  late String _status;
  late Color _statusColor;
  late String _dropdownValue;
  late Project _currentProj;
  late List<Milestone> _currentMilestones;

  @override
  void initState() {
    super.initState();
    _isEditting = false;
  }

  @override
  void didChangeDependencies() {
    _currentProj = ModalRoute.of(context)?.settings.arguments as Project;
    nameController.text = _currentProj.name!;
    problemController.text = _currentProj.problem!;
    descriptionController.text = _currentProj.description!;
    _status = _currentProj.size!;
    _currentMilestones = _currentProj.milestones!;

    if (_status == "sm") {
      _value = 0;
      _statusColor = Colors.lightBlue;
    } else if (_status == "md") {
      _value = 1;
      _statusColor = Colors.yellow;
    } else if (_status == "lg") {
      _value = 2;
      _statusColor = Colors.orange;
    } else if (_status == "xl") {
      _value = 3;
      _statusColor = Colors.green;
    }
    _dropdownValue = _currentProj.goal!;

    super.didChangeDependencies();
  }

  void _toggleEdit() {
    setState(() {
      _isEditting = !_isEditting;
    });
  }

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
    // Create Milestone rows
    List<Milestone> milestones = _currentProj.milestones as List<Milestone>;
    var milestoneRows = <Row>[];
    for (var milestone in milestones) {
      List<Task> tasks = milestone.tasks as List<Task>;
      var taskRows = <Column>[];
      for (var task in tasks) {
        var newTask = Column(
          children: [Text("${task.tname}")],
        );
        taskRows.add(newTask);
      }
      var newRow = Row(
        children: [
          Text("${milestone.mname}"),
          const Icon(Icons.collections_bookmark),
          Column(
            children: taskRows,
          )
        ],
      );
      milestoneRows.add(newRow);
    }

    // // Create Task rows
    // List<Task> tasks = _currentProj.milestones as List<Task>;

    // var taskRows = <Row>[];
    // for (var task in tasks) {
    //   var newTask = Row(
    //     children: [
    //       const Icon(Icons.check_box_outline_blank),
    //       Text("${task.tname}"),
    //       const SizedBox(
    //         width: 20,
    //       ),
    //       Text("${task.tname}"),
    //     ],
    //   );
    //   taskRows.add(newTask);
    // }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Project Details"),
          actions: [
            _isEditting
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Cancel',
                        onPressed: () {
                          nameController.text = _currentProj.name!;
                          problemController.text = _currentProj.problem!;
                          descriptionController.text =
                              _currentProj.description!;
                          _status = _currentProj.size!;
                          if (_currentProj.size! == "sm") {
                            _value = 0;
                            _statusColor = Colors.lightBlue;
                          } else if (_currentProj.size! == "md") {
                            _value = 1;
                            _statusColor = Colors.yellow;
                          } else if (_currentProj.size! == "lg") {
                            _value = 2;
                            _statusColor = Colors.orange;
                          } else if (_currentProj.size! == "xl") {
                            _value = 3;
                            _statusColor = Colors.green;
                          }
                          _dropdownValue = _currentProj.goal!;
                          _toggleEdit();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        tooltip: 'Edit Project Details',
                        onPressed: () {
                          _toggleEdit();
                          _currentProj = Project(
                            name: nameController.text,
                            problem: problemController.text,
                            description: descriptionController.text,
                            size: _status,
                            goal: _dropdownValue,
                            milestones: milestones,
                            user: _currentProj.user,
                            id: _currentProj.id,
                          );
                          addProject(_currentProj);
                          // Call Firebase Update
                        },
                      ),
                    ],
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit Project Details',
                    onPressed: () {
                      _toggleEdit();
                    },
                  )
          ],
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _detailsFormKey,
          child: Column(
            children: [
              if (_isEditting)
                Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Project Name'),
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
                  ],
                ),
              if (!_isEditting)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Project Name: ${_currentProj.name}"),
                    Text("Problem Statement: ${_currentProj.problem}"),
                    Text("Project Description: ${_currentProj.description}"),
                  ],
                ),
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
                  _isEditting
                      ? Slider(
                          min: 0,
                          max: 3,
                          value: _value,
                          divisions: 3,
                          onChanged: sliderCallback,
                        )
                      : Slider(
                          min: 0,
                          max: 3,
                          value: _value,
                          divisions: 3,
                          onChanged: null,
                        )
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
                  _isEditting
                      ? DropdownButton(
                          value: _dropdownValue,
                          items: [
                            DropdownMenuItem(
                                value: "Patentable Idea",
                                child: Text(
                                  "Patentable Idea",
                                  style: TextStyle(
                                      backgroundColor: Colors.green[100]),
                                )),
                            DropdownMenuItem(
                                value: "Personal Goal",
                                child: Text(
                                  "Personal Goal",
                                  style: TextStyle(
                                      backgroundColor: Colors.blue[100]),
                                )),
                            DropdownMenuItem(
                                value: "Learning",
                                child: Text(
                                  "Learning",
                                  style: TextStyle(
                                      backgroundColor: Colors.pink[100]),
                                )),
                          ],
                          onChanged: dropdownCallback)
                      : DropdownButton(
                          value: _dropdownValue,
                          items: [
                            DropdownMenuItem(
                                value: "Patentable Idea",
                                child: Text(
                                  "Patentable Idea",
                                  style: TextStyle(
                                      backgroundColor: Colors.green[100]),
                                )),
                            DropdownMenuItem(
                                value: "Personal Goal",
                                child: Text(
                                  "Personal Goal",
                                  style: TextStyle(
                                      backgroundColor: Colors.blue[100]),
                                )),
                            DropdownMenuItem(
                                value: "Learning",
                                child: Text(
                                  "Learning",
                                  style: TextStyle(
                                      backgroundColor: Colors.pink[100]),
                                )),
                          ],
                          onChanged: null),
                ],
              ),
              const Text("Milestones"),
              Text(_currentMilestones.length.toString()),
              SizedBox(
                height: 150,
                child: ListView.builder(
                    itemCount: _currentMilestones.length,
                    itemBuilder: (context, index) {
                      Milestone milestone = _currentMilestones[index];
                      return MilestoneWidget(milestone: milestone);
                    }),
              ),
              if (_isEditting)
                ElevatedButton(
                    onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      final newMilestone = Milestone(
                                          mname: 'Milestone 1',
                                          tasks: [
                                            Task(
                                                tname: 'Task 1',
                                                isComplete: false),
                                            Task(
                                                tname: 'Task 2',
                                                isComplete: false)
                                          ]);
                                      addMilestone(_currentProj, newMilestone)
                                          .then((x) => {
                                                Navigator.pop(context),
                                              });
                                    },
                                    child: const Text("Add Milestone"),
                                  ),
                                  const SizedBox(height: 15),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    child: const Text("+ milestone")),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 10),
              if (_isEditting)
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                bool isUpdated = false;
                                deleteProject(_currentProj).then((x) => {
                                      isUpdated = true,
                                      Navigator.pop(context),
                                      Navigator.pop(context, isUpdated)
                                    });
                              },
                              child: const Text("Delete"),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Delete Project'),
                ),
            ],
          ),
        )));
  }
}
