import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasi_fasum/screens/add_post_screen.dart'; // Import AddPostScreen yang telah dibuat sebelumnya
import 'package:aplikasi_fasum/screens/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}); // Perbaiki penulisan 'key'

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen())); // Pastikan SignInScreen sudah di-import dan ada dalam proyek Anda
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Ubah ke primary color
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( // Tambahkan Floating Action Button
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('You have logged In'),
      ),
    );
  }
}