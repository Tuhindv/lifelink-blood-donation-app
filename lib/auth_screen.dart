
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isLogin) {
        // Login existing user
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // Create a new account
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin
                ? 'Login successful!'
                : 'Account created successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Do not use Navigator.pop(context).
      // AuthGate listens to authStateChanges()
      // and automatically displays HomeScreen.

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message = 'Password must be at least 6 characters.';
          break;

        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Email or password is incorrect.';
          break;

        case 'network-request-failed':
          message = 'Check your internet connection.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        case 'operation-not-allowed':
          message =
              'Email/Password sign-in is disabled in Firebase Console.';
          break;

        default:
          message = e.message ?? 'Authentication failed. Try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );

    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeLink Account'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.bloodtype,
                  color: Colors.red,
                  size: 80,
                ),

                const SizedBox(height: 16),

                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }

                    if (!_isLogin && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Login / Create Account button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isLogin ? 'Login' : 'Create Account',
                        ),
                ),

                const SizedBox(height: 12),

                // Switch between Login and Registration
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _formKey.currentState?.reset();
                          });
                        },
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Create Account"
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
