import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/trabajos')) return 1;
    if (location.startsWith('/perfil')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/trabajos'); break;
      case 2: context.go('/perfil'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(location);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F2),
      body: Stack(
        children: [
          // Contenido de la pantalla
          child,

          // Píldora flotante sobre el contenido, sin fondo
          Positioned(
            bottom: 12,
            left: 60,
            right: 60,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF2D3142),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(icon: Icons.home_rounded, selected: index == 0, onTap: () => _onTap(context, 0)),
                  _NavItem(icon: Icons.check_box_rounded, selected: index == 1, onTap: () => _onTap(context, 1)),
                  _NavItem(icon: Icons.person_rounded, selected: index == 2, onTap: () => _onTap(context, 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: selected ? Colors.white : Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}