import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: GallaeMallaeApp()));
}

class GallaeMallaeApp extends StatelessWidget {
  const GallaeMallaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '갈래말래',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('갈래말래'))),
    );
  }
}
