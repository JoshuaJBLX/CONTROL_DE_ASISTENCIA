import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/class_provider.dart';
import '../../../providers/student_provider.dart';
import '../models/class_model.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teacherController = TextEditingController();
  final _scheduleController = TextEditingController();
  
  List<String> _selectedStudentIds = [];

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  Future<void> _saveClass() async {
    if (_formKey.currentState!.validate()) {
      final newClass = ClassModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        teacher: _teacherController.text,
        schedule: _scheduleController.text,
        studentIds: _selectedStudentIds,
      );
      
      await Provider.of<ClassProvider>(context, listen: false).addClass(newClass);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clase agregada correctamente')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<StudentProvider>(context).activeStudents;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Clase'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveClass,
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la clase',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.class_),
                ),
                validator: (value) => value?.isEmpty == true ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                  labelText: 'Profesor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value?.isEmpty == true ? 'Ingrese el profesor' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Horario',
                  hintText: 'Ej: 09:00 - 11:00',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.schedule),
                ),
                validator: (value) => value?.isEmpty == true ? 'Ingrese el horario' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Seleccionar Alumnos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              students.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.person_off, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('No hay estudiantes registrados'),
                          Text('Agrega estudiantes desde el apartado de Alumnos'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return CheckboxListTile(
                          title: Text(student.name),
                          subtitle: Text(student.email),
                          value: _selectedStudentIds.contains(student.id),
                          onChanged: (selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedStudentIds.add(student.id);
                              } else {
                                _selectedStudentIds.remove(student.id);
                              }
                            });
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}