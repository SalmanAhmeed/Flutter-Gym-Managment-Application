class Member {
  final String docId;
  final String imageUrl;
  final String name;
  final String address;
  final String phone;
  final String email;
  final double weight;
  final double height;
  final bool gender;
  final String password;
  final String uid;


  Member({
    required this.docId,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.weight,
    required this.height,
    required this.gender,
    required this.password,
    required this.uid,
  });

  Member.fromMap(String docId, Map<String, dynamic> map)
      : docId = docId,
        imageUrl = map['imageUrl'],
        name = map['name'],
        address = map['address'],
        phone = map['phone'],
        email = map['email'],
        weight = (map['weight'] ?? 0.0).toDouble(),
        height = (map['height'] ?? 0.0).toDouble(),
        gender = map['gender'],
        password = map['password'],
        uid = map['uid'];



  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'weight': weight,
      'height': height,
      'gender': gender,
      'password': password,
      'uid': uid,
    };
  }
}
