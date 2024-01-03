import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class MilestoneWidget extends StatelessWidget {
  final Milestone milestone;

  const MilestoneWidget({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(milestone.mname as String),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            children: milestone.tasks
                    ?.map((task) => Text(task.tname as String))
                    .toList() ??
                [],
          ),
        ),
      ],
    );
  }
}
