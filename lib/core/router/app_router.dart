import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/portfolio/presentation/pages/portfolio_page.dart';
import '../../features/portfolio/presentation/pages/project_detail_page.dart';

import '../../features/admin/presentation/pages/admin_login_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/resume/presentation/pages/resume_page.dart';
import '../../features/admin/presentation/pages/admin_page.dart';
import '../../features/career/presentation/pages/career_description_page.dart';
import '../../features/cover_letter/presentation/pages/cover_letter_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Public Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const HomePage(initialSection: 'contact'),
      ),
      GoRoute(
        path: '/portfolio',
        name: 'portfolio',
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          return PortfolioPage(initialTab: tab);
        },
        routes: [
          GoRoute(
            path: ':projectId',
            name: 'project-detail',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return ProjectDetailPage(projectId: projectId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/documents',
        name: 'documents',
        builder: (context, state) => const DocumentsPage(),
      ),
      GoRoute(
        path: '/resume',
        name: 'resume',
        builder: (context, state) => const ResumePage(),
      ),
      GoRoute(
        path: '/career-description',
        name: 'career-description',
        builder: (context, state) => const CareerDescriptionPage(),
      ),
      GoRoute(
        path: '/cover-letter',
        name: 'cover-letter',
        builder: (context, state) => const CoverLetterPage(),
      ),

      // Admin Routes
      // Admin Routes
      GoRoute(
        path: '/admin/login',
        name: 'admin-login',
        builder: (context, state) => const AdminLoginPage(),
      ),
      GoRoute(path: '/admin', redirect: (context, state) => '/admin/login'),
      GoRoute(
        path: '/admin/dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
