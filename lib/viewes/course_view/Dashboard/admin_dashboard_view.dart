import 'package:flutter/material.dart';
import 'package:gym_app/viewes/admin_view/exercise_list.dart';
import 'package:gym_app/viewes/course_view/course_list_view.dart';
import 'package:gym_app/viewes/drawer_view/admin_drawer_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_list_view.dart';
import 'package:gym_app/viewes/member_view/member_list_view.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: AdminDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          InstructorListView(),
          MemberListView(),
          ExerciseListView(),
          CourseListView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all items are displayed
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Instructors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
        ],
      ),
    );
  }
}
