import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  void loginUser() async {
    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );

    } on FirebaseAuthException catch (e) {

      String message;

      // ✅ EMAIL DOES NOT EXIST
      if (e.code == 'user-not-found') {
        message = "No account found with this email";

        // ✅ WRONG PASSWORD
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";

        // ✅ INVALID EMAIL FORMAT
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";

        // ✅ TOO MANY ATTEMPTS
      } else if (e.code == 'too-many-requests') {
        message = "Too many attempts. Try again later";

        // ✅ DEFAULT
      } else {
        message = "Login failed. Please try again";
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

                const Icon(Icons.security,
                    size: 75, color: Colors.white),

                const SizedBox(height: 10),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                // EMAIL
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black),

                  decoration: InputDecoration(
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: const TextStyle(color: Colors.black),

                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
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
                    onPressed: isLoading ? null : loginUser,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
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