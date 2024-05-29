import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/viewes/course_view/Dashboard/admin_dashboard_view.dart';
import 'package:gym_app/viewes/course_view/Dashboard/instructor_dashboard_view.dart';
import 'package:gym_app/viewes/course_view/Dashboard/mamber_dashboard_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_register_view.dart'; // Import InstructorRegisterView

import 'package:gym_app/viewes/member_view/member_registration_view.dart'; // Import MemberRegisterView

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;
  static String logidUserID = "";
  static String loginUserType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.0),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  _showRegisterDialog(context);
                },
                child: Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text);

        // Check user type
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        String userType = userDoc['user_type'];
        loginUserType = userType;
        logidUserID = userCredential.user!.uid;
        print(logidUserID);
        if (userType == 'member') {
          // Navigate to member widget
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MemberDashboard())); // Replace with your member widget
        } else if (userType == 'instructor') {
          // Navigate to instructor widget
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => InstructorDashboard())); // Replace with your instructor widget
        } else if (userType == 'admin') {
          // Navigate to admin widget
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminDashboard())); // Replace with your admin widget
        } else {
          // Handle other user types if needed
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = 'Invalid email or password';
          print('Error code: ${e.code}'); // Debug print
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
          print('Unexpected error: $e'); // Debug print
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register as'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Instructor'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstructorRegisterView()), // Navigate to InstructorRegisterView
                    );
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  child: Text('Member'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberRegistrationView()), // Navigate to MemberRegisterView
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
