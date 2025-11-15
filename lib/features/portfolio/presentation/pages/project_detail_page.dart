import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  
  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project: $projectId'),
      ),
      body: const Center(
        child: Text('Project Detail Page'),
      ),
    );
  }
}
