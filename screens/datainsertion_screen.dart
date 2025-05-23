import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DataInsertionScreen extends StatefulWidget {
  const DataInsertionScreen({super.key});

  @override
  State<DataInsertionScreen> createState() => _DataInsertionScreenState();
}

class _DataInsertionScreenState extends State<DataInsertionScreen> {
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController authorNameController = TextEditingController();
  final TextEditingController bookPriceController = TextEditingController();
  final TextEditingController bookEditionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  void insertData() async {
    if (bookNameController.text.isEmpty ||
        authorNameController.text.isEmpty ||
        bookPriceController.text.isEmpty ||
        bookEditionController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    await FirebaseFirestore.instance.collection("Books").add({
      'Book Name': bookNameController.text.trim(),
      'Author Name': authorNameController.text.trim(),
      'Book Price': bookPriceController.text.trim(),
      'Book Edition': bookEditionController.text.trim(),
      'Image URL': imageUrlController.text.trim(),
    });

    Get.snackbar('Success', 'Book Added Successfully');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        title: Text(
          'Add New Book',
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.lightBlue,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
        child: Column(
          children: [
            Lottie.asset(
              'lottie/Animation - 1748018605560.json',
              height: 250,
              width: 250,
            ),
            buildField('Book Name', bookNameController),
            buildField('Author Name', authorNameController),
            buildField('Book Price', bookPriceController),
            buildField('Book Edition', bookEditionController),
            buildField('Image URL', imageUrlController),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: insertData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Insert Book',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
