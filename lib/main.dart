import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app_router.dart';
import 'src/theme/app_theme.dart';
import 'src/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/widgets/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - catch error if not configured yet
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('⚠️ Firebase not configured. Please follow FIREBASE_SETUP.md');
    print('Error: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  final themeIndex =
      prefs.getInt('themeMode') ?? -1; // -1 = system, 0=light,1=dark
  // Enable Firestore persistence for offline support (if desired)
  // Note: calling FirebaseFirestore.instance.settings requires cloud_firestore import
  // We'll set persistence inside Firestore repository during its initialization.

  runApp(
    ProviderScope(
      overrides: [
        // provide initial theme preference to the theme provider via overrides
      ],
      child: FBLAApp(initialThemeIndex: themeIndex),
    ),
  );
}

class FBLAApp extends ConsumerWidget {
  final int initialThemeIndex;
  const FBLAApp({super.key, this.initialThemeIndex = -1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize auth listener
    ref.read(authServiceProvider).init();

    // If an initial theme index was provided, set the provider once
    if (initialThemeIndex != -1) {
      final tm = initialThemeIndex == 0
          ? ThemeMode.light
          : initialThemeIndex == 1
          ? ThemeMode.dark
          : ThemeMode.system;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Use notifier method to persist and set theme
        ref.read(themeModeProvider.notifier).setTheme(tm);
      });
    }

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return AuthGate(
      child: MaterialApp.router(
        title: 'FBLA Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}
