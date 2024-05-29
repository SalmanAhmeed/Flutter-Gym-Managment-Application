import 'package:flutter/material.dart';
import 'package:gym_app/controllers/instructor_controller.dart';
import 'package:gym_app/controllers/member_controller.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';
import 'package:gym_app/viewes/admin_view/exercise_list.dart';
import 'package:gym_app/viewes/course_view/AddCourseView.dart';
import 'package:gym_app/viewes/course_view/course_list_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_list_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_register_view.dart';
import 'package:gym_app/viewes/login/login.dart';
import 'package:gym_app/viewes/member_view/member_list_view.dart';
import 'package:gym_app/viewes/member_view/member_registration_view.dart';

class InstructorDrawer extends StatelessWidget {
  final InstructorController _instructorController = InstructorController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _instructorController.getInstructorByUid(LoginPageState.logidUserID),
      builder: (context, AsyncSnapshot<Instructor?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError || snapshot.data == null) {
            return Drawer(
              child: Center(
                child: Text('Error loading instractor data'),
              ),
            );
          } else {
            Instructor instructor = snapshot.data!;
            return Drawer(
              child: ListView(
                // Remove padding
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(instructor.name),
                    accountEmail: Text(instructor.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(instructor.imageUrl),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // image: DecorationImage(
                      //  fit: BoxFit.fill,
                      //       image: NetworkImage(
                      //         'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt_rounded),
                    title: Text('Exercise List'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ExerciseListView()));
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.list_alt),
                    title: Text('Add Cource List'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AddCourseView()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt),
                    title: Text('Cource List'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CourseListView()));
                    },
                  ), ListTile(
                    leading: Icon(Icons.logout_sharp),
                    title: Text('Log out'),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  // Add the rest of the list tiles here
                ],
              ),
            );
          }
        }
      },
    );
  }
}



