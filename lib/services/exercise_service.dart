import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gym_app/modules/exercise_model.dart';

class ExerciseService {
  final CollectionReference _exercisesCollection =
      FirebaseFirestore.instance.collection('exercises');

  Future<void> addExercise(
      String name, String description, File imageFile) async {
    try {
      String imageUrl = await _uploadImage(imageFile);
      await _exercisesCollection.add({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Failed to add exercise: $e');
    }
  }

  Future<void> updateExercise(String docId, String name, String description,
      File? newImageFile, String oldImageUrl) async {
    try {
      String newImageUrl = '';
      if (newImageFile != null) {
        // Delete the old image if it exists
        if (oldImageUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
        }
        newImageUrl = await _uploadImage(newImageFile);
      }
      await _exercisesCollection.doc(docId).update({
        'name': name,
        'description': description,
        'imageUrl': newImageUrl,
      });
    } catch (e) {
      print('Failed to update exercise: $e');
    }
  }

  Future<void> deleteExercise(String docId, String imageUrl) async {
    try {
      await _exercisesCollection.doc(docId).delete();
      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
    } catch (e) {
      print('Failed to delete exercise: $e');
    }
  }

  Stream<List<Exercise>> getExercises() {
    return _exercisesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref =
          FirebaseStorage.instance.ref().child('exercise_images/$imageName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }

  Future<Exercise> getExerciseById(String id) async {
    try {
      DocumentSnapshot doc = await _exercisesCollection.doc(id).get();
      if (doc.exists) {
        return Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Exercise not found');
      }
    } catch (e) {
      print('Error fetching exercise by id: $e');
      throw Exception('Failed to fetch exercise by id');
    }
  }
}
