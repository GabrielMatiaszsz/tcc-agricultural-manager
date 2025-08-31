import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_client.dart';
import '../../data/models/machine.dart'; // usa MachineType e MachineStatus

class MachineFormScreen extends StatefulWidget {
  const MachineFormScreen({super.key});

  @override
  State<MachineFormScreen> createState() => _MachineFormScreenState();
}

class _MachineFormScreenState extends State<MachineFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _apelido = TextEditingController();
  final _modelo = TextEditingController();
  final _ano = TextEditingController();
  final _local = TextEditingController();
  final _horas = TextEditingController();
  final _custoHora = TextEditingController();
  final _ultimaMan = TextEditingController();
  final _proximaMan = TextEditingController();

  MachineType _type = MachineType.trator;
  MachineStatus _status = MachineStatus.ativo;

  @override
  void dispose() {
    _apelido.dispose();
    _modelo.dispose();
    _ano.dispose();
    _local.dispose();
    _horas.dispose();
    _custoHora.dispose();
    _ultimaMan.dispose();
    _proximaMan.dispose();
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

    // IMPORTANTE: a API espera "type" (EN), não "tipo".
    final body = {
      'apelido': _apelido.text.trim(),
      'modelo': _modelo.text.trim(),
      'ano': int.tryParse(_ano.text) ?? 0,
      'type': _type.name, // <-- ajustado (antes era "tipo")
      'status': _status.name, // mantém "status" como já estava
      'local': _local.text.trim(),
      'horas': double.tryParse(_horas.text.replaceAll(',', '.')) ?? 0.0,
      'custo_hora':
          double.tryParse(_custoHora.text.replaceAll(',', '.')) ?? 0.0,
      'ultima_manutencao': _ultimaMan.text.trim().isEmpty
          ? null
          : _ultimaMan.text.trim(),
      'proxima_manutencao': _proximaMan.text.trim().isEmpty
          ? null
          : _proximaMan.text.trim(),
    };

    try {
      await api.post('/api/machines', body: body);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maquinário cadastrado!')));
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
          'Novo Maquinário',
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
                            width: twoCols ? 300 : double.infinity,
                            child: TextFormField(
                              controller: _apelido,
                              decoration: _dec('Apelido'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Informe o apelido'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 300 : double.infinity,
                            child: TextFormField(
                              controller: _modelo,
                              decoration: _dec('Modelo'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Informe o modelo'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 140 : double.infinity,
                            child: TextFormField(
                              controller: _ano,
                              keyboardType: TextInputType.number,
                              decoration: _dec('Ano', hint: 'Ex.: 2022'),
                              validator: (v) => (int.tryParse(v ?? '') == null)
                                  ? 'Ano inválido'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: DropdownButtonFormField<MachineType>(
                              value: _type,
                              decoration: _dec('Tipo'),
                              items: const [
                                DropdownMenuItem(
                                  value: MachineType.trator,
                                  child: Text('Trator'),
                                ),
                                DropdownMenuItem(
                                  value: MachineType.colheitadeira,
                                  child: Text('Colheitadeira'),
                                ),
                                DropdownMenuItem(
                                  value: MachineType.pulverizador,
                                  child: Text('Pulverizador'),
                                ),
                                DropdownMenuItem(
                                  value: MachineType.semeadora,
                                  child: Text('Semeadora'),
                                ),
                                DropdownMenuItem(
                                  value: MachineType.caminhao,
                                  child: Text('Caminhão'),
                                ),
                                DropdownMenuItem(
                                  value: MachineType.retroescavadeira,
                                  child: Text('Retroescavadeira'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _type = v ?? MachineType.trator,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: DropdownButtonFormField<MachineStatus>(
                              value: _status,
                              decoration: _dec('Status'),
                              items: const [
                                DropdownMenuItem(
                                  value: MachineStatus.ativo,
                                  child: Text('Ativo'),
                                ),
                                DropdownMenuItem(
                                  value: MachineStatus.manutencao,
                                  child: Text('Manutenção'),
                                ),
                                DropdownMenuItem(
                                  value: MachineStatus.inativo,
                                  child: Text('Inativo'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _status = v ?? MachineStatus.ativo,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 300 : double.infinity,
                            child: TextFormField(
                              controller: _local,
                              decoration: _dec('Local'),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 180 : double.infinity,
                            child: TextFormField(
                              controller: _horas,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _dec('Horas', hint: 'Ex.: 1350,5'),
                              validator: (v) =>
                                  (double.tryParse(
                                        (v ?? '').replaceAll(',', '.'),
                                      ) ==
                                      null)
                                  ? 'Valor inválido'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 180 : double.infinity,
                            child: TextFormField(
                              controller: _custoHora,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _dec(
                                'Custo/h (R\$)',
                                hint: 'Ex.: 120,00',
                              ),
                              validator: (v) =>
                                  (double.tryParse(
                                        (v ?? '').replaceAll(',', '.'),
                                      ) ==
                                      null)
                                  ? 'Valor inválido'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _ultimaMan,
                              decoration: _dec(
                                'Última manutenção (texto opcional)',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _proximaMan,
                              decoration: _dec(
                                'Próxima manutenção (texto opcional)',
                              ),
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
