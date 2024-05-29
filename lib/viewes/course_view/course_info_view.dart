import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/dialogs/ShearCommonDialogs.dart';
import 'package:gym_app/dialogs/ShearCommonToastDialog.dart';
import 'package:gym_app/modules/course_model.dart';
import 'package:gym_app/modules/exercise_model.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';
import 'package:gym_app/view_model/course_list_view_model.dart';
import 'package:gym_app/view_model/course_view_model.dart';

class CourseInfoView extends StatefulWidget {
  final Course course;
  final CourseViewModel viewModel = CourseViewModel();

  CourseInfoView({required this.course});

  @override
  _CourseInfoViewState createState() => _CourseInfoViewState();
}

class _CourseInfoViewState extends State<CourseInfoView> {
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
  final CourseListViewModel _viewModel = CourseListViewModel();

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

    List<String> exerIds = widget.course.exerciseIds.map((e) => e['exercise_id'] ?? '').toList();
   // _selectedExercises = widget.course.exerciseIds.where((e) => exerIds.contains(e.docId));
    _selectedExercises = widget.course.exerciseIds;
print(_exercises);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _levelController.dispose();
    super.dispose();
  }

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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration (days)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Duration is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _levelController,
                decoration: InputDecoration(labelText: 'Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Level is required';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Member>(
                value: _selectedMember,
                items: _members.map((member) {
                  return DropdownMenuItem<Member>(
                    value: member,
                    child: Text(member.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMember = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Member'),
                validator: (value) {
                  if (value == null) {
                    return 'Member is required';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Instructor>(
                value: _selectedInstructor,
                items: _instructors.map((instructor) {
                  return DropdownMenuItem<Instructor>(
                    value: instructor,
                    child: Text(instructor.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedInstructor = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Instructor'),
                validator: (value) {
                  if (value == null) {
                    return 'Instructor is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedMember != null &&
                        _selectedInstructor != null
                       ) {
                     // _selectedExercises.isNotEmpty) {
                      Course course = Course(
                        docId: widget.course.docId, // This will be set by Firestore
                        exerciseIds: _selectedExercises,
                        name: _nameController.text,
                        duration: int.parse(_durationController.text),
                        level: _levelController.text,
                        memberId: _selectedMember!.docId,
                        instructorId: _selectedInstructor!.docId,
                      );
                      print("22222222222222");
                      updateCourse(course);
                  }
                },
                child: Text('Update'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Delete course logic
                  deleteCourse(widget.course);
                },
                child: Text('Delete'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Select Exercises'),
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            width: double.maxFinite,
                            child: ListView.builder(
                              itemCount: _exercises.length,
                              itemBuilder: (context, index) {
                                final exercise = _exercises[index];
                                Map<String, String> cExercise = {
                                  'exercise_id': exercise.docId,
                                  'optional': 'optionalvalue2',
                                };
                                final isSelected = _selectedExercises.any((e) =>
                                e['exercise_id'] ==
                                    cExercise['exercise_id']);

                                final imageUrl = exercise.imageUrl;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedExercises.removeWhere((e) =>
                                        e['exercise_id'] == exercise.docId);
                                      } else {
                                        _selectedExercises.add(cExercise);
                                      }
                                    });
                                  },
                                  /*   child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            exercise.name,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null && value) {
                                                _selectedExercises
                                                    .add(cExercise);
                                              } else {
                                                _selectedExercises.removeWhere(
                                                    (e) =>
                                                        e['exercise_id'] ==
                                                        exercise.docId);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
*/

                                  child: Card(
                                    margin: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to Member Information view
                                      },
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
                                        trailing:               Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null && value) {
                                                _selectedExercises
                                                    .add(cExercise);
                                              } else {
                                                _selectedExercises.removeWhere(
                                                        (e) =>
                                                    e['exercise_id'] ==
                                                        exercise.docId);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),


                                );
                              },
                            ),
                          );
                        },
                      ),
                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Select'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Select Exercises'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateCourse(Course course) async {
    print(course);
    try {
      await widget.viewModel.updateCourse(course);
      ShearCommonToastDialogs.showToastSuccess(
          context, "Updated successful");
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  Future<void> deleteCourse(Course course) async {
    if (await ShearCommonDialogs.showMessageDialogYesNo(
        context, 'Are you sure to delete the course?', 'Deleting course')) {
      try {
        ShearCommonDialogs.showLoaderDialog2(context);

        widget.viewModel.deleteCourse(widget.course.docId);
        Navigator.pop(context);

        Navigator.of(context).pop(); //
      } catch (e) {
        // Handle any errors that might occur during member deletion
        print("Error deleting member: $e");
      }

      ShearCommonToastDialogs.showToastSuccess(context, 'Deleted successfully');
    }
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
