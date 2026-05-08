import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/generate/presentation/generate_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/admin/presentation/dashboard_screen.dart';
import '../../features/admin/presentation/user_management_screen.dart';
import '../../shared/layout/app_scaffold.dart';

// ── Nav index helper: map route path → bottom/sidebar index ──────────────────
const memberRoutes = ['/generate', '/history', '/profile'];
const adminRoutes  = ['/admin', '/admin/users'];

// ── Router ───────────────────────────────────────────────────────────────────
final appRouter = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,

  // TODO: thêm redirect kiểm tra auth token khi tích hợp API thật
  // redirect: (context, state) { ... },

  routes: [
    // ── Public routes ────────────────────────────────────────────────────────
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (ctx, state) => _fade(state, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (ctx, state) => _fade(state, const RegisterScreen()),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgotPassword',
      pageBuilder: (ctx, state) => _fade(state, const ForgotPasswordScreen()),
    ),

    // ── Member shell (sidebar / bottom nav) ──────────────────────────────────
    ShellRoute(
      builder: (ctx, state, child) {
        final idx = memberRoutes.indexOf(state.matchedLocation);
        return AppScaffold(
          selectedIndex: idx < 0 ? 0 : idx,
          isAdmin: false,
          onNavTap: (i) => ctx.go(memberRoutes[i]),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/generate',
          name: 'generate',
          builder: (ctx, state) => const GenerateScreen(),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (ctx, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (ctx, state) => const ProfileScreen(),
        ),
      ],
    ),

    // ── Admin shell ──────────────────────────────────────────────────────────
    ShellRoute(
      builder: (ctx, state, child) {
        final idx = adminRoutes.indexOf(state.matchedLocation);
        return AppScaffold(
          selectedIndex: idx < 0 ? 0 : idx,
          isAdmin: true,
          onNavTap: (i) => ctx.go(adminRoutes[i]),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/admin',
          name: 'adminDashboard',
          builder: (ctx, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          name: 'adminUsers',
          builder: (ctx, state) => const UserManagementScreen(),
        ),
      ],
    ),
  ],

  // ── Error page ───────────────────────────────────────────────────────────
  errorBuilder: (ctx, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
          const SizedBox(height: 12),
          Text('Không tìm thấy trang',
              style: Theme.of(ctx).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(state.error?.message ?? '',
              style: Theme.of(ctx).textTheme.bodyMedium),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => ctx.go('/login'),
            child: const Text('Về trang đăng nhập'),
          ),
        ],
      ),
    ),
  ),
);

/// Fade transition — nhẹ hơn slide, phù hợp với dev tool
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 160),
      transitionsBuilder: (_, animation, __, c) =>
          FadeTransition(opacity: animation, child: c),
    );