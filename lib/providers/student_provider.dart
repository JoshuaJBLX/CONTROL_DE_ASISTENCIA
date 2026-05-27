import 'package:flutter/material.dart';
import '../features/students/models/student_model.dart';
import '../services/storage_service.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  final StorageService _storage = StorageService();
  
  List<Student> get students => _students;
  List<Student> get activeStudents => _students.where((s) => s.isActive).toList();
  
  StudentProvider() {
    _loadStudents();
  }
  
  // 👇 Este es el método que faltaba (público)
  Future<void> loadStudents() async {
    await _loadStudents();
  }
  
  // 👇 Método privado interno
  Future<void> _loadStudents() async {
    _students = await _storage.loadStudents();
    if (_students.isEmpty) {
      _addSampleData();
    }
    notifyListeners();
  }
  
  void _addSampleData() {
    _students = [
      Student(
        id: '1',
        name: 'María González',
        email: 'maria@email.com',
        phone: '+34 612 345 678',
        address: 'Calle Principal 123',
        documentId: '12345678A',
        enrollmentDate: DateTime.now(),
        classId: '1', // Matemáticas
      ),
      Student(
        id: '2',
        name: 'Juan Pérez',
        email: 'juan@email.com',
        phone: '+34 623 456 789',
        address: 'Avenida Central 456',
        documentId: '87654321B',
        enrollmentDate: DateTime.now(),
        classId: '1', // Matemáticas
      ),
      Student(
        id: '3',
        name: 'Ana Rodríguez',
        email: 'ana@email.com',
        phone: '+34 634 567 890',
        address: 'Plaza Mayor 789',
        documentId: '11223344C',
        enrollmentDate: DateTime.now(),
        classId: '2', // Física
      ),
    ];
  }
  
  Future<void> _saveStudents() async {
    await _storage.saveStudents(_students);
  }
  
  Future<void> addStudent(Student student) async {
    _students.add(student);
    await _saveStudents();
    notifyListeners();
  }
  
  Future<void> updateStudent(String id, Student updatedStudent) async {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      _students[index] = updatedStudent;
      await _saveStudents();
      notifyListeners();
    }
  }
  
  Future<void> deleteStudent(String id) async {
    _students.removeWhere((s) => s.id == id);
    await _saveStudents();
    notifyListeners();
  }
  
  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Student> getStudentsByIds(List<String> ids) {
    return _students.where((s) => ids.contains(s.id)).toList();
  }
}