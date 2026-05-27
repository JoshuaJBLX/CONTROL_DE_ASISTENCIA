import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/class_provider.dart';
import '../../../providers/student_provider.dart';
import '../../students/models/student_model.dart';

class AttendanceScreen extends StatefulWidget {
  final String? classId;
  final String? className;
  
  const AttendanceScreen({
    super.key,
    this.classId,
    this.className,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final Map<String, String> _attendanceStatus = {};
  late DateTime _selectedDate;
  bool _isLoading = true;
  
  int _presentCount = 0;
  int _absentCount = 0;
  int _justifiedCount = 0;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _initializeAttendance();
  }

  void _initializeAttendance() {
    setState(() {
      _isLoading = true;
    });
    
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    
    if (widget.classId != null) {
      final classObj = classProvider.getClassById(widget.classId!);
      if (classObj != null) {
        for (final studentId in classObj.studentIds) {
          _attendanceStatus[studentId] = 'pendiente';
        }
      }
    }
    
    _updateSummary();
    setState(() {
      _isLoading = false;
    });
  }

  void _updateSummary() {
    _presentCount = _attendanceStatus.values.where((s) => s == 'presente').length;
    _absentCount = _attendanceStatus.values.where((s) => s == 'ausente').length;
    _justifiedCount = _attendanceStatus.values.where((s) => s == 'justificado').length;
    _pendingCount = _attendanceStatus.values.where((s) => s == 'pendiente').length;
  }

  List<Student> _getClassStudents() {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    
    if (widget.classId == null) return [];
    
    final classObj = classProvider.getClassById(widget.classId!);
    if (classObj == null) return [];
    
    return studentProvider.getStudentsByIds(classObj.studentIds);
  }

  void _setStudentStatus(String studentId, String status) {
    setState(() {
      _attendanceStatus[studentId] = status;
      _updateSummary();
    });
  }

  void _saveAttendance() {
    final students = _getClassStudents();
    final className = widget.className ?? 'Clase';
    final formattedDate = _formatDate(_selectedDate);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Confirmar Asistencia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    className,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fecha: $formattedDate',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryCard('Total Alumnos', students.length, Icons.people, AppColors.primary),
            const SizedBox(height: 8),
            _buildSummaryCard('Presentes', _presentCount, Icons.check_circle, AppColors.success),
            const SizedBox(height: 8),
            _buildSummaryCard('Ausentes', _absentCount, Icons.cancel, AppColors.error),
            const SizedBox(height: 8),
            _buildSummaryCard('Justificados', _justifiedCount, Icons.warning, AppColors.warning),
            if (_pendingCount > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryCard('Pendientes', _pendingCount, Icons.hourglass_empty, Colors.grey),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Asistencia del $formattedDate guardada correctamente'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(color: Colors.grey[700]),
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  void _selectDate() {
  // Variable temporal para el mes seleccionado
  DateTime tempMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  // Variable temporal para el día seleccionado
  DateTime tempSelectedDate = _selectedDate;
  
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Seleccionar Fecha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Selector de mes y año
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Mes anterior
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setModalState(() {
                          if (tempMonth.month == 1) {
                            tempMonth = DateTime(tempMonth.year - 1, 12, 1);
                          } else {
                            tempMonth = DateTime(tempMonth.year, tempMonth.month - 1, 1);
                          }
                        });
                      },
                    ),
                    Text(
                      '${_getMonthName(tempMonth.month)} ${tempMonth.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Mes siguiente (solo si no es futuro)
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        final now = DateTime.now();
                        final nextMonth = tempMonth.month == 12 
                            ? DateTime(tempMonth.year + 1, 1, 1)
                            : DateTime(tempMonth.year, tempMonth.month + 1, 1);
                        
                        // No permitir meses futuros
                        if (nextMonth.isAfter(DateTime(now.year, now.month, 1))) {
                          return;
                        }
                        
                        setModalState(() {
                          if (tempMonth.month == 12) {
                            tempMonth = DateTime(tempMonth.year + 1, 1, 1);
                          } else {
                            tempMonth = DateTime(tempMonth.year, tempMonth.month + 1, 1);
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Días de la semana
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('L', style: TextStyle(color: Colors.red)),
                    Text('M'),
                    Text('M'),
                    Text('J'),
                    Text('V'),
                    Text('S'),
                    Text('D', style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 10),
                // Grid de días
                SizedBox(
                  height: 200,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _getDaysInMonth(tempMonth).length,
                    itemBuilder: (context, index) {
                      final day = _getDaysInMonth(tempMonth)[index];
                      if (day == 0) {
                        return const SizedBox();
                      }
                      
                      final now = DateTime.now();
                      final currentDate = DateTime(tempMonth.year, tempMonth.month, day);
                      final isFutureDate = currentDate.isAfter(now);
                      // 👈 CORREGIDO: comparar con tempSelectedDate en lugar de _selectedDate
                      final isSelected = tempMonth.year == tempSelectedDate.year &&
                                         tempMonth.month == tempSelectedDate.month &&
                                         day == tempSelectedDate.day;
                      
                      return InkWell(
                        onTap: isFutureDate ? null : () {
                          setModalState(() {
                            // Actualizar la fecha seleccionada temporal
                            tempSelectedDate = DateTime(tempMonth.year, tempMonth.month, day);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.primary 
                                : (isFutureDate ? Colors.grey[200] : Colors.transparent),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              day.toString(),
                              style: TextStyle(
                                color: isSelected 
                                    ? Colors.white 
                                    : (isFutureDate ? Colors.grey[400] : Colors.black),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = tempSelectedDate;
                            // Resetear estados al cambiar fecha
                            final studentIds = _attendanceStatus.keys.toList();
                            for (final studentId in studentIds) {
                              _attendanceStatus[studentId] = 'pendiente';
                            }
                            _updateSummary();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fecha cambiada a ${_formatDate(_selectedDate)}'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text('Aceptar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  List<int> _getDaysInMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Ajustar para que lunes sea 1 (en Dart domingo es 7, lunes 1)
    final startOffset = firstWeekday == 7 ? 0 : firstWeekday;
    
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    
    final List<int> days = [];
    
    // Días vacíos al inicio
    for (int i = 1; i < startOffset; i++) {
      days.add(0);
    }
    
    // Días del mes
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
    
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final students = _getClassStudents();
    final classObj = widget.classId != null 
        ? Provider.of<ClassProvider>(context).getClassById(widget.classId!)
        : null;
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.className != null 
                ? 'Asistencia - ${widget.className}' 
                : 'Nueva Asistencia',
              style: const TextStyle(fontSize: 16),
            ),
            if (classObj != null)
              Text(
                classObj.teacher,
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
            tooltip: 'Seleccionar fecha',
          ),
        ],
      ),
      body: Column(
        children: [
          // Cabecera con fecha y resumen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Selector de fecha
                InkWell(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fecha de la clase',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  _formatDate(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Resumen de asistencia
                Row(
                  children: [
                    _buildSummaryItem('Presentes', _presentCount, AppColors.success),
                    _buildSummaryItem('Ausentes', _absentCount, AppColors.error),
                    _buildSummaryItem('Justif.', _justifiedCount, AppColors.warning),
                    _buildSummaryItem('Pend.', _pendingCount, Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          
          // Lista de estudiantes
          Expanded(
            child: students.isEmpty
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
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final currentStatus = _attendanceStatus[student.id] ?? 'pendiente';
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                    child: Text(
                                      student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          student.documentId,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildStatusButton(
                                    label: 'Presente',
                                    color: AppColors.success,
                                    isSelected: currentStatus == 'presente',
                                    onTap: () => _setStudentStatus(student.id, 'presente'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStatusButton(
                                    label: 'Ausente',
                                    color: AppColors.error,
                                    isSelected: currentStatus == 'ausente',
                                    onTap: () => _setStudentStatus(student.id, 'ausente'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStatusButton(
                                    label: 'Justif.',
                                    color: AppColors.warning,
                                    isSelected: currentStatus == 'justificado',
                                    onTap: () => _setStudentStatus(student.id, 'justificado'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: (_presentCount > 0 || _absentCount > 0 || _justifiedCount > 0)
                ? _saveAttendance
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Guardar Asistencia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}