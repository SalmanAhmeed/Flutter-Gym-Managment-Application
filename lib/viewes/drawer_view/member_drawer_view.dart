import 'package:flutter/material.dart';
import 'package:gym_app/controllers/member_controller.dart';
import 'package:gym_app/modules/member_model.dart';
import 'package:gym_app/viewes/admin_view/exercise_list.dart';
import 'package:gym_app/viewes/course_view/AddCourseView.dart';
import 'package:gym_app/viewes/course_view/course_list_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_list_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_register_view.dart';
import 'package:gym_app/viewes/login/login.dart';
import 'package:gym_app/viewes/member_view/member_course_list_view.dart';
import 'package:gym_app/viewes/member_view/member_list_view.dart';
import 'package:gym_app/viewes/member_view/member_registration_view.dart';

class MemberDrawer extends StatelessWidget {
  final MemberController _memberController = MemberController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memberController.getMemberByUid(LoginPageState.logidUserID),
      builder: (context, AsyncSnapshot<Member?> snapshot) {
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
                child: Text('Error loading member data'),
              ),
            );
          } else {
            Member member = snapshot.data!;
            return Drawer(
              child: ListView(
                // Remove padding
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(member.name),
                    accountEmail: Text(member.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(member.imageUrl),
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
                    title: Text('Course List'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MemberCourseListView()));
                    },
                  ),
                  ListTile(
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
