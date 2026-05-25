import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dashboard.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  String? emailError;
  String? passwordError;

  // 🔥 STRICT EMAIL VALIDATION
  String? validateEmail(String email) {

    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    );

    if (email.isEmpty) {
      return "Email cannot be empty";
    }

    if (!regex.hasMatch(email)) {
      return "Enter a valid email (example: name@gmail.com)";
    }

    // ❌ extra safety checks (block fake formats)
    if (email.contains('..') ||
        email.startsWith('.') ||
        email.endsWith('.') ||
        email.contains('@.') ||
        email.contains('.@')) {
      return "Invalid email format";
    }

    return null;
  }

  // 🔥 PASSWORD VALIDATION (your rules)
  String? validatePassword(String password) {

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (password.isEmpty) {
      return "Password cannot be empty";
    }

    if (password.length < 5) {
      return "Minimum 5 characters required";
    }

    if (!hasUppercase) {
      return "At least 1 uppercase letter required";
    }

    if (!hasSpecial) {
      return "At least 1 special character required";
    }

    return null;
  }

  // 🚀 SIGNUP FUNCTION
  void signupUser() async {

    setState(() {
      emailError = validateEmail(emailController.text.trim());
      passwordError = validatePassword(passwordController.text);
    });

    if (emailError != null || passwordError != null) {
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );

    } on FirebaseAuthException catch (e) {

      String message = "Signup failed";

      if (e.code == 'email-already-in-use') {
        message = "Account already exists";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      } else if (e.code == 'weak-password') {
        message = "Password too weak";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF0F766E),
            ],
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const Icon(Icons.person_add,
                    size: 75, color: Colors.white),

                const SizedBox(height: 10),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                // EMAIL FIELD
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      emailError = validateEmail(value.trim());
                    });
                  },

                  style: const TextStyle(color: Colors.black),

                  decoration: InputDecoration(
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    errorText: emailError,
                    helperText: "Example: name@gmail.com",

                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // PASSWORD FIELD
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  onChanged: (value) {
                    setState(() {
                      passwordError = validatePassword(value);
                    });
                  },

                  style: const TextStyle(color: Colors.black),

                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,

                    errorText: passwordError,
                    helperText:
                    "Min 5 chars, 1 uppercase, 1 special character",

                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signupUser,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Sign Up"),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white),
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