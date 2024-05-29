class Course {
  final String docId;
  final List<Map<String, String>> exerciseIds;
  final String name;
  final int duration;
  final String level;
  final String memberId;
  final String instructorId;

  Course({
    required this.docId,
    required this.exerciseIds,
    required this.name,
    required this.duration,
    required this.level,
    required this.memberId,
    required this.instructorId,
  });

  Course.fromMap(String docId, Map<String, dynamic> map)
      : docId = docId,
        exerciseIds = List<Map<String, String>>.from(
          map['exerciseIds'].map((e) => Map<String, String>.from(e)),
        ),
        name = map['name'],
        duration = map['duration'],
        level = map['level'],
        memberId = map['memberId'],
        instructorId = map['instructorId'];

  Map<String, dynamic> toMap() {
    return {
      'exerciseIds': exerciseIds,
      'name': name,
      'duration': duration,
      'level': level,
      'memberId': memberId,
      'instructorId': instructorId,
    };
  }
}
