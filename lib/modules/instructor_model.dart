import 'package:cloud_firestore/cloud_firestore.dart';

class Instructor {
  final String docId;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String certificate;
  final String gender;
  final String password;
  final String imageUrl; // Added imageUrl attribute
  final String uid; // Added imageUrl attribute

  Instructor({
    required this.docId,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.certificate,
    required this.gender,
    required this.password,
    required this.imageUrl,
    required this.uid,
  });

  Instructor.fromMap(String docId, Map<String, dynamic> map)
      : docId = docId,
        name = map['name'],
        address = map['address'],
        phone = map['phone'],
        email = map['email'],
        certificate = map['certificate'],
        gender = map['gender'],
        password = map['password'],
        imageUrl = map['imageUrl'],
        uid = map['uid'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'certificate': certificate,
      'gender': gender,
      'password': password,
      'imageUrl': imageUrl,
      'uid': uid,
    };
  }
}
