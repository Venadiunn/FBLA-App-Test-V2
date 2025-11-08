// flutter material imported by views
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'views/home/home_view.dart';
import 'views/calendar/calendar_view.dart';
import 'views/resources/resources_view.dart';
import 'views/profile/profile_view.dart';
import 'views/auth/login_view.dart';
import 'views/auth/signup_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'dart:async';

// Helper to convert a Stream to a ChangeNotifier that GoRouter can listen to
class GoRouterRefreshStream extends ChangeNotifier {
  StreamSubscription<dynamic>? _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  const homePath = '/';
  const calendarPath = '/calendar';
  const resourcesPath = '/resources';
  const profilePath = '/profile';

  int locationToIndex(String location) {
    if (location.startsWith(calendarPath)) return 1;
    if (location.startsWith(resourcesPath)) return 2;
    if (location.startsWith(profilePath)) return 3;
    return 0; // default home
  }

  final router = GoRouter(
    initialLocation: homePath,
    refreshListenable: GoRouterRefreshStream(
      fb.FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final user = fb.FirebaseAuth.instance.currentUser;
      final loggingIn =
          state.location == '/login' || state.location == '/signup';
      if (user == null && !loggingIn) return '/login';
      if (user != null && loggingIn) return homePath;
      return null;
    },
    routes: [
      // Auth pages live outside the ShellRoute so the bottom nav is hidden
      GoRoute(path: '/login', builder: (c, s) => const LoginView()),
      GoRoute(path: '/signup', builder: (c, s) => const SignupView()),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          final location = state.location;
          final selected = locationToIndex(location);
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selected,
              onTap: (i) {
                switch (i) {
                  case 0:
                    context.go(homePath);
                    break;
                  case 1:
                    context.go(calendarPath);
                    break;
                  case 2:
                    context.go(resourcesPath);
                    break;
                  case 3:
                    context.go(profilePath);
                    break;
                }
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder),
                  label: 'Resources',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(path: homePath, builder: (c, s) => const HomeView()),
          GoRoute(path: calendarPath, builder: (c, s) => const CalendarView()),
          GoRoute(
            path: resourcesPath,
            builder: (c, s) => const ResourcesView(),
          ),
          GoRoute(path: profilePath, builder: (c, s) => const ProfileView()),
        ],
      ),
    ],
  );

  return router;
});
