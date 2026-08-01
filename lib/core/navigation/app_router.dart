import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Global navigator keys for routing hierarchy
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorPlayKey = GlobalKey<NavigatorState>(debugLabel: 'shellPlay');
final GlobalKey<NavigatorState> _shellNavigatorStatsKey = GlobalKey<NavigatorState>(debugLabel: 'shellStats');
final GlobalKey<NavigatorState> _shellNavigatorArchiveKey = GlobalKey<NavigatorState>(debugLabel: 'shellArchive');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ---------------------------------------------------------
    // TAB SHELL ROUTE (Persistent Bottom Navigation)
    // ---------------------------------------------------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // TEMPORARY: A basic Scaffold to hold the bottom nav until we build AppShell in Phase 2
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(
              index,
              // Supports tapping an active tab to pop back to its initial route
              initialLocation: index == navigationShell.currentIndex,
            ),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Play'),
              BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Stats'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Archive'),
            ],
          ),
        );
      },
      branches: [
        // Branch 1: Play (Main Menu)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorPlayKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Main Menu Screen - Phase 3')),
              ),
            ),
          ],
        ),
        // Branch 2: Statistics
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStatsKey,
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Statistics Screen - Phase 3')),
              ),
            ),
          ],
        ),
        // Branch 3: Archive
        StatefulShellBranch(
          navigatorKey: _shellNavigatorArchiveKey,
          routes: [
            GoRoute(
              path: '/archive',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Archive Screen - Phase 3')),
              ),
            ),
          ],
        ),
      ],
    ),
    
    // ---------------------------------------------------------
    // FULL SCREEN ROUTES (Hidden Bottom Navigation)
    // ---------------------------------------------------------
    GoRoute(
      path: '/game',
      // Pushes over the root navigator, hiding the bottom tab bar
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Game Board Screen - Phase 3')),
      ),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Settings Screen - Phase 3')),
      ),
    ),
  ],
);