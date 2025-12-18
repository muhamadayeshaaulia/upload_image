import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  final supabase = Supabase.instance.client;
  final picker = ImagePicker();

  List<String> files = [];

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final res = await supabase.storage.from('images').list(path: uid);
    setState(() {
      files = res.map((e) => e.name).toList();
    });
  }

  Future<void> uploadImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('images')
        .upload('$uid/$fileName', file);

    loadImages();
  }

  Future<void> deleteImage(String name) async {
    await supabase.storage.from('images').remove(['$uid/$name']);
    loadImages();
  }

  String getUrl(String name) {
    return supabase.storage.from('images').getPublicUrl('$uid/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadImage,
        child: const Icon(Icons.add),
      ),
      body: files.isEmpty
          ? const Center(child: Text('Belum ada foto'))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: files.length,
              itemBuilder: (context, i) {
                final name = files[i];
                return Stack(
                  children: [
                    Image.network(getUrl(name), fit: BoxFit.cover),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteImage(name),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
