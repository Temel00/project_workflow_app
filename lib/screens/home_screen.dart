import 'package:flutter/material.dart';
import 'package:project_workflow_app/screens/project_details_screen.dart';
import 'package:project_workflow_app/screens/project_add_screen.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  final String displayName, uuid;
  const HomeScreen({super.key, required this.displayName, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      // body is the majority of the screen.
      body: Column(children: [
        Row(
          children: [
            Text("Welcome, $displayName "),
            const SizedBox(
              width: 20,
            ),
            const ElevatedButton(onPressed: signOut, child: Text("Sign Out")),
          ],
        ),
        Flexible(
          child: FutureBuilder(
            future: getProjects(uuid),
            builder: (context, result) {
              if (result.hasError) {
                return Text("error in future builder");
              } else if (result.connectionState == ConnectionState.done) {
                List<Project> data = result.data as List<Project>;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${data[index].name}"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProjectDetailsScreen(project: data[index]),
                            ));
                      },
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectAddScreen(),
            ));
      }),
    );
  }
}
