import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          child: StreamBuilder<QuerySnapshot>(
            stream: getProjects(uuid),
            builder: (context, result) {
              if (result.hasError) {
                return const Text("Error getting your projects");
              } else if (!result.hasData) {
                return const CircularProgressIndicator();
              } else {
                final data = result.data!.docs
                    .map((doc) => Project.fromFirestore(
                        doc as DocumentSnapshot<Map<String, dynamic>>,
                        SnapshotOptions()))
                    .toList();

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${data[index].name}"),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/details",
                          arguments: data[index],
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, '/add', arguments: uuid);
      }),
    );
  }
}
