import 'package:flutter/material.dart';

class ColaboradoresScreen extends StatelessWidget {
  const ColaboradoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colaboradores')),
      body: const Center(
        child: Text('Cadastro de Colaboradores'),
      ),
    );
  }
}

