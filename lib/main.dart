import 'package:android_dev/core/auth/auth_service.dart';
import 'package:android_dev/screens/auth/auth_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'screens/main_screen.dart';

void main() => runApp(const ProviderScope(child: MainApp()));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      );
}

/// Shows the app for a logged-in user and the login screen otherwise.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return user.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('Could not load session: $error'))),
      data: (user) => user == null ? const AuthScreen() : const MainScreen(),
    );
  }
}
