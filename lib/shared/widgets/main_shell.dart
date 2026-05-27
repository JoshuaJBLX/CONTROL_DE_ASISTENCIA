import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../router.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  
  const MainShell({
    required this.child,
    super.key,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final String route = ModalRoute.of(context)?.settings.name ?? '/dashboard';
    setState(() {
      switch (route) {
        case '/dashboard':
          _selectedIndex = 0;
          break;
        case '/classes':
          _selectedIndex = 1;
          break;
        case '/students':
          _selectedIndex = 2;
          break;
        case '/settings':
          _selectedIndex = 3;
          break;
      }
    });
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        AppRouter.goToDashboard();
        break;
      case 1:
        AppRouter.goToClasses();
        break;
      case 2:
        AppRouter.goToStudents();
        break;
      case 3:
        AppRouter.goToSettings();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        elevation: 8,
        animationDuration: const Duration(milliseconds: 200),
        indicatorColor: AppColors.primary,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_outlined),
            selectedIcon: Icon(Icons.class_),
            label: 'Clases',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Alumnos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}