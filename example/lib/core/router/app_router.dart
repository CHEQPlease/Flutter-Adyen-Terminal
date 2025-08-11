import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';
import '../../screens/payment_screen.dart';
import '../../screens/configuration_screen.dart';
import '../../screens/utilities_screen.dart';
import '../../screens/history_screen.dart';
import '../../screens/main_scaffold.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/payment',
            name: 'payment',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PaymentScreen(),
            ),
          ),
          GoRoute(
            path: '/configuration',
            name: 'configuration',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ConfigurationScreen(),
            ),
          ),
          GoRoute(
            path: '/utilities',
            name: 'utilities',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UtilitiesScreen(),
            ),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
