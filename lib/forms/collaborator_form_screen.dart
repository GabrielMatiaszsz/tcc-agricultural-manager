import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_client.dart';
import '../../data/models/employee.dart'; // usa EmpStatus do seu modelo (se preferir, pode declarar o enum aqui)

// Formulário de cadastro de colaborador
class CollaboratorFormScreen extends StatefulWidget {
  const CollaboratorFormScreen({super.key});

  @override
  State<CollaboratorFormScreen> createState() => _CollaboratorFormScreenState();
}

class _CollaboratorFormScreenState extends State<CollaboratorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _role = TextEditingController();
  final _salary = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _joinedText = TextEditingController(text: 'Admitido em 01/09/2025');

  EmpStatus _status = EmpStatus.ativo;

  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    _salary.dispose();
    _email.dispose();
    _phone.dispose();
    _joinedText.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF2FA34A), width: 1.4),
    ),
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final api = context.read<ApiClient>();
    final body = {
      'name': _name.text.trim(),
      'role': _role.text.trim(),
      'salary': double.tryParse(_salary.text.replaceAll(',', '.')) ?? 0.0,
      'email': _email.text.trim(),
      'phone': _phone.text.trim(),
      'status': switch (_status) {
        EmpStatus.ativo => 'ativo',
        EmpStatus.inativo => 'inativo',
        EmpStatus.convidado => 'convidado',
      },
      'joined_text': _joinedText.text.trim(),
    };

    try {
      await api.post('/api/collaborators', body: body);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Colaborador cadastrado!')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final twoCols = width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Novo Colaborador',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: twoCols ? 440 : double.infinity,
                            child: TextFormField(
                              controller: _name,
                              decoration: _dec('Nome'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Informe o nome'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 440 : double.infinity,
                            child: TextFormField(
                              controller: _role,
                              decoration: _dec('Função/Cargo'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Informe a função'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _salary,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _dec(
                                'Salário (R\$)',
                                hint: 'Ex.: 5500,00',
                              ),
                              validator: (v) =>
                                  (double.tryParse(v!.replaceAll(',', '.')) ==
                                      null)
                                  ? 'Valor inválido'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: DropdownButtonFormField<EmpStatus>(
                              value: _status,
                              decoration: _dec('Status'),
                              items: const [
                                DropdownMenuItem(
                                  value: EmpStatus.ativo,
                                  child: Text('Ativo'),
                                ),
                                DropdownMenuItem(
                                  value: EmpStatus.inativo,
                                  child: Text('Inativo'),
                                ),
                                DropdownMenuItem(
                                  value: EmpStatus.convidado,
                                  child: Text('Convidado'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _status = v ?? EmpStatus.ativo,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 440 : double.infinity,
                            child: TextFormField(
                              controller: _email,
                              decoration: _dec('Email'),
                              validator: (v) => (v == null || !v.contains('@'))
                                  ? 'Email inválido'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 440 : double.infinity,
                            child: TextFormField(
                              controller: _phone,
                              decoration: _dec('Telefone'),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 440 : double.infinity,
                            child: TextFormField(
                              controller: _joinedText,
                              decoration: _dec('Texto de admissão'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _save,
                            icon: const Icon(Icons.check),
                            label: const Text('Salvar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2FA34A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
