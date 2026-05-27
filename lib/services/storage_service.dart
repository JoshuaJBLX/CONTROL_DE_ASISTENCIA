import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/classes/models/class_model.dart';
import '../features/students/models/student_model.dart';

class StorageService {
  static const String _classesKey = 'classes';
  static const String _studentsKey = 'students';
  
  Future<void> saveClasses(List<ClassModel> classes) async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = classes.map((c) => c.toJson()).toList();
    await prefs.setString(_classesKey, jsonEncode(classesJson));
  }
  
  Future<List<ClassModel>> loadClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? classesString = prefs.getString(_classesKey);
    if (classesString == null) return [];
    
    final List<dynamic> classesJson = jsonDecode(classesString);
    return classesJson.map((json) => ClassModel.fromJson(json)).toList();
  }
  
  Future<void> saveStudents(List<Student> students) async {
    final prefs = await SharedPreferences.getInstance();
    final studentsJson = students.map((s) => s.toJson()).toList();
    await prefs.setString(_studentsKey, jsonEncode(studentsJson));
  }
  
  Future<List<Student>> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? studentsString = prefs.getString(_studentsKey);
    if (studentsString == null) return [];
    
    final List<dynamic> studentsJson = jsonDecode(studentsString);
    return studentsJson.map((json) => Student.fromJson(json)).toList();
  }
}