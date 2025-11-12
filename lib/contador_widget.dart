
import 'package:contador/contador_page.dart';
import 'package:flutter/material.dart';

class ContadorApp extends StatelessWidget
 {
  const ContadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)
      ),
      home: const ContadorHomePage(title: 'Teste contador')
    );
  }
}
