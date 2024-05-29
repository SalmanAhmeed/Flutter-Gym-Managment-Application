import 'package:flutter/material.dart';
import 'package:gym_app/viewes/course_view/course_list_view.dart';
import 'package:gym_app/viewes/drawer_view/member_drawer_view.dart';
import 'package:gym_app/viewes/member_view/member_course_list_view.dart';
import 'package:gym_app/viewes/member_view/member_profile_view.dart';




class MemberDashboard extends StatefulWidget {
  @override
  _MemberDashboardState createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Dashboard'),
      ),
      drawer: MemberDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MemberProfileView(),
          MemberCourseListView(),
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
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Course List',
          ),
        ],
      ),
    );
  }
}