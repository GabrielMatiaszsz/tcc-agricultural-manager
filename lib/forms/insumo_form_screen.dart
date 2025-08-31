import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_client.dart';
import '../../data/models/insumo.dart'; // usa InsumoTipo e InsumoStatus

class InsumoFormScreen extends StatefulWidget {
  const InsumoFormScreen({super.key});

  @override
  State<InsumoFormScreen> createState() => _InsumoFormScreenState();
}

class _InsumoFormScreenState extends State<InsumoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nome = TextEditingController();
  final _unidade = TextEditingController(text: 'kg');
  final _quantidade = TextEditingController();
  final _minimo = TextEditingController();
  final _custoUnit = TextEditingController();
  final _fornecedor = TextEditingController();
  final _local = TextEditingController();
  final _validade = TextEditingController(); // texto livre (ex.: 12/2025)
  final _lote = TextEditingController();
  final _ultimoMov = TextEditingController();

  InsumoTipo _tipo = InsumoTipo.semente;
  InsumoStatus _status = InsumoStatus.disponivel;

  @override
  void dispose() {
    _nome.dispose();
    _unidade.dispose();
    _quantidade.dispose();
    _minimo.dispose();
    _custoUnit.dispose();
    _fornecedor.dispose();
    _local.dispose();
    _validade.dispose();
    _lote.dispose();
    _ultimoMov.dispose();
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
      'nome': _nome.text.trim(),
      'tipo': _tipo.name, // semente, fertilizante, ...
      'status': _status.name, // disponivel, baixo, vencido
      'unidade': _unidade.text.trim(),
      'quantidade':
          double.tryParse(_quantidade.text.replaceAll(',', '.')) ?? 0.0,
      'minimo': double.tryParse(_minimo.text.replaceAll(',', '.')) ?? 0.0,
      'custo_unit':
          double.tryParse(_custoUnit.text.replaceAll(',', '.')) ?? 0.0,
      'fornecedor': _fornecedor.text.trim(),
      'local': _local.text.trim(),
      'validade': _validade.text.trim().isEmpty ? null : _validade.text.trim(),
      'lote': _lote.text.trim().isEmpty ? null : _lote.text.trim(),
      'ultimo_mov': _ultimoMov.text.trim().isEmpty
          ? null
          : _ultimoMov.text.trim(),
    };

    try {
      await api.post('/api/insumos', body: body);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insumo cadastrado!')));
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
          'Novo Insumo',
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
                              controller: _nome,
                              decoration: _dec('Nome do insumo'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Informe o nome'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: DropdownButtonFormField<InsumoTipo>(
                              value: _tipo,
                              decoration: _dec('Tipo'),
                              items: const [
                                DropdownMenuItem(
                                  value: InsumoTipo.semente,
                                  child: Text('Semente'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.fertilizante,
                                  child: Text('Fertilizante'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.herbicida,
                                  child: Text('Herbicida'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.fungicida,
                                  child: Text('Fungicida'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.inseticida,
                                  child: Text('Inseticida'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.diesel,
                                  child: Text('Diesel'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.aduboFoliar,
                                  child: Text('Adubo foliar'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoTipo.corretivo,
                                  child: Text('Corretivo'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _tipo = v ?? InsumoTipo.semente,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: DropdownButtonFormField<InsumoStatus>(
                              value: _status,
                              decoration: _dec('Status'),
                              items: const [
                                DropdownMenuItem(
                                  value: InsumoStatus.disponivel,
                                  child: Text('Disponível'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoStatus.baixo,
                                  child: Text('Estoque baixo'),
                                ),
                                DropdownMenuItem(
                                  value: InsumoStatus.vencido,
                                  child: Text('Vencido'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _status = v ?? InsumoStatus.disponivel,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 160 : double.infinity,
                            child: TextFormField(
                              controller: _unidade,
                              decoration: _dec('Unidade', hint: 'kg, L, un…'),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 160 : double.infinity,
                            child: TextFormField(
                              controller: _quantidade,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _dec(
                                'Quantidade',
                                hint: 'Ex.: 250,0',
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
                            width: twoCols ? 160 : double.infinity,
                            child: TextFormField(
                              controller: _minimo,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _dec('Mínimo', hint: 'Ex.: 50,0'),
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
                            width: twoCols ? 200 : double.infinity,
                            child: TextFormField(
                              controller: _custoUnit,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _dec(
                                'Custo/un (R\$)',
                                hint: 'Ex.: 12,50',
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
                            width: twoCols ? 300 : double.infinity,
                            child: TextFormField(
                              controller: _fornecedor,
                              decoration: _dec('Fornecedor'),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _local,
                              decoration: _dec(
                                'Local (almoxarifado, fazenda…)',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _validade,
                              decoration: _dec(
                                'Validade (texto opcional)',
                                hint: 'mm/aaaa',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _lote,
                              decoration: _dec('Lote (opcional)'),
                            ),
                          ),
                          SizedBox(
                            width: twoCols ? 220 : double.infinity,
                            child: TextFormField(
                              controller: _ultimoMov,
                              decoration: _dec('Último movimento (opcional)'),
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
