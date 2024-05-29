import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/services/instructor_service.dart';

class InstructorController {
  final InstructorService _instructorService = InstructorService();

  Future<void> addInstructor(
      String name,
      String address,
      String phone,
      String email,
      String certificate,
      String gender,
      String password,
      File? imageFile) async {
    await _instructorService.addInstructor(
        name, address, phone, email, certificate, gender, password, imageFile);
  }

  Stream<List<Instructor>> getInstructors() {
    return _instructorService.getInstructors();
  }

  Future<void> updateInstructor(
      String docId,
      String name,
      String address,
      String phone,
      String email,
      String certificate,
      String gender,
      String password,
      File? newImageFile,
      String oldImageUrl) async {
    await _instructorService.updateInstructor(docId, name, address, phone,
        email, certificate, gender, password, newImageFile, oldImageUrl);
  }

  Future<void> deleteInstructor(String docId, String imageUrl) async {
    await _instructorService.deleteInstructor(docId, imageUrl);
  }


  Future<Instructor?> getInstructorByUid(String uid) async {
    try {
      if (uid == null) {
        return null;
      }
      print(uid);

      QuerySnapshot instructorsSnapshot = await FirebaseFirestore.instance
          .collection('instructors')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (instructorsSnapshot.docs.isNotEmpty) {
        DocumentSnapshot memberDoc = instructorsSnapshot.docs.first;
        return Instructor.fromMap(memberDoc.id, memberDoc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      // Handle error
      print('Error fetching instructors: $e');
      return null;
    }
  }
}
