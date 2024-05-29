import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/instructor_controller.dart';
import 'package:gym_app/dialogs/ShearCommonDialogs.dart';
import 'package:gym_app/dialogs/ShearCommonToastDialog.dart';
import 'package:gym_app/modules/instructor_model.dart';
import 'package:gym_app/viewes/instructor_view/instructor_information_view.dart';

class InstructorListView extends StatefulWidget {
  @override
  _InstructorListViewState createState() => _InstructorListViewState();
}

class _InstructorListViewState extends State<InstructorListView> {
  final InstructorController _instructorController = InstructorController();

  Future<void> deleteInstructor(
      Instructor instructor, BuildContext context) async {
    if (await ShearCommonDialogs.showMessageDialogYesNo(
        context, 'ئایا دڵنیایت لە سڕینەوەی ڕاهێنانەکە', 'سڕینەوەی ڕاهێنان')) {
      _instructorController.deleteInstructor(
        instructor.docId,
        instructor.imageUrl,
      );
      ShearCommonToastDialogs.showToastSuccess(context, 'بەسەرکەوتوی سڕایەوە');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructor List'),
      ),
      body: StreamBuilder<List<Instructor>>(
        stream: _instructorController.getInstructors(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Instructor instructor = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(instructor.imageUrl),
                  ),
                  title: Text(instructor.name),
                  subtitle: Text(instructor.certificate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InstructorInformationView(instructor: instructor),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the update instructor view
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateInstructorView(
                                instructor: instructor,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteInstructor(instructor, context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to the add instructor view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddInstructorView(),
            ),
            );


        },
      ),*/
    );
  }
}

class AddInstructorView extends StatefulWidget {
  @override
  _AddInstructorViewState createState() => _AddInstructorViewState();
}

class _AddInstructorViewState extends State<AddInstructorView> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _address;
  late String _phone;
  late String _email;
  late String _certificate;
  late String _gender;
  late String _password;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Instructor'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Add form fields for name, address, phone, email, certificate, gender, and password
            // Add a RaisedButton to submit the form and call the addInstructor method in the InstructorController
            // Add a GestureDetector to select an image file for the instructor
          ],
        ),
      ),
    );
  }
}

class UpdateInstructorView extends StatefulWidget {
  final Instructor instructor;

  UpdateInstructorView({required this.instructor});

  @override
  _UpdateInstructorViewState createState() => _UpdateInstructorViewState();
}

class _UpdateInstructorViewState extends State<UpdateInstructorView> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _address;
  late String _phone;
  late String _email;
  late String _certificate;
  late String _gender;
  late String _password;
  File? _newImageFile;
  String _oldImageUrl = '';

  @override
  void initState() {
    super.initState();
    _name = widget.instructor.name;
    _address = widget.instructor.address;
    _phone = widget.instructor.phone;
    _email = widget.instructor.email;
    _certificate = widget.instructor.certificate;
    _gender = widget.instructor.gender;
    _password = widget.instructor.password;
    _oldImageUrl = widget.instructor.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Instructor'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Add form fields for name, address, phone, email, certificate, gender, and password
            // Add a RaisedButton to submit the form and call the updateInstructor method in the InstructorController
            // Add a GestureDetector to select a new image file for the instructor
          ],
        ),
      ),
    );
  }
}
