import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String estado;
  
  const StatusChip({
    required this.estado, 
    super.key,
  });

  Color get _color {
    switch (estado) {
      case 'Asistió':
        return AppColors.success;
      case 'Falta':
        return AppColors.error;
      case 'Justificado':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}