class ClassModel {
  final String id;
  final String name;
  final String teacher;
  final String schedule;
  final List<String> studentIds;
  
  ClassModel({
    required this.id,
    required this.name,
    required this.teacher,
    required this.schedule,
    required this.studentIds,
  });
  
  ClassModel copyWith({
    String? id,
    String? name,
    String? teacher,
    String? schedule,
    List<String>? studentIds,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      schedule: schedule ?? this.schedule,
      studentIds: studentIds ?? this.studentIds,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'schedule': schedule,
      'studentIds': studentIds,
    };
  }
  
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String,
      name: json['name'] as String,
      teacher: json['teacher'] as String,
      schedule: json['schedule'] as String,
      studentIds: List<String>.from(json['studentIds'] ?? []),
    );
  }
}