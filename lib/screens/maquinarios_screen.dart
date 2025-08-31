import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/machines_notifier.dart';
import '../data/models/machine.dart';
import '../forms/machine_form_screen.dart'; // <-- IMPORTA O FORM

class MaquinariosScreen extends StatefulWidget {
  const MaquinariosScreen({super.key});

  @override
  State<MaquinariosScreen> createState() => _MaquinariosScreenState();
}

class _MaquinariosScreenState extends State<MaquinariosScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MachinesNotifier>();
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
            Icon(Icons.agriculture, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              'Maquinários',
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
          // ------ ABRE O FORM E RECARREGA AO VOLTAR COM SUCESSO ------
          _topAction('Adicionar', Icons.add, () async {
            final created = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const MachineFormScreen()),
            );
            if (!mounted) return;
            if (created == true) {
              await context.read<MachinesNotifier>().load(page: 1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Maquinário cadastrado!')),
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
              type: state.type,
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
              onPickType: (v) {
                state.setType(v);
                state.load(page: 1);
              },
              onClearType: () {
                state.setType(null);
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
                itemBuilder: (_, i) => _MachineCard(m: state.items[i]),
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
    required this.type,
    required this.onSearch,
    required this.onPickStatus,
    required this.onClearStatus,
    required this.onPickType,
    required this.onClearType,
  });

  final TextEditingController controller;
  final MachineStatus? status;
  final MachineType? type;
  final ValueChanged<String> onSearch;
  final ValueChanged<MachineStatus?> onPickStatus;
  final VoidCallback onClearStatus;
  final ValueChanged<MachineType?> onPickType;
  final VoidCallback onClearType;

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
                hintText: 'Pesquisar por apelido, modelo, local…',
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
        _TypeFilterChip(
          label: 'Tipo',
          selected: type,
          onSelected: onPickType,
          onClear: onClearType,
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
  final MachineStatus? selected;
  final ValueChanged<MachineStatus?> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MachineStatus?>(
      tooltip: 'Filtrar por status',
      onSelected: onSelected,
      itemBuilder: (_) => <PopupMenuEntry<MachineStatus?>>[
        PopupMenuItem(value: null, child: const Text('Todos')),
        const PopupMenuDivider(),
        PopupMenuItem(value: MachineStatus.ativo, child: const Text('Ativo')),
        PopupMenuItem(
          value: MachineStatus.manutencao,
          child: const Text('Manutenção'),
        ),
        PopupMenuItem(
          value: MachineStatus.inativo,
          child: const Text('Inativo'),
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

  String _statusLabel(MachineStatus v) => switch (v) {
    MachineStatus.ativo => 'Ativo',
    MachineStatus.manutencao => 'Manutenção',
    MachineStatus.inativo => 'Inativo',
  };
}

class _TypeFilterChip extends StatelessWidget {
  const _TypeFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.onClear,
  });

  final String label;
  final MachineType? selected;
  final ValueChanged<MachineType?> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MachineType?>(
      tooltip: 'Filtrar por tipo',
      onSelected: onSelected,
      itemBuilder: (_) => <PopupMenuEntry<MachineType?>>[
        PopupMenuItem(value: null, child: const Text('Todos')),
        const PopupMenuDivider(),
        PopupMenuItem(value: MachineType.trator, child: const Text('Trator')),
        PopupMenuItem(
          value: MachineType.colheitadeira,
          child: const Text('Colheitadeira'),
        ),
        PopupMenuItem(
          value: MachineType.pulverizador,
          child: const Text('Pulverizador'),
        ),
        PopupMenuItem(
          value: MachineType.semeadora,
          child: const Text('Semeadora'),
        ),
        PopupMenuItem(
          value: MachineType.caminhao,
          child: const Text('Caminhão'),
        ),
        PopupMenuItem(
          value: MachineType.retroescavadeira,
          child: const Text('Retroescavadeira'),
        ),
      ],
      child: InputChip(
        label: Text(
          selected == null
              ? '$label: Todos'
              : '$label: ${_typeLabel(selected!)}',
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

  String _typeLabel(MachineType v) => switch (v) {
    MachineType.trator => 'Trator',
    MachineType.colheitadeira => 'Colheitadeira',
    MachineType.pulverizador => 'Pulverizador',
    MachineType.semeadora => 'Semeadora',
    MachineType.caminhao => 'Caminhão',
    MachineType.retroescavadeira => 'Retroescavadeira',
  };
}

/* -------------------- CARD -------------------- */
class _MachineCard extends StatelessWidget {
  const _MachineCard({required this.m});
  final Machine m;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final statusFg = _statusColor(m.status);
    final statusBg = _statusBg(m.status);

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
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: statusFg, width: 1.2),
                  ),
                  child: Text(
                    _statusLabel(m.status),
                    style: TextStyle(
                      color: statusFg,
                      fontWeight: FontWeight.w800,
                    ),
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
                    _iconForType(m.type),
                    color: const Color(0xFF2FA34A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.apelido,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_typeLabel(m.type)} • ${m.modelo} • ${m.ano}',
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
                  _row(Icons.place_rounded, m.local.isEmpty ? '—' : m.local),
                  const SizedBox(height: 8),
                  _row(Icons.timer_outlined, '${m.horas} h'),
                  const SizedBox(height: 8),
                  _row(Icons.payments_rounded, _brl(m.custoHora) + ' /h'),
                  const SizedBox(height: 8),
                  _row(
                    Icons.build_circle_outlined,
                    'Última: ${m.ultimaManutencao ?? '—'} • Próxima: ${m.proximaManutencao ?? '—'}',
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

  IconData _iconForType(MachineType t) => switch (t) {
    MachineType.trator => Icons.agriculture,
    MachineType.colheitadeira => Icons.grass,
    MachineType.pulverizador => Icons.science, // substituto do spray
    MachineType.semeadora => Icons.yard,
    MachineType.caminhao => Icons.local_shipping,
    MachineType.retroescavadeira => Icons.construction,
  };

  String _statusLabel(MachineStatus v) => switch (v) {
    MachineStatus.ativo => 'Ativo',
    MachineStatus.manutencao => 'Manutenção',
    MachineStatus.inativo => 'Inativo',
  };
  Color _statusColor(MachineStatus v) => switch (v) {
    MachineStatus.ativo => const Color(0xFF2FA34A),
    MachineStatus.manutencao => const Color(0xFFDAA500),
    MachineStatus.inativo => const Color(0xFF8E8E8E),
  };
  Color _statusBg(MachineStatus v) => switch (v) {
    MachineStatus.ativo => const Color(0xFFE6F5EA),
    MachineStatus.manutencao => const Color(0xFFFFF6DB),
    MachineStatus.inativo => const Color(0xFFECECEC),
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

  String _typeLabel(MachineType v) => switch (v) {
    MachineType.trator => 'Trator',
    MachineType.colheitadeira => 'Colheitadeira',
    MachineType.pulverizador => 'Pulverizador',
    MachineType.semeadora => 'Semeadora',
    MachineType.caminhao => 'Caminhão',
    MachineType.retroescavadeira => 'Retroescavadeira',
  };
}
