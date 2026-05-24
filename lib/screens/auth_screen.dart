import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLogin ? const LoginScreen() : const SignupScreen(),
      bottomNavigationBar: TextButton(
        onPressed: () {
          setState(() {
            showLogin = !showLogin;
          });
        },
        child: Text(
          showLogin
              ? "Don't have an account? Sign up"
              : "Already have an account? Login",
        ),
      ),
    );
  }
}