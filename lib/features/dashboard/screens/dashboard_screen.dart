import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/class_provider.dart';
import '../../../router.dart';
import '../../classes/models/class_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const _SearchBar(),
            const SizedBox(height: 24),
            const _DaySummaryCard(),
            const SizedBox(height: 16),
            const _NewAttendanceCard(),
            const SizedBox(height: 16),
            const _ClassesList(),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGETS ====================

// Barra de búsqueda
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Buscar clases, estudiantes...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

// Tarjeta de resumen del día
class _DaySummaryCard extends StatelessWidget {
  const _DaySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asistencia del Día',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tasa de asistencia:', style: TextStyle(color: Colors.white70, fontSize: 14)),
              _PercentageBadge(),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.94,
            backgroundColor: Colors.white30,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //height: 10,
          ),
        ],
      ),
    );
  }
}

class _PercentageBadge extends StatelessWidget {
  const _PercentageBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '94%',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Tarjeta para nueva asistencia
class _NewAttendanceCard extends StatelessWidget {
  const _NewAttendanceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => AppRouter.goToAttendance(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Row(
            children: [
              _CardIcon(),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nueva Asistencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    _CardSubtitle(),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardIcon extends StatelessWidget {
  const _CardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 32),
    );
  }
}

class _CardSubtitle extends StatelessWidget {
  const _CardSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Escanea el código QR del estudiante',
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    );
  }
}

// Lista de clases
class _ClassesList extends StatelessWidget {
  const _ClassesList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mis Clases', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _AddClassButton(),
            ],
          ),
        ),
        _ClassesListView(),
      ],
    );
  }
}

class _AddClassButton extends StatelessWidget {
  const _AddClassButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
      onPressed: () => Navigator.pushNamed(context, '/add-class'),
      tooltip: 'Agregar Clase',
    );
  }
}

class _ClassesListView extends StatelessWidget {
  const _ClassesListView();

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final classes = classProvider.classes;

    if (classes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.class_, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No tienes clases aún', style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text('Presiona el botón + para agregar', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classInfo = classes[index];
        return _ClassCard(classInfo: classInfo);
      },
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassModel classInfo;

  const _ClassCard({required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.class_, color: AppColors.primary),
        ),
        title: Text(classInfo.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(classInfo.teacher),
            Text(classInfo.schedule, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text('Alumnos: ${classInfo.studentIds.length}',
                style: TextStyle(fontSize: 12, color: AppColors.primary)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => AppRouter.goToAttendance(classId: classInfo.id, className: classInfo.name),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Tomar Asistencia'),
        ),
        isThreeLine: true,
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}