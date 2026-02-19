




import 'package:flutter/material.dart';
import 'package:noteapp/Screens/notes_screen.dart';

import 'package:provider/provider.dart';
import 'package:noteapp/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF64B5F6),
        colorScheme: const ColorScheme.light().copyWith(
            secondary: const Color(0xFF64B5F6),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)
        )
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        primaryColor: const Color(0xFF64B5F6),
        colorScheme: const ColorScheme.dark().copyWith(
          secondary: const Color(0xFF64B5F6),
        ),
         appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
        )
      ),
      home: const NotesScreen(),
    );
  }
}
