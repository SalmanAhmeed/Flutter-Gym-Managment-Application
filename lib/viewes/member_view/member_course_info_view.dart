import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/dialogs/ShearCommonDialogs.dart';
import 'package:gym_app/modules/course_model.dart';
import 'package:gym_app/modules/exercise_model.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';

class MemberCourseInfoView extends StatefulWidget {
  final Course course;

  MemberCourseInfoView({required this.course});

  @override
  _MemberCourseInfoViewState createState() => _MemberCourseInfoViewState();
}

class _MemberCourseInfoViewState extends State<MemberCourseInfoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _durationController;
  late TextEditingController _levelController;
  Member? _selectedMember;
  Instructor? _selectedInstructor;
  List<Exercise> _exercises = [];
  List<Instructor> _instructors = [];
  List<Member> _members = [];
  List<Map<String, String>> _selectedExercises = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _durationController = TextEditingController();
    _levelController = TextEditingController();
    _selectedMember = null;
    _selectedInstructor = null;

    displayCourseInfo();
  }

  Future<void> displayCourseInfo() async {
    await fetchExercises();
    await fetchInstructors();
    await fetchMembers();
    _nameController.text = widget.course.name;
    _durationController.text = widget.course.duration.toString();
    _levelController.text = widget.course.level;

    _selectedMember = _members.firstWhere((member) => member.docId == widget.course.memberId);
    _selectedInstructor = _instructors.firstWhere((instructor) => instructor.docId == widget.course.instructorId);

    _selectedExercises = widget.course.exerciseIds;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _nameController.text),
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _durationController.text),
                decoration: InputDecoration(labelText: 'Duration (days)'),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _levelController.text),
                decoration: InputDecoration(labelText: 'Level'),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _selectedMember?.name ?? ''),
                decoration: InputDecoration(labelText: 'Member'),
                onTap: () {
                  // Show a dialog to select a member
                },
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _selectedInstructor?.name ?? ''),
                decoration: InputDecoration(labelText: 'Instructor'),
                onTap: () {
                  // Show a dialog to select an instructor
                },
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedExercises.length,
                itemBuilder: (context, index) {
                  final exerciseId = _selectedExercises[index]['exercise_id'];
                  final exercise = _exercises.firstWhere((e) => e.docId == exerciseId);

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(exercise.imageUrl),
                          radius: 30,
                        ),
                        title: Text(
                          exercise.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(exercise.description),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> fetchExercises() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('exercises').get();
      setState(() {
        _exercises = querySnapshot.docs
            .map((doc) => Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  Future<void> fetchInstructors() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('instructors').get();
      setState(() {
        _instructors = querySnapshot.docs
            .map((doc) => Instructor.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching instructors: $e');
    }
  }

  Future<void> fetchMembers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('members').get();
      setState(() {
        _members = querySnapshot.docs
            .map((doc) => Member.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching members: $e');
    }
  }
}
