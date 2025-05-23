import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project1/screens/home_screen.dart';
import 'package:firebase_project1/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username;
  bool isVisible = true;
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  void _login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Fetch username from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser.uid)
            .get();

        final username = userDoc.data()?['username'] ?? 'User';

        // Navigate to home with username
        Get.offAll(() => Homescreen(username: username));
      } else {
        Get.snackbar('Login Failed', 'Incorrect email or password');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'Unknown error');
    }
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Library Login',
          style: GoogleFonts.actor(color: Colors.lightBlue, letterSpacing: 1.5),
        ),
        backgroundColor: Colors.lightBlue.shade50,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Lottie.asset('lottie/Animation - 1747221719906.json', height: 200),
            const SizedBox(height: 20),
            _buildTextField(loginEmailController, 'Email', Icons.email),
            const SizedBox(height: 10),
            _buildTextField(
              loginPasswordController,
              'Password',
              Icons.lock_outline,
              true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(color: Colors.lightBlue),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, [
    bool isPassword = false,
  ]) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.lightBlue),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
