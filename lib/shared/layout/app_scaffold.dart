// lib/shared/layout/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_spacing.dart';
import '../../core/utils/responsive.dart';
import 'sidebar_nav.dart';
import 'topbar.dart';
import 'bottom_nav_bar.dart';

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

  String get resolvedTitle {
    if (pageTitle != null) return pageTitle!;
    if (location.startsWith('/generate'))    return 'Sinh tài liệu';
    if (location.startsWith('/history'))     return 'Lịch sử';
    if (location.startsWith('/profile'))     return 'Cài đặt';
    if (location.startsWith('/admin/users')) return 'Quản lý người dùng';
    if (location.startsWith('/admin'))       return 'Dashboard';
    return 'DocGen VN';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (Responsive.of(context)) {
      ScreenSize.desktop => _DesktopShell(shell: this),
      ScreenSize.tablet  => _TabletShell(shell: this),
      ScreenSize.mobile  => _MobileShell(shell: this),
    };
  }
}

// ── Desktop ───────────────────────────────────────────────────────────────────
class _DesktopShell extends ConsumerWidget {
  final AppShell shell;
  const _DesktopShell({required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items  = _navItemsFor(shell.isAdmin);
    int idx = items.indexWhere((i) => shell.location.startsWith(i.$2));
    if (idx < 0) idx = 0;

    return Scaffold(
      body: Row(
        children: [
          SidebarNav(
            selectedIndex: idx,
            isAdmin: shell.isAdmin,
            collapsed: false,
            onItemTap: (i) => context.go(items[i].$2),
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  selectedIndex: idx,
                  isAdmin: shell.isAdmin,
                  showMenuButton: false,
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

// ── Tablet (NavigationRail) ────────────────────────────────────────────────────
class _TabletShell extends StatelessWidget {
  final AppShell shell;
  const _TabletShell({required this.shell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.cardDark  : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final items  = _navItemsFor(shell.isAdmin);
    int idx = items.indexWhere((i) => shell.location.startsWith(i.$2));
    if (idx < 0) idx = 0;

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
              selectedIndex: idx,
              labelType: NavigationRailLabelType.none,
              minWidth: AppSpacing.sidebarCollapsed,
              onDestinationSelected: (i) => context.go(items[i].$2),
              selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 20),
              unselectedIconTheme: IconThemeData(
                color: isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight,
                size: 20,
              ),
              indicatorColor: AppColors.primarySoft,
              destinations: items.map((item) => NavigationRailDestination(
                icon: Icon(item.$1),
                label: Text(item.$3),
              )).toList(),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  selectedIndex: idx,
                  isAdmin: shell.isAdmin,
                  showMenuButton: false,
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

// ── Mobile (BottomNav) ─────────────────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  final AppShell shell;
  const _MobileShell({required this.shell});

  @override
  Widget build(BuildContext context) {
    final items  = _navItemsFor(shell.isAdmin);
    int idx = items.indexWhere((i) => shell.location.startsWith(i.$2));
    if (idx < 0) idx = 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: TopBar(
          selectedIndex: idx,
          isAdmin: shell.isAdmin,
          showMenuButton: true,
        ),
      ),
      body: shell.child,
      bottomNavigationBar: DgBottomNavBar(
        selectedIndex: idx,
        isAdmin: shell.isAdmin,
        onTap: (i) => context.go(items[i].$2),
      ),
    );
  }
}

List<(IconData, String, String)> _navItemsFor(bool isAdmin) => isAdmin
    ? [
  (Icons.bar_chart_outlined, '/admin',       'Dashboard'),
  (Icons.people_outline,     '/admin/users', 'Người dùng'),
]
    : [
  (Icons.bolt_outlined,    '/generate', 'Sinh tài liệu'),
  (Icons.history_outlined, '/history',  'Lịch sử'),
  (Icons.person_outline,   '/profile',  'Cài đặt'),
];