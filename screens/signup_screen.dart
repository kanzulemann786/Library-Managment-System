import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isVisible = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  void _signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();
    final username = usernameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        username.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // Save additional info in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'email': email,
          'phone': phone,
          'username': username,
          'uid': user.uid,
        });

        // Navigate to Home Screen with username
        Get.offAll(() => Homescreen(username: username));

        Get.snackbar('Success', 'Signup Completed');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Signup Error', e.message ?? 'Unknown error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        title: Text(
          'Sign Up',
          style: GoogleFonts.actor(color: Colors.lightBlue, letterSpacing: 1.5),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                'lottie/Animation - 1748015647423.json',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              _buildTextField(usernameController, 'Username'),
              const SizedBox(height: 15),
              _buildTextField(emailController, 'Email'),
              const SizedBox(height: 15),
              _buildTextField(phoneController, 'Phone Number'),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: !isVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: isVisible ? Colors.lightBlue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account? Login',
                  style: GoogleFonts.poppins(color: Colors.lightBlue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
