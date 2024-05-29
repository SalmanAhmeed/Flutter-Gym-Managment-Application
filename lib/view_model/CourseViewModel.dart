import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/modules/course_model.dart';
import 'package:gym_app/modules/exercise_model.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';

class CourseViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Exercise> _exercises = [];
  List<Instructor> _instructors = [];
  List<Member> _members = [];

  List<Exercise> get exercises => _exercises;
  List<Instructor> get instructors => _instructors;
  List<Member> get members => _members;

  CourseViewModel() {
    fetchExercises();
    fetchInstructors();
    fetchMembers();
  }

  Future<void> fetchExercises() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('exercises').get();
      _exercises = querySnapshot.docs
          .map((doc) =>
              Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  Future<void> fetchInstructors() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('instructors').get();
      _instructors = querySnapshot.docs
          .map((doc) =>
              Instructor.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching instructors: $e');
    }
  }

  Future<void> fetchMembers() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('members').get();
      _members = querySnapshot.docs
          .map((doc) =>
              Member.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      await _firestore.collection('courses').add(course.toMap());
    } catch (e) {
      print('Error adding course: $e');
    }
  }


}
