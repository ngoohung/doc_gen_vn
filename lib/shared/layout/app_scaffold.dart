import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_spacing.dart';
import '../../core/utils/responsive.dart';
import 'sidebar_nav.dart';
import 'topbar.dart';
import 'bottom_nav_bar.dart';

/// AppShell — adaptive layout shell.
/// Desktop  → SidebarNav (240 / 56px collapsed) + Topbar + body
/// Tablet   → NavigationRail (56px) + body
/// Mobile   → body + DgBottomNavBar
class AppShell extends ConsumerWidget {
  final String location;
  final Widget child;
  final bool isAdmin;
  final String? pageTitle;
  final List<String>? breadcrumbs;
  final List<Widget>? topbarActions;

  const AppShell({
    super.key,
    required this.location,
    required this.child,
    this.isAdmin = false,
    this.pageTitle,
    this.breadcrumbs,
    this.topbarActions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (Responsive.sizeOf(context)) {
      ScreenSize.desktop => _DesktopShell(shell: this),
      ScreenSize.tablet  => _TabletShell(shell: this),
      ScreenSize.mobile  => _MobileShell(shell: this),
    };
  }

  String get resolvedTitle {
    if (pageTitle != null) return pageTitle!;
    if (location.startsWith('/generate'))    return 'Sinh tài liệu';
    if (location.startsWith('/history'))     return 'Lịch sử';
    if (location.startsWith('/profile'))     return 'Cài đặt';
    if (location.startsWith('/admin/users')) return 'Quản lý người dùng';
    if (location.startsWith('/admin'))       return 'Dashboard';
    return 'DocGen VN';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopShell extends ConsumerWidget {
  final AppShell shell;
  const _DesktopShell({required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          SidebarNav(currentLocation: shell.location, isAdmin: shell.isAdmin),
          Expanded(
            child: Column(
              children: [
                Topbar(
                  title: shell.resolvedTitle,
                  breadcrumbs: shell.breadcrumbs,
                  actions: shell.topbarActions,
                ),
                Expanded(child: shell.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tablet — NavigationRail
// ─────────────────────────────────────────────────────────────────────────────
class _TabletShell extends StatelessWidget {
  final AppShell shell;
  const _TabletShell({required this.shell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.cardDark   : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark  : AppColors.borderLight;

    final navItems = _navItemsFor(shell.isAdmin);
    int selectedIdx = navItems.indexWhere((i) => shell.location.startsWith(i.$2));
    if (selectedIdx < 0) selectedIdx = 0;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: AppSpacing.sidebarCollapsed,
            decoration: BoxDecoration(
              color: bg,
              border: Border(right: BorderSide(color: border)),
            ),
            child: NavigationRail(
              backgroundColor: Colors.transparent,
              selectedIndex: selectedIdx,
              labelType: NavigationRailLabelType.none,
              minWidth: AppSpacing.sidebarCollapsed,
              onDestinationSelected: (i) => context.go(navItems[i].$2),
              selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 20),
              unselectedIconTheme: IconThemeData(
                color: isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight,
                size: 20,
              ),
              indicatorColor: AppColors.primarySoft,
              destinations: navItems.map((item) => NavigationRailDestination(
                icon: Icon(item.$1),
                label: Text(item.$3),
              )).toList(),
            ),
          ),
          Expanded(child: shell.child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile — Bottom Navigation
// ─────────────────────────────────────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  final AppShell shell;
  const _MobileShell({required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell.child,
      bottomNavigationBar: DgBottomNavBar(
        currentLocation: shell.location,
        isAdmin: shell.isAdmin,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
List<(IconData, String, String)> _navItemsFor(bool isAdmin) {
  if (isAdmin) {
    return [
      (Icons.bar_chart_outlined, '/admin',       'Dashboard'),
      (Icons.people_outline,     '/admin/users', 'Người dùng'),
    ];
  }
  return [
    (Icons.bolt_outlined,    '/generate', 'Sinh tài liệu'),
    (Icons.history_outlined, '/history',  'Lịch sử'),
    (Icons.person_outline,   '/profile',  'Cài đặt'),
  ];
}