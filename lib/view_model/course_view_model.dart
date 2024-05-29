import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/modules/course_model.dart';
import 'package:gym_app/modules/exercise_model.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';

class CourseViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Exercise> exercises = [];
  Member? member;
  Instructor? instructor;

  Future<void> addCourse(Course course) async {
    await _firestore.collection('courses').add(course.toMap());
  }

  Future<void> fetchCourseDetails(Course course) async {
    // Fetch Exercises
    exercises = await Future.wait(course.exerciseIds.map((id) async {
      var doc =
          await _firestore.collection('exercises').doc(id as String?).get();
      return Exercise.fromMap(doc.id, doc.data()!);
    }).toList());

    // Fetch Member
    var memberDoc =
        await _firestore.collection('members').doc(course.memberId).get();
    member = Member.fromMap(memberDoc.id, memberDoc.data()!);

    // Fetch Instructor
    var instructorDoc = await _firestore
        .collection('instructors')
        .doc(course.instructorId)
        .get();
    instructor = Instructor.fromMap(instructorDoc.id, instructorDoc.data()!);

    notifyListeners();
  }


  Future<String> getInstructorName(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('instructors').doc(id).get();
      if (doc.exists) {
        return Instructor.fromMap(doc.id, doc.data() as Map<String, dynamic>).name;
      }
    } catch (e) {
      print('Error fetching instructor: $e');
    }
    return 'Unknown';
  }

  Future<String> getMemberName(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('members').doc(id).get();
      if (doc.exists) {
        return Member.fromMap(doc.id, doc.data() as Map<String, dynamic>).name;
      }
    } catch (e) {
      print('Error fetching member: $e');
    }
    return 'Unknown';
  }

  Future<void> updateCourse(Course course) async {
    try {
      await _firestore.collection('courses').doc(course.docId).update(course.toMap());
    } catch (e) {
      print('Error updating course: $e');
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

}
