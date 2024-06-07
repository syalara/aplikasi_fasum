import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_fasum/screens/sign_in_screen.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Fasum'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada postingan tersedia'));
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Jumlah kolom
              childAspectRatio: 1, // Rasio aspek untuk membuat gambar kotak
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              var data = post.data() as Map<String, dynamic>;
              var postTime = data['timestamp'] as Timestamp;
              var date = postTime.toDate();
              var formattedDate =
                  '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';

              var username =
              data.containsKey('username') ? data['username'] : 'Anonim';
              var imageUrl =
              data.containsKey('image_url') ? data['image_url'] : null;
              var text = data.containsKey('text') ? data['text'] : '';
              var location = data.containsKey('location')
                  ? data['location']
                  : null; // Get location data

              return Card(
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null)
                      Expanded(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Gagal memuat gambar'));
                          },
                        ),
                      )
                    else
                      const Expanded(
                        child: Center(child: Text('Gambar tidak tersedia')),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          if (location != null) // Show location if available
                            Text(
                              'Location: ${location['latitude']}, ${location['longitude']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}