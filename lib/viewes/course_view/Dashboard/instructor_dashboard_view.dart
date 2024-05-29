import 'package:flutter/material.dart';
import 'package:gym_app/viewes/admin_view/exercise_list.dart';
import 'package:gym_app/viewes/course_view/AddCourseView.dart';
import 'package:gym_app/viewes/course_view/course_list_view.dart';
import 'package:gym_app/viewes/drawer_view/instructor_drawer_view.dart';
import 'package:gym_app/viewes/drawer_view/member_drawer_view.dart';




class InstructorDashboard extends StatefulWidget {
  @override
  _InstructorDashboardState createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instractor Dashboard'),
      ),
      drawer: InstructorDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CourseListView(),
          ExerciseListView(),
          AddCourseView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Course List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Exercise List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Course',
          ),
        ],
      ),
    );
  }
}