import 'package:flutter/material.dart';
import 'package:tp70/screen/matierescreen.dart';

import 'screen/classscreen.dart';
import 'screen/formationscreen.dart';
import 'screen/login.dart';
import 'screen/studentsscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/students': (context) => const StudentScreen(),
        '/class': (context) => const ClasseScreen(),
        '/formation': (context) => const FormationScreen(),
        '/matiere': (context) => const MatiereScreen()
      },
    );
  }
}