import 'package:flutter/material.dart';

class InsumosScreen extends StatelessWidget {
  const InsumosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insumos')),
      body: const Center(
        child: Text('Cadastro de Insumos'),
      ),
    );
  }
}

