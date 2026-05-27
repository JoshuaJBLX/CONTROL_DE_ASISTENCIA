import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Mi Perfil',
            subtitle: 'Información personal',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.notifications_none,
            title: 'Notificaciones',
            subtitle: 'Configurar alertas',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.color_lens_outlined,
            title: 'Tema',
            subtitle: 'Claro / Oscuro',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: 'Español',
            onTap: () {},
          ),
          const Divider(height: 32),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Versión 1.0.0',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Cerrar Sesión',
            subtitle: 'Salir de la aplicación',
            onTap: () {
              _showLogoutDialog(context);
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppRouter.goToLogin();
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}