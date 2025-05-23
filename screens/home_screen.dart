// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Homescreen extends StatelessWidget {
//   const Homescreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue[50],
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue,
//         title: Text(
//           'Library Home',
//           style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('Books').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var docs = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               var data = docs[index];
//               return Card(
//                 margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Image.network(
//                     data['Image Url'] ?? '',
//                     width: 60,
//                     errorBuilder: (_, __, ___) =>
//                         Icon(Icons.image_not_supported),
//                   ),
//                   title: Text(data['Book Name'], style: GoogleFonts.poppins()),
//                   subtitle: Text(
//                     'Author: ${data['Author Name']}\nPrice: ${data['Book Price']} | Edition: ${data['Book Edition']}',
//                     style: GoogleFonts.poppins(fontSize: 13),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project1/screens/datainsertion_screen.dart';
import 'package:firebase_project1/screens/login_screen.dart';
import 'package:firebase_project1/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Homescreen extends StatelessWidget {
  final String username;
  const Homescreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      drawer: Drawer(
        backgroundColor: Colors.lightBlue[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 110, 204, 248),
              ),
              child: Text.rich(
                TextSpan(
                  text: 'Welcome Dear,\n',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: GoogleFonts.aBeeZee(
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homescreen(username: username),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Get.snackbar(
                  'About Us',
                  'This is a library management system.\nYou can add, update, and delete books easily.\nDeveloped by: KANZ UL EMAN \nVersion: 1.0',
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.lightBlue[50],
                  colorText: Colors.black,

                  icon: const Icon(Icons.info, color: Colors.blue),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: () {
                Get.snackbar(
                  'Contact Us',
                  'For any queries, please contact us at:\nEmail: kanzulemann786@gmail.com',
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.lightBlue[50],
                  colorText: Colors.black,
                  icon: const Icon(Icons.contact_mail, color: Colors.blue),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Library Management System',
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.lightBlue,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[50],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DataInsertionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Lottie.asset(
            'lottie/Animation - 1748017496150 (1).json',
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                SizedBox(width: 50),
                Text(
                  'Manage your library with ease',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.actor(
                    fontSize: 15,
                    letterSpacing: 1.5,
                    color: const Color.fromARGB(255, 37, 14, 22),
                  ),
                ),
                const SizedBox(width: 30),
                Icon(Icons.forward, color: Colors.lightBlue),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Books")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No books found.",
                      style: GoogleFonts.tangerine(fontSize: 50),
                    ),
                  );
                }

                final books = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final data = book.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['Image URL'] ?? '',
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                        title: Text(
                          data['Book Name'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Author: ${data['Author Name'] ?? 'Unknown'}"),
                            Text("Price: ${data['Book Price'] ?? 'N/A'}"),
                            Text("Edition: ${data['Book Edition'] ?? 'N/A'}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.lightBlue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                      bookname: data['Book Name'],
                                      authorName: data['Author Name'],
                                      price: data['Book Price'],
                                      edition: data['Book Edition'],
                                      imageUrl: data['Image URL'],
                                      docid: book.id,
                                    ),
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Books')
                                    .doc(book.id)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
