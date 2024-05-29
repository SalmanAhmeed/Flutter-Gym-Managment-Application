import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/modules/course_model.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/modules/member_model.dart';

class CourseListViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Course> _courses = [];
  List<Course> _filteredCourses = [];

  List<Course> get courses => _filteredCourses;

  Future<void> fetchCourses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('courses').get();
      _courses = querySnapshot.docs.map((doc) => Course.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
      _filteredCourses = _courses;
    } catch (e) {
      print('Error fetching courses: $e');
    }
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

  void filterCourses(String query) {
    if (query.isEmpty) {
      _filteredCourses = _courses;
    } else {
      _filteredCourses = _courses.where((course) {
        return course.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<Instructor?> getInstructorById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('instructors').doc(id).get();
      if (doc.exists) {
        return Instructor.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching instructor: $e');
    }
    return null;
  }

  Future<Member?> getMemberById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('members').doc(id).get();
      if (doc.exists) {
        return Member.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching member: $e');
    }
    return null;
  }

  void filterCoursesByMemberId(String memberId) {
    _filteredCourses = _courses.where((course) => course.memberId == memberId).toList();
  }
}
