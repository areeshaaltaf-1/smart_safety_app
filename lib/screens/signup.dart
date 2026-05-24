import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String? emailError;
  String? passwordError;

  // EMAIL VALIDATION
  String? validateEmail(String email) {

    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@(gmail|yahoo|outlook)\.com$',
    );

    if (email.isEmpty) {
      return "Email cannot be empty";
    }

    if (!regex.hasMatch(email)) {
      return "Enter valid email (.com required)";
    }

    return null;
  }

  // PASSWORD VALIDATION
  String? validatePassword(String password) {

    final hasUppercase =
    password.contains(RegExp(r'[A-Z]'));

    final hasNumber =
    password.contains(RegExp(r'[0-9]'));

    final hasSpecial =
    password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (password.isEmpty) {
      return "Password cannot be empty";
    }

    if (password.length < 8) {
      return "Minimum 8 characters";
    }

    if (!hasUppercase) {
      return "Add 1 uppercase letter";
    }

    if (!hasNumber) {
      return "Add 1 number";
    }

    if (!hasSpecial) {
      return "Add 1 special character";
    }

    return null;
  }

  // SIGNUP FUNCTION
  void signupUser() async {

    setState(() {
      emailError =
          validateEmail(emailController.text);

      passwordError =
          validatePassword(passwordController.text);
    });

    if (emailError != null ||
        passwordError != null) {
      return;
    }

    try {

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created"),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Signup Failed"),
        ),
      );

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
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            child: Column(

              children: [

                const Icon(
                  Icons.person_add,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // EMAIL FIELD
                TextField(
                  controller: emailController,

                  onChanged: (_) {

                    setState(() {

                      emailError =
                          validateEmail(
                              emailController.text);

                    });

                  },

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Email",
                    errorText: emailError,

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PASSWORD FIELD
                TextField(
                  controller: passwordController,

                  obscureText: obscurePassword,

                  onChanged: (_) {

                    setState(() {

                      passwordError =
                          validatePassword(
                              passwordController.text);

                    });

                  },

                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,

                    labelText: "Password",

                    helperText:
                    "Use uppercase, number & special character",

                    errorText: passwordError,

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),

                      onPressed: () {

                        setState(() {

                          obscurePassword =
                          !obscurePassword;

                        });

                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: signupUser,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),

                    child: const Text(
                      "Sign Up",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LOGIN OPTION
                TextButton(

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const LoginScreen(),
                      ),
                    );

                  },

                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
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