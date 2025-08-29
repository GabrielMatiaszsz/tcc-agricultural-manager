import 'package:flutter/material.dart';

class MaquinariosScreen extends StatelessWidget {
  const MaquinariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maquinários')),
      body: const Center(
        child: Text('Cadastro de Maquinários Agrícolas'),
      ),
    );
  }
}

