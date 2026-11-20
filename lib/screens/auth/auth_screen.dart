import 'package:android_dev/core/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Login and registration in one screen. On success the session is saved and
/// the auth gate in main.dart swaps this screen for the app.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _isRegister = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = ref.read(authServiceProvider);
    try {
      if (_isRegister) {
        await auth.register(
          username: _username.text,
          email: _email.text,
          password: _password.text,
        );
      } else {
        await auth.login(email: _email.text, password: _password.text);
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toggleMode() => setState(() {
        _isRegister = !_isRegister;
        _error = null;
        _formKey.currentState?.reset();
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Instagram',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRegister ? 'Create your account' : 'Log in to continue',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (_isRegister) ...[
                        TextFormField(
                          key: const Key('username'),
                          controller: _username,
                          decoration: const InputDecoration(labelText: 'Username'),
                          validator: (v) => (v?.trim().length ?? 0) < 3 ? 'At least 3 characters.' : null,
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextFormField(
                        key: const Key('email'),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v?.trim() ?? '')
                            ? null
                            : 'Enter a valid email.',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('password'),
                        controller: _password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v?.length ?? 0) < 6 ? 'At least 6 characters.' : null,
                      ),
                      if (_isRegister) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          key: const Key('confirm'),
                          controller: _confirm,
                          obscureText: _obscure,
                          decoration: const InputDecoration(labelText: 'Confirm password'),
                          validator: (v) => v == _password.text ? null : 'Passwords do not match.',
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        child: Text(_busy ? 'Please wait…' : (_isRegister ? 'Sign up' : 'Log in')),
                      ),
                      TextButton(
                        onPressed: _busy ? null : _toggleMode,
                        child: Text(_isRegister
                            ? 'Already have an account? Log in'
                            : "Don't have an account? Sign up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
