// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/landing/presentation/landing_screen.dart';
import '../../features/generate/presentation/generate_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/admin/presentation/dashboard_screen.dart';
import '../../features/admin/presentation/user_management_screen.dart';
import '../../shared/layout/app_scaffold.dart';

class AppRoutes {
  static const landing        = '/';
  static const login          = '/login';
  static const generate       = '/generate';
  static const history        = '/history';
  static const profile        = '/profile';
  static const adminDashboard = '/admin';
  static const adminUsers     = '/admin/users';
  static const adminProfile   = '/admin/profile'; // Thêm route này cho Admin
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(path: AppRoutes.landing, builder: (_, __) => const LandingScreen()),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
        routes: [
          GoRoute(path: 'register', builder: (_, __) => const RegisterScreen()),
          GoRoute(path: 'forgot',   builder: (_, __) => const ForgotPasswordScreen()),
        ],
      ),

      // Member shell
      ShellRoute(
        builder: (context, state, child) => AppShell(
          location: state.matchedLocation, isAdmin: false, child: child,
        ),
        routes: [
          GoRoute(path: AppRoutes.generate, pageBuilder: (_, s) => _fade(const GenerateScreen(), s)),
          GoRoute(path: AppRoutes.history,  pageBuilder: (_, s) => _fade(const HistoryScreen(), s)),
          GoRoute(path: AppRoutes.profile,  pageBuilder: (_, s) => _fade(const ProfileScreen(), s)),
        ],
      ),

      // Admin shell
      ShellRoute(
        builder: (context, state, child) => AppShell(
          location: state.matchedLocation, isAdmin: true, child: child,
        ),
        routes: [
          GoRoute(path: AppRoutes.adminDashboard, pageBuilder: (_, s) => _fade(const DashboardScreen(), s)),
          GoRoute(path: AppRoutes.adminUsers,     pageBuilder: (_, s) => _fade(const UserManagementScreen(), s)),
          // Thêm route profile vào đây để giữ sidebar Admin
          GoRoute(path: AppRoutes.adminProfile,   pageBuilder: (_, s) => _fade(const ProfileScreen(), s)),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('404', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('Không tìm thấy trang'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(AppRoutes.generate),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    ),
  );
});

CustomTransitionPage<void> _fade(Widget child, GoRouterState state) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );