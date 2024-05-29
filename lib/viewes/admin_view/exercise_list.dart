import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_app/controllers/exercise_controller.dart';
import 'package:gym_app/dialogs/ShearCommonDialogs.dart';
import 'package:gym_app/dialogs/ShearCommonToastDialog.dart';
import 'package:gym_app/dialogs/ShearCommonImageViewerDialogs.dart';
import 'package:gym_app/modules/exercise_model.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseListView extends StatelessWidget {
  final ExerciseController controller = ExerciseController();
  final ImagePicker _picker = ImagePicker();

  Future<void> deleteExercise(Exercise exercise, BuildContext context) async {
    if (await ShearCommonDialogs.showMessageDialogYesNo(
        context, 'ئایا دڵنیایت لە سڕینەوەی ڕاهێنانەکە', 'سڕینەوەی ڕاهێنان')) {
      controller.deleteExercise(exercise.docId, exercise.imageUrl);
      ShearCommonToastDialogs.showToastSuccess(context, 'بەسەرکەوتوی سڕایەوە');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise List')),
      body: StreamBuilder<List<Exercise>>(
        stream: controller.getExercises(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final exercises = snapshot.data!;

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return ListTile(
                title: Text(exercise.name),
                subtitle: Text(exercise.description),
                leading: exercise.imageUrl.isNotEmpty
                    ? Image.network(exercise.imageUrl)
                    : null,
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteExercise(exercise, context)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ShearCommonImageViewerDialogs.showImageViewerDialogWithZoom(
                      exercise.name,
                      exercise.imageUrl, // Assuming imageUrl is a base64 string
                      context,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imageFile = await _getImage();
          if (imageFile != null) {
            await showDialog(
              context: context,
              builder: (context) => AddExerciseDialog(
                controller: controller,
                imageFile: imageFile,
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<File?> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

class AddExerciseDialog extends StatefulWidget {
  final ExerciseController controller;
  final File imageFile;

  const AddExerciseDialog({
    required this.controller,
    required this.imageFile,
  });

  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  late String _name;
  late String _description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (value) => _name = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            onChanged: (value) => _description = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              AddExercise();
              Navigator.pop(context);
            });
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Future<void> AddExercise() async {
    try {
      await widget.controller.addExercise(
        _name,
        _description,
        widget.imageFile,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add: $e')),
      );
    }
  }
}

class EditExerciseDialog extends StatefulWidget {
  final ExerciseController controller;
  final Exercise exercise;

  const EditExerciseDialog({
    required this.controller,
    required this.exercise,
  });

  @override
  _EditExerciseDialogState createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  late String _name;
  late String _description;
  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    _name = widget.exercise.name;
    _description = widget.exercise.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (value) => _name = value,
            controller: TextEditingController(text: _name),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            onChanged: (value) => _description = value,
            controller: TextEditingController(text: _description),
          ),
          ElevatedButton(
            onPressed: () async {
              final newImageFile = await _getImage();
              setState(() {
                _newImageFile = newImageFile;
              });
            },
            child: Text('Select Image'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.controller.updateExercise(
              widget.exercise.docId,
              _name,
              _description,
              _newImageFile,
              widget.exercise.imageUrl,
            );
            Navigator.pop(context);
          },
          child: Text('Update'),
        ),
      ],
    );
  }

  Future<File?> _getImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
