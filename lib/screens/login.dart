import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool obscurePassword = true;

  bool isLoading = false;

  // LOGIN FUNCTION
  void loginUser() async {

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Login Successful"),
        ),
      );

      // 🔥 NAVIGATE TO DASHBOARD
      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (context) =>
          const DashboardScreen(),
        ),
      );

    }

    on FirebaseAuthException catch (e) {

      String message = "";

      // NO ACCOUNT
      if (e.code == 'user-not-found') {

        message =
        "No account exists with this email";

      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {

        message =
        "Incorrect password";

      }

      // INVALID EMAIL
      else if (e.code == 'invalid-email') {

        message =
        "Invalid email format";

      }

      else {

        message =
            e.message ?? "Login Failed";

      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(message),
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
            colors: [
              Color(0xFF1E293B),
              Color(0xFF334155),
              Color(0xFF0F766E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            child: Column(

              children: [

                const Icon(
                  Icons.login,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // EMAIL
                TextField(

                  controller: emailController,

                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,

                    labelText: "Email",

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PASSWORD
                TextField(

                  controller: passwordController,

                  obscureText:
                  obscurePassword,

                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,

                    labelText: "Password",

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

                // LOGIN BUTTON
                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed:
                    isLoading ? null : loginUser,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.white,

                      foregroundColor:
                      Colors.black,
                    ),

                    child:
                    isLoading

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