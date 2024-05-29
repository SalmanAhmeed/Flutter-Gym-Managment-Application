import 'dart:io';

import 'package:gym_app/modules/exercise_model.dart';
import 'package:gym_app/services/exercise_service.dart';

class ExerciseController {
  final ExerciseService _exerciseService = ExerciseService();

  Stream<List<Exercise>> getExercises() {
    return _exerciseService.getExercises();
  }

  Future<void> addExercise(
      String name, String description, File imageFile) async {
    await _exerciseService.addExercise(name, description, imageFile);
  }

  Future<void> updateExercise(String docId, String name, String description,
      File? newImageFile, String oldImageUrl) async {
    await _exerciseService.updateExercise(
        docId, name, description, newImageFile, oldImageUrl);
  }

  Future<void> deleteExercise(String docId, String imageUrl) async {
    await _exerciseService.deleteExercise(docId, imageUrl);
  }

  Future<Exercise> getExerciseById(String id) async {
    try {
      // Call the service to get exercise details by id
      Exercise exercise = await _exerciseService.getExerciseById(id);
      return exercise;
    } catch (e) {
      print('Error fetching exercise by id: $e');
      // You can handle error or return default exercise object here
      throw Exception('Failed to fetch exercise by id');
    }
  }
}
