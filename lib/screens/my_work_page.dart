
import 'package:flutter/material.dart';

class MyWorkPage extends StatelessWidget {
  const MyWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Work'),
      ),
      body: const Center(
        child: Text('This is the page I am working on!'),
      ),
    );
  }
}
