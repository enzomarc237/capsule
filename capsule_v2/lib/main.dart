import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/screens/welcome_screen.dart';
import 'ui/screens/project_setup_screen.dart';
import 'ui/screens/workspace_screen.dart';
import 'ui/screens/build_progress_screen.dart';
import 'ui/screens/success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize window manager for desktop
  await _initializeWindowManager();
  
  runApp(
    const ProviderScope(
      child: CapsuleApp(),
    ),
  );
}

Future<void> _initializeWindowManager() async {
  // Window manager initialization will be implemented
  // in platform-specific code
  debugPrint('Capsule 2.0 starting...');
}

class CapsuleApp extends StatelessWidget {
  const CapsuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capsule 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/project-setup': (context) => const ProjectSetupScreen(),
        '/workspace': (context) => const WorkspaceScreen(),
        '/build-progress': (context) => const BuildProgressScreen(),
        '/success': (context) => const SuccessScreen(),
      },
    );
  }
}
