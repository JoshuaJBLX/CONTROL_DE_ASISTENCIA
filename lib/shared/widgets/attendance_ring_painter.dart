import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';  // Corregido: subir dos niveles (../../)

class AttendanceRingPainter extends CustomPainter {
  final double percentage;
  
  const AttendanceRingPainter({required this.percentage});  // Agregado const

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    
    // Fondo gris
    canvas.drawCircle(center, radius, Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10);
    
    // Arco de progreso azul
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * (percentage / 100),
      false,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant AttendanceRingPainter old) {
    return old.percentage != percentage;
  }
}