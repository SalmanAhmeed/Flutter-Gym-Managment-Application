import 'package:flutter/material.dart';
import 'package:gym_app/modules/instructor_model.dart';

class InstructorInformationView extends StatelessWidget {
  final Instructor instructor;

  InstructorInformationView({required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(instructor.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(instructor.imageUrl),
              radius: 80,
            ),
            SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(
                        instructor.email,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(
                        instructor.phone,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(
                        instructor.address,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        instructor.gender,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.school),
                      title: Text(
                        instructor.certificate,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Call the instructor
                  },
                  icon: Icon(Icons.phone),
                  label: Text('Call'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Send an email to the instructor
                  },
                  icon: Icon(Icons.email),
                  label: Text('Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
