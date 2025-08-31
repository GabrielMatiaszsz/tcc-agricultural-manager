import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/insumos_notifier.dart';
import '../data/models/insumo.dart';
import '../forms/insumo_form_screen.dart'; // <-- IMPORTA O FORM

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({super.key});

  @override
  State<InsumosScreen> createState() => _InsumosScreenState();
}

class _InsumosScreenState extends State<InsumosScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<InsumosNotifier>();
    final width = MediaQuery.sizeOf(context).width;
    final cross = width >= 1400
        ? 4
        : width >= 1100
        ? 3
        : width >= 700
        ? 2
        : 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: const [
            SizedBox(width: 12),
            Icon(Icons.inventory_2, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              'Insumos',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          _topAction(
            'Recarregar',
            Icons.refresh_rounded,
            () => state.load(page: 1),
          ),
          const SizedBox(width: 8),
          // --------- ABRE O FORM E RECARREGA AO VOLTAR COM SUCESSO ----------
          _topAction('Adicionar', Icons.add, () async {
            final created = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const InsumoFormScreen()),
            );
            if (!mounted) return;
            if (created == true) {
              await context.read<InsumosNotifier>().load(page: 1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Insumo cadastrado!')),
              );
            }
          }),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _FiltersBar(
              controller: _searchCtrl,
              status: state.status,
              tipo: state.tipo,
              onSearch: (txt) {
                state.setQuery(txt);
                state.load(page: 1);
              },
              onPickStatus: (v) {
                state.setStatus(v);
                state.load(page: 1);
              },
              onClearStatus: () {
                state.setStatus(null);
                state.load(page: 1);
              },
              onPickTipo: (v) {
                state.setTipo(v);
                state.load(page: 1);
              },
              onClearTipo: () {
                state.setTipo(null);
                state.load(page: 1);
              },
            ),
          ),
          const SizedBox(height: 8),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            Expanded(
              child: Center(
                child: Text(
                  'Erro: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cross,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                itemCount: state.items.length,
                itemBuilder: (_, i) => _InsumoCard(i: state.items[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _topAction(String label, IconData icon, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: const Color(0xFF2FA34A)),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2FA34A),
          fontWeight: FontWeight.w700,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: const StadiumBorder(
          side: BorderSide(color: Color(0xFF2FA34A), width: 1.4),
        ),
        backgroundColor: const Color(0xFFE6F5EA),
      ),
    );
  }
}

/* -------------------- FILTROS -------------------- */
class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.controller,
    required this.status,
    required this.tipo,
    required this.onSearch,
    required this.onPickStatus,
    required this.onClearStatus,
    required this.onPickTipo,
    required this.onClearTipo,
  });

  final TextEditingController controller;
  final InsumoStatus? status;
  final InsumoTipo? tipo;
  final ValueChanged<String> onSearch;
  final ValueChanged<InsumoStatus?> onPickStatus;
  final VoidCallback onClearStatus;
  final ValueChanged<InsumoTipo?> onPickTipo;
  final VoidCallback onClearTipo;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SizedBox(
            width: 420,
            child: TextField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome, fornecedor, lote…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        },
                        icon: const Icon(Icons.close),
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
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
              ),
            ),
          ),
        ),
        _StatusFilterChip(
          label: 'Status',
          selected: status,
          onSelected: onPickStatus,
          onClear: onClearStatus,
        ),
        _TipoFilterChip(
          label: 'Tipo',
          selected: tipo,
          onSelected: onPickTipo,
          onClear: onClearTipo,
        ),
      ],
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.onClear,
  });

  final String label;
  final InsumoStatus? selected;
  final ValueChanged<InsumoStatus?> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<InsumoStatus?>(
      tooltip: 'Filtrar por status',
      onSelected: onSelected,
      itemBuilder: (_) => <PopupMenuEntry<InsumoStatus?>>[
        PopupMenuItem(value: null, child: const Text('Todos')),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: InsumoStatus.disponivel,
          child: const Text('Disponível'),
        ),
        PopupMenuItem(
          value: InsumoStatus.baixo,
          child: const Text('Estoque baixo'),
        ),
        PopupMenuItem(
          value: InsumoStatus.vencido,
          child: const Text('Vencido'),
        ),
      ],
      child: InputChip(
        label: Text(
          selected == null
              ? '$label: Todos'
              : '$label: ${_statusLabel(selected!)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        avatar: const Icon(Icons.tune_rounded),
        onPressed: null,
        onDeleted: selected == null ? null : onClear,
        deleteIcon: const Icon(Icons.close),
        backgroundColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  String _statusLabel(InsumoStatus v) => switch (v) {
    InsumoStatus.disponivel => 'Disponível',
    InsumoStatus.baixo => 'Estoque baixo',
    InsumoStatus.vencido => 'Vencido',
  };
}

class _TipoFilterChip extends StatelessWidget {
  const _TipoFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.onClear,
  });

  final String label;
  final InsumoTipo? selected;
  final ValueChanged<InsumoTipo?> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<InsumoTipo?>(
      tooltip: 'Filtrar por tipo',
      onSelected: onSelected,
      itemBuilder: (_) => <PopupMenuEntry<InsumoTipo?>>[
        PopupMenuItem(value: null, child: const Text('Todos')),
        const PopupMenuDivider(),
        PopupMenuItem(value: InsumoTipo.semente, child: const Text('Semente')),
        PopupMenuItem(
          value: InsumoTipo.fertilizante,
          child: const Text('Fertilizante'),
        ),
        PopupMenuItem(
          value: InsumoTipo.herbicida,
          child: const Text('Herbicida'),
        ),
        PopupMenuItem(
          value: InsumoTipo.fungicida,
          child: const Text('Fungicida'),
        ),
        PopupMenuItem(
          value: InsumoTipo.inseticida,
          child: const Text('Inseticida'),
        ),
        PopupMenuItem(value: InsumoTipo.diesel, child: const Text('Diesel')),
        PopupMenuItem(
          value: InsumoTipo.aduboFoliar,
          child: const Text('Adubo foliar'),
        ),
        PopupMenuItem(
          value: InsumoTipo.corretivo,
          child: const Text('Corretivo'),
        ),
      ],
      child: InputChip(
        label: Text(
          selected == null
              ? '$label: Todos'
              : '$label: ${_tipoLabel(selected!)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        avatar: const Icon(Icons.tune_rounded),
        onPressed: null,
        onDeleted: selected == null ? null : onClear,
        deleteIcon: const Icon(Icons.close),
        backgroundColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  String _tipoLabel(InsumoTipo v) => switch (v) {
    InsumoTipo.semente => 'Semente',
    InsumoTipo.fertilizante => 'Fertilizante',
    InsumoTipo.herbicida => 'Herbicida',
    InsumoTipo.fungicida => 'Fungicida',
    InsumoTipo.inseticida => 'Inseticida',
    InsumoTipo.diesel => 'Diesel',
    InsumoTipo.aduboFoliar => 'Adubo foliar',
    InsumoTipo.corretivo => 'Corretivo',
  };
}

/* -------------------- CARD -------------------- */
class _InsumoCard extends StatelessWidget {
  const _InsumoCard({required this.i});
  final Insumo i;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final fg = _statusColor(i.status);
    final bg = _statusBg(i.status);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: fg, width: 1.2),
                  ),
                  child: Text(
                    _statusLabel(i.status),
                    style: TextStyle(color: fg, fontWeight: FontWeight.w800),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForTipo(i.tipo),
                    color: const Color(0xFF2FA34A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i.nome,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_tipoLabel(i.tipo)} • ${i.unidade}',
                        style: t.bodyMedium?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8EAED)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _row(
                    Icons.inventory_2,
                    'Qtd: ${_qtd(i.quantidade)} (mín: ${_qtd(i.minimo)})',
                  ),
                  const SizedBox(height: 8),
                  _row(
                    Icons.payments_rounded,
                    'Custo/un: ${_brl(i.custoUnit)}',
                  ),
                  const SizedBox(height: 8),
                  _row(
                    Icons.factory_rounded,
                    i.fornecedor.isEmpty ? '—' : i.fornecedor,
                  ),
                  const SizedBox(height: 8),
                  _row(Icons.place_rounded, i.local.isEmpty ? '—' : i.local),
                  const SizedBox(height: 8),
                  _row(
                    Icons.event,
                    'Validade: ${i.validade ?? '—'}  •  Lote: ${i.lote ?? '—'}',
                  ),
                  const SizedBox(height: 8),
                  _row(
                    Icons.history_rounded,
                    'Último mov.: ${i.ultimoMov ?? '—'}',
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Ver detalhes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForTipo(InsumoTipo t) => switch (t) {
    InsumoTipo.semente => Icons.grass,
    InsumoTipo.fertilizante => Icons.local_florist,
    InsumoTipo.herbicida => Icons.science_outlined,
    InsumoTipo.fungicida => Icons.biotech_outlined,
    InsumoTipo.inseticida => Icons.bug_report_outlined,
    InsumoTipo.diesel => Icons.local_gas_station,
    InsumoTipo.aduboFoliar => Icons.energy_savings_leaf,
    InsumoTipo.corretivo => Icons.construction,
  };

  String _statusLabel(InsumoStatus v) => switch (v) {
    InsumoStatus.disponivel => 'Disponível',
    InsumoStatus.baixo => 'Estoque baixo',
    InsumoStatus.vencido => 'Vencido',
  };
  Color _statusColor(InsumoStatus v) => switch (v) {
    InsumoStatus.disponivel => const Color(0xFF2FA34A),
    InsumoStatus.baixo => const Color(0xFFDAA500),
    InsumoStatus.vencido => const Color(0xFFD14343),
  };
  Color _statusBg(InsumoStatus v) => switch (v) {
    InsumoStatus.disponivel => const Color(0xFFE6F5EA),
    InsumoStatus.baixo => const Color(0xFFFFF6DB),
    InsumoStatus.vencido => const Color(0xFFFFE8E8),
  };

  String _tipoLabel(InsumoTipo v) => switch (v) {
    InsumoTipo.semente => 'Semente',
    InsumoTipo.fertilizante => 'Fertilizante',
    InsumoTipo.herbicida => 'Herbicida',
    InsumoTipo.fungicida => 'Fungicida',
    InsumoTipo.inseticida => 'Inseticida',
    InsumoTipo.diesel => 'Diesel',
    InsumoTipo.aduboFoliar => 'Adubo foliar',
    InsumoTipo.corretivo => 'Corretivo',
  };

  Widget _row(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 18, color: Colors.black54),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );

  String _qtd(double v) {
    final s = v.toStringAsFixed(v % 1 == 0 ? 0 : 2);
    return s.replaceAll('.', ',');
  }

  String _brl(double v) {
    final neg = v < 0;
    final s = v.abs().toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buf = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      final idx = intPart.length - i;
      buf.write(intPart[i]);
      if ((idx - 1) % 3 == 0 && i != intPart.length - 1) buf.write('.');
    }
    return '${neg ? '- ' : ''}R\$ ${buf.toString()},$decPart';
  }
}
