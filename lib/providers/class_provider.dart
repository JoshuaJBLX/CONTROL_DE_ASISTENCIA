import 'package:flutter/material.dart';
import '../features/classes/models/class_model.dart';
import '../services/storage_service.dart';

class ClassProvider extends ChangeNotifier {
  List<ClassModel> _classes = [];
  final StorageService _storage = StorageService();
  
  List<ClassModel> get classes => _classes;
  
  ClassProvider() {
    _loadClasses();
  }
  
  Future<void> _loadClasses() async {
    _classes = await _storage.loadClasses();
    notifyListeners();
  }
  
  Future<void> _saveClasses() async {
    await _storage.saveClasses(_classes);
  }
  
  Future<void> addClass(ClassModel newClass) async {
    _classes.add(newClass);
    await _saveClasses();
    notifyListeners();
  }
  
  Future<void> updateClass(String id, ClassModel updatedClass) async {
    final index = _classes.indexWhere((c) => c.id == id);
    if (index != -1) {
      _classes[index] = updatedClass;
      await _saveClasses();
      notifyListeners();
    }
  }
  Future<void> loadClasses() async {
    await _loadClasses();
  }
  
  Future<void> deleteClass(String id) async {
    _classes.removeWhere((c) => c.id == id);
    await _saveClasses();
    notifyListeners();
  }
  
  List<String> getClassStudents(String classId) {
    final classObj = _classes.firstWhere((c) => c.id == classId);
    return classObj.studentIds;
  }
  
  ClassModel? getClassById(String id) {
    try {
      return _classes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}