



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/Screens/notes_screen.dart';

void main(){
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        primaryColor: const Color(0xFF64B5F6),
        colorScheme: const ColorScheme.dark().copyWith(
          secondary: const Color(0xFF64B5F6),
        ),
      ),
      home: const NotesScreen(),
    );
  }
}
