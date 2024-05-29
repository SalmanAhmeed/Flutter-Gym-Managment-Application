class Exercise {
  final String docId;
  final String name;
  final String description;
  final String imageUrl;

  Exercise({
    required this.docId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  Exercise.fromMap(String docId, Map<String, dynamic> map)
      : docId = docId,
        name = map['name'],
        description = map['description'],
        imageUrl = map['imageUrl'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
