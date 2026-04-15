import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.95, // 👈 95% da largura
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.05, // 👈 padding proporcional
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Vamos jagar Jokenpo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}