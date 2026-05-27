import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/class_provider.dart';
import '../../../providers/student_provider.dart';
import '../../students/models/student_model.dart';
import '../models/class_model.dart';  // 👈 AGREGAR ESTA IMPORTACIÓN

class ClassDetailScreen extends StatefulWidget {
  final String classId;
  
  const ClassDetailScreen({
    super.key,
    required this.classId,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedStudentIds = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ClassModel? get _class {
    return Provider.of<ClassProvider>(context, listen: false)
        .getClassById(widget.classId);
  }

  List<Student> _getClassStudents() {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    
    final classObj = classProvider.getClassById(widget.classId);
    if (classObj == null) return [];
    
    return studentProvider.getStudentsByIds(classObj.studentIds);
  }

  List<Student> _getAvailableStudents() {
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    final classObj = _class;
    if (classObj == null) return [];
    
    return studentProvider.activeStudents
        .where((s) => !classObj.studentIds.contains(s.id))
        .toList();
  }

  List<Student> _getFilteredStudents(List<Student> students) {
    if (_searchQuery.isEmpty) return students;
    return students.where((student) =>
      student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      student.documentId.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Future<void> _addStudentsToClass() async {
    if (_selectedStudentIds.isEmpty) {
      Navigator.pop(context);
      return;
    }
    
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final classObj = _class;
    if (classObj == null) return;
    
    final updatedStudentIds = [...classObj.studentIds, ..._selectedStudentIds];
    final updatedClass = classObj.copyWith(studentIds: updatedStudentIds);
    
    await classProvider.updateClass(widget.classId, updatedClass);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedStudentIds.length} estudiantes agregados'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
      setState(() {});
    }
  }

  Future<void> _removeStudentFromClass(String studentId) async {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final classObj = _class;
    if (classObj == null) return;
    
    final updatedStudentIds = classObj.studentIds.where((id) => id != studentId).toList();
    final updatedClass = classObj.copyWith(studentIds: updatedStudentIds);
    
    await classProvider.updateClass(widget.classId, updatedClass);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estudiante removido de la clase'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {});
    }
  }

  void _showAddStudentsDialog() {
    _selectedStudentIds = [];
    _searchController.clear();
    _searchQuery = '';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final availableStudents = _getAvailableStudents();
          final filteredStudents = _getFilteredStudents(availableStudents);
          
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Agregar Estudiantes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setModalState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o DNI...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                if (availableStudents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.person_off, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No hay estudiantes disponibles',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Agrega estudiantes desde el apartado Alumnos',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else if (filteredStudents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No se encontraron resultados'),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        final isSelected = _selectedStudentIds.contains(student.id);
                        
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (selected) {
                            setModalState(() {
                              if (selected == true) {
                                _selectedStudentIds.add(student.id);
                              } else {
                                _selectedStudentIds.remove(student.id);
                              }
                            });
                          },
                          title: Text(student.name),
                          subtitle: Text(student.documentId),
                          secondary: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              student.name[0].toUpperCase(),
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedStudentIds.isEmpty ? null : _addStudentsToClass,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Agregar (${_selectedStudentIds.length})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) {
      setState(() {
        _searchQuery = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final classStudents = _getClassStudents();
    final classObj = _class;
    
    if (classObj == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Clase no encontrada'),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(child: Text('La clase no existe')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(classObj.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddStudentsDialog,
            tooltip: 'Agregar estudiantes',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profesor: ${classObj.teacher}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Horario: ${classObj.schedule}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Total Alumnos: ${classStudents.length}',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: classStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No hay estudiantes en esta clase',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _showAddStudentsDialog,
                          icon: const Icon(Icons.person_add),
                          label: const Text('Agregar Estudiantes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: classStudents.length,
                    itemBuilder: (context, index) {
                      final student = classStudents[index];
                      return _buildStudentCard(student);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentsDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Agregar Alumnos', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            student.name[0].toUpperCase(),
            style: const TextStyle(color: AppColors.primary),
          ),
        ),
        title: Text(student.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.documentId),
            Text(
              student.email,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _removeStudentFromClass(student.id),
          tooltip: 'Remover de la clase',
        ),
        isThreeLine: true,
      ),
    );
  }
}