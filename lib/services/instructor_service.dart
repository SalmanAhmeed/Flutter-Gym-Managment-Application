import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gym_app/modules/instructor_model.dart';

class InstructorService {
  final CollectionReference _instructorsCollection =
      FirebaseFirestore.instance.collection('instructors');

  Future<void> addInstructor(
      String name,
      String address,
      String phone,
      String email,
      String certificate,
      String gender,
      String password,
      File? imageFile) async {
    try {
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }
      await _instructorsCollection.add({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'certificate': certificate,
        'gender': gender,
        'password': password,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Failed to add instructor: $e');
    }
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
    try {
      String newImageUrl = oldImageUrl;
      if (newImageFile != null) {
        if (oldImageUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
        }
        newImageUrl = await _uploadImage(newImageFile);
      }
      await _instructorsCollection.doc(docId).update({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'certificate': certificate,
        'gender': gender,
        'password': password,
        'imageUrl': newImageUrl,
      });
    } catch (e) {
      print('Failed to update instructor: $e');
    }
  }

  Future<void> deleteInstructor(String docId, String imageUrl) async {
    try {
      await _instructorsCollection.doc(docId).delete();
      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
    } catch (e) {
      print('Failed to delete instructor: $e');
    }
  }

  Stream<List<Instructor>> getInstructors() {
    return _instructorsCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Instructor.fromMap(
                  doc.id, doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref =
          FirebaseStorage.instance.ref().child('instructor_images/$imageName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }
}
