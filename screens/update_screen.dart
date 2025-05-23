import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class UpdateScreen extends StatefulWidget {
  final String? bookname, authorName, price, edition, imageUrl, docid;

  const UpdateScreen({
    required this.bookname,
    required this.authorName,
    required this.price,
    required this.edition,
    required this.imageUrl,
    required this.docid,
    super.key,
    required String username,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController bookNameController;
  late TextEditingController authorNameController;
  late TextEditingController bookPriceController;
  late TextEditingController bookEditionController;
  late TextEditingController imageUrlController;
  String? username;

  @override
  void initState() {
    super.initState();
    bookNameController = TextEditingController(text: widget.bookname);
    authorNameController = TextEditingController(text: widget.authorName);
    bookPriceController = TextEditingController(text: widget.price);
    bookEditionController = TextEditingController(text: widget.edition);
    imageUrlController = TextEditingController(text: widget.imageUrl);
    username = username; // Or assign a value if you have it available
  }

  void updateData() async {
    await FirebaseFirestore.instance
        .collection("Books")
        .doc(widget.docid)
        .update({
          'Book Name': bookNameController.text.trim(),
          'Author Name': authorNameController.text.trim(),
          'Book Price': bookPriceController.text.trim(),
          'Book Edition': bookEditionController.text.trim(),
          'Image URL': imageUrlController.text.trim(),
        });

    Get.snackbar('Success', 'Book Updated Successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Homescreen(username: username ?? '')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        title: Text(
          'Update Book',
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.lightBlue,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Lottie.asset(
              'lottie/Animation - 1748020844135.json',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            buildField('Book Name', bookNameController),
            buildField('Author Name', authorNameController),
            buildField('Book Price', bookPriceController),
            buildField('Book Edition', bookEditionController),
            buildField('Image URL', imageUrlController),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: updateData,
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
                'Update Book',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
