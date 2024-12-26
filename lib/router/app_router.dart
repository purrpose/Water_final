import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/cubit/water_cubit/water_cubit.dart';
import 'package:task_manager/features/pages/auth_page.dart';
import 'package:task_manager/features/pages/calendar_page.dart';
import 'package:task_manager/features/pages/reg_page.dart';
import 'package:task_manager/features/pages/settings_page.dart';
import 'package:task_manager/features/pages/water_page.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AuthPage.path,
    routes: [
      GoRoute(
        path: AuthPage.path,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: RegPage.path,
        builder: (context, state) => const RegPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell, // The IndexedStack containing the pages
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.water),
                  label: 'Water',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WaterPage.path,
                builder: (context, state) => const WaterPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CalendarPage.path,
                builder: (context, state) => const CalendarPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SettingsPage.path,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    // Add a listener to trigger data reloading on navigation
    redirect: (context, state) {
      if (state.uri.toString() == WaterPage.path ||
          state.uri.toString() == SettingsPage.path) {
        context.read<WaterCubit>().loadDrinksAndDailys();
      }
      return null; // No redirection needed
    },
  );
}
