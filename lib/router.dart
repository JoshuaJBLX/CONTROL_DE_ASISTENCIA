import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/classes/screens/classes_screen.dart';
import 'features/students/screens/students_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/attendance/screens/attendance_screen.dart';
import 'shared/widgets/main_shell.dart';
import 'features/classes/screens/add_class_screen.dart';

class AppRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/add-class':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/add-class'),
          builder: (_) => const AddClassScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/login'),
          builder: (_) => const LoginScreen(),
        );
      case '/dashboard':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/dashboard'),
          builder: (_) => const MainShell(child: DashboardScreen()),
        );
      case '/classes':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/classes'),
          builder: (_) => const MainShell(child: ClassesScreen()),
        );
      case '/students':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/students'),
          builder: (_) => const MainShell(child: StudentsScreen()),
        );
      case '/settings':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/settings'),
          builder: (_) => const MainShell(child: SettingsScreen()),
        );
      case '/attendance':
        // 👇 CORREGIDO: manejar correctamente los argumentos
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/attendance'),
          builder: (_) => AttendanceScreen(
            classId: args?['classId'] as String?,
            className: args?['className'] as String?,
          ),
        );
      default:
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/login'),
          builder: (_) => const LoginScreen(),
        );
    }
  }
  
  static void goToLogin() {
    navigatorKey.currentState?.pushReplacementNamed('/login');
  }
  
  static void goToDashboard() {
    navigatorKey.currentState?.pushReplacementNamed('/dashboard');
  }
  
  static void goToClasses() {
    navigatorKey.currentState?.pushReplacementNamed('/classes');
  }
  
  static void goToStudents() {
    navigatorKey.currentState?.pushReplacementNamed('/students');
  }
  
  static void goToSettings() {
    navigatorKey.currentState?.pushReplacementNamed('/settings');
  }
  
  // 👇 CORREGIDO: pasar los argumentos correctamente
  static void goToAttendance({String? classId, String? className}) {
    final Map<String, String> args = {};
    if (classId != null) args['classId'] = classId;
    if (className != null) args['className'] = className;
    
    navigatorKey.currentState?.pushNamed(
      '/attendance',
      arguments: args.isEmpty ? null : args,
    );
  }
  
  static void goBack() {
    navigatorKey.currentState?.pop();
  }
}