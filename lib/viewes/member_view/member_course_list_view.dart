import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:gym_app/view_model/course_list_view_model.dart';
import 'package:gym_app/viewes/course_view/course_info_view.dart';
import 'package:gym_app/controllers/member_controller.dart';
import 'package:gym_app/viewes/login/login.dart';
import 'package:gym_app/viewes/member_view/member_course_info_view.dart'; // Import your controller

class MemberCourseListView extends StatefulWidget {
  @override
  _MemberCourseListViewState createState() => _MemberCourseListViewState();
}

class _MemberCourseListViewState extends State<MemberCourseListView> {
  final CourseListViewModel _viewModel = CourseListViewModel();
  final MemberController _memberController = MemberController();
  String _memberId = '';

  @override
  void initState() {
    print("WERERWERWER");
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    print("WERERWERWER");
    final member = await _memberController.getMemberByUid(LoginPageState.logidUserID);
    print(LoginPageState.logidUserID);
    if (member != null) {
      _memberId = member.docId;
      await _viewModel.fetchCourses();
      _viewModel.filterCoursesByMemberId(_memberId);
    }
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        /* appBar: EasySearchBar(
          title: Text('Courses', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w700)),
          backgroundColor: Colors.white,
          onSearch: (value) {
            setState(() {
              _viewModel.filterCourses(value);
            });
          },
        ),*/
        body: _viewModel.courses.isEmpty
            ? Center(child:  Text( "No Course found"))
            : ListView.builder(
          itemCount: _viewModel.courses.length,
          itemBuilder: (context, index) {
            final course = _viewModel.courses[index];
            return FutureBuilder(
              future: Future.wait([
                _viewModel.getInstructorName(course.instructorId),
                _viewModel.getMemberName(course.memberId),
              ]),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final instructorName = snapshot.data![0];
                final memberName = snapshot.data![1];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: Text(
                      course.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Member: $memberName', style: TextStyle(fontSize: 14)),
                              Text('Instructor: $instructorName', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration: ${course.duration} days', style: TextStyle(fontSize: 14)),
                              Text('Level: ${course.level}', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 22, 159, 146))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 12.0), // Space between text and arrow
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MemberCourseInfoView(course: course)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
