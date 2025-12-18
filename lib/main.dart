import 'package:belajar_upload/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:belajar_upload/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await Supabase.initialize(
    url: 'https://wfboqhhjbufeidkqppxg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmYm9xaGhqYnVmZWlka3FwcHhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYwNDY1MzMsImV4cCI6MjA4MTYyMjUzM30.BN7nBSgrHed7GJ0Yb2Ze8mklTJ4Qo4TihZXTE6smuR0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'belajar upload image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}