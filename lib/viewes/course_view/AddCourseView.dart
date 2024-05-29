import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/dialogs/ShearCommonDialogs.dart';
import 'package:gym_app/dialogs/ShearCommonToastDialog.dart';
import 'package:gym_app/modules/course_model.dart';
import 'package:gym_app/modules/exercise_model.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';

class AddCourseView extends StatefulWidget {
  @override
  _AddCourseViewState createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  Member? _selectedMember;
  Instructor? _selectedInstructor;
  List<Map<String, String>> _selectedExercises = [];

  List<Exercise> _exercises = [];
  List<Instructor> _instructors = [];
  List<Member> _members = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchExercises();
    fetchInstructors();
    fetchMembers();
  }

  Future<void> fetchExercises() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('exercises').get();
      setState(() {
        _exercises = querySnapshot.docs
            .map((doc) =>
                Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  Future<void> fetchInstructors() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('instructors').get();
      setState(() {
        _instructors = querySnapshot.docs
            .map((doc) =>
                Instructor.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching instructors: $e');
    }
  }

  Future<void> fetchMembers() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('members').get();
      setState(() {
        _members = querySnapshot.docs
            .map((doc) =>
                Member.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      ShearCommonDialogs.showLoaderDialog2(context);
      await _firestore.collection('courses').add(course.toMap());
      clearCourse();
      Navigator.of(context).pop();
     // Navigator.pop(context);


      ShearCommonToastDialogs.showToastSuccess(context, 'Added successfully');
    } catch (e) {
      print('Error adding course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
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
                    _selectedMember = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Member'),
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
                    _selectedInstructor = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Instructor'),
              ),
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedMember != null &&
                      _selectedInstructor != null &&
                      _selectedExercises.isNotEmpty) {
                    Course course = Course(
                      docId: '', // This will be set by Firestore
                      exerciseIds: _selectedExercises,
                      name: _nameController.text,
                      duration: int.parse(_durationController.text),
                      level: _levelController.text,
                      memberId: _selectedMember!.docId,
                      instructorId: _selectedInstructor!.docId,
                    );
                   setState(() {
                     addCourse(course);
                   });


                  }
                },
                child: Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearCourse() {

setState(() {
    _nameController.text="";
    _levelController.text="";
    _durationController.text="";
    _selectedInstructor=null;
    _selectedMember=null;
    _selectedExercises= [];
});
  }
}