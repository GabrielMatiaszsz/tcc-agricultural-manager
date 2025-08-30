import 'package:flutter/material.dart';

class MaquinariosScreen extends StatefulWidget {
  const MaquinariosScreen({super.key});

  @override
  State<MaquinariosScreen> createState() => _MaquinariosScreenState();
}

/* ======================= MODELOS / DADOS ======================= */

enum MachineStatus { ativo, manutencao, inativo }

enum MachineType {
  trator,
  colheitadeira,
  pulverizador,
  semeadora,
  caminhao,
  retroescavadeira,
}

extension MachineStatusX on MachineStatus {
  String get label {
    switch (this) {
      case MachineStatus.ativo:
        return 'Ativo';
      case MachineStatus.manutencao:
        return 'Em manutenção';
      case MachineStatus.inativo:
        return 'Inativo';
    }
  }

  Color get color {
    switch (this) {
      case MachineStatus.ativo:
        return const Color(0xFF2FA34A);
      case MachineStatus.manutencao:
        return const Color(0xFFFF8A00);
      case MachineStatus.inativo:
        return const Color(0xFF8E8E8E);
    }
  }

  Color get bg {
    switch (this) {
      case MachineStatus.ativo:
        return const Color(0xFFE6F5EA);
      case MachineStatus.manutencao:
        return const Color(0xFFFFF2E5);
      case MachineStatus.inativo:
        return const Color(0xFFECECEC);
    }
  }
}

extension MachineTypeX on MachineType {
  String get label {
    switch (this) {
      case MachineType.trator:
        return 'Trator';
      case MachineType.colheitadeira:
        return 'Colheitadeira';
      case MachineType.pulverizador:
        return 'Pulverizador';
      case MachineType.semeadora:
        return 'Semeadora';
      case MachineType.caminhao:
        return 'Caminhão';
      case MachineType.retroescavadeira:
        return 'Retroescavadeira';
    }
  }

  IconData get icon {
    switch (this) {
      case MachineType.trator:
        return Icons.agriculture_rounded;
      case MachineType.colheitadeira:
        return Icons.grass_rounded;
      case MachineType.pulverizador:
        return Icons.science_rounded; // substitui o spray_can
      case MachineType.semeadora:
        return Icons.grain_rounded;
      case MachineType.caminhao:
        return Icons.local_shipping_rounded;
      case MachineType.retroescavadeira:
        return Icons.construction_rounded;
    }
  }
}

class Machine {
  final String id;
  final String apelido; // nome curto (ex.: "Trator 01")
  final MachineType type;
  final String modelo; // modelo/ano
  final int ano;
  final int horas; // horas de uso
  final double custoHora; // BRL
  final String local; // talhão/setor
  final MachineStatus status;
  final String ultimaManutencao; // texto fixo
  final String proximaManutencao; // texto fixo

  const Machine({
    required this.id,
    required this.apelido,
    required this.type,
    required this.modelo,
    required this.ano,
    required this.horas,
    required this.custoHora,
    required this.local,
    required this.status,
    required this.ultimaManutencao,
    required this.proximaManutencao,
  });
}

String _brl(double v) {
  final neg = v < 0;
  final s = v.abs().toStringAsFixed(2); // 1234.56
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

String _horas(int h) {
  // ex.: 1.250 h
  final s = h.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idx = s.length - i;
    buf.write(s[i]);
    if ((idx - 1) % 3 == 0 && i != s.length - 1) buf.write('.');
  }
  return '${buf.toString()} h';
}

/* ======================= TELA ======================= */

class _MaquinariosScreenState extends State<MaquinariosScreen> {
  final _searchCtrl = TextEditingController();
  MachineStatus? _statusFilter;
  MachineType? _typeFilter;

  final List<Machine> _list = const [
    Machine(
      id: 'MAC001',
      apelido: 'Trator 01',
      type: MachineType.trator,
      modelo: 'John Deere 6110J',
      ano: 2021,
      horas: 1250,
      custoHora: 180.0,
      local: 'Talhão A - Soja',
      status: MachineStatus.ativo,
      ultimaManutencao: 'Última manutenção: 10/03/2024',
      proximaManutencao: 'Próxima: 10/09/2024',
    ),
    Machine(
      id: 'MAC002',
      apelido: 'Colheitadeira 02',
      type: MachineType.colheitadeira,
      modelo: 'Case IH Axial-Flow 7230',
      ano: 2019,
      horas: 3480,
      custoHora: 420.0,
      local: 'Talhão C - Milho',
      status: MachineStatus.manutencao,
      ultimaManutencao: 'Última manutenção: 20/07/2024',
      proximaManutencao: 'Em oficina desde 25/08/2024',
    ),
    Machine(
      id: 'MAC003',
      apelido: 'Pulverizador 01',
      type: MachineType.pulverizador,
      modelo: 'Jacto Uniport 3030',
      ano: 2020,
      horas: 2120,
      custoHora: 260.0,
      local: 'Talhão B - Algodão',
      status: MachineStatus.ativo,
      ultimaManutencao: 'Última manutenção: 05/05/2024',
      proximaManutencao: 'Próxima: 05/11/2024',
    ),
    Machine(
      id: 'MAC004',
      apelido: 'Semeadora 01',
      type: MachineType.semeadora,
      modelo: 'TATU Marchesan PS-180',
      ano: 2018,
      horas: 1580,
      custoHora: 150.0,
      local: 'Galpão 2',
      status: MachineStatus.inativo,
      ultimaManutencao: 'Última manutenção: 11/02/2023',
      proximaManutencao: 'Próxima: 11/02/2025',
    ),
    Machine(
      id: 'MAC005',
      apelido: 'Trator 02',
      type: MachineType.trator,
      modelo: 'Valtra A114',
      ano: 2022,
      horas: 930,
      custoHora: 175.0,
      local: 'Talhão D - Feijão',
      status: MachineStatus.ativo,
      ultimaManutencao: 'Última manutenção: 01/04/2024',
      proximaManutencao: 'Próxima: 01/10/2024',
    ),
    Machine(
      id: 'MAC006',
      apelido: 'Caminhão 01',
      type: MachineType.caminhao,
      modelo: 'VW Constellation 24.280',
      ano: 2020,
      horas: 4210,
      custoHora: 350.0,
      local: 'Logística',
      status: MachineStatus.ativo,
      ultimaManutencao: 'Última manutenção: 15/06/2024',
      proximaManutencao: 'Próxima: 15/12/2024',
    ),
    Machine(
      id: 'MAC007',
      apelido: 'Retro 01',
      type: MachineType.retroescavadeira,
      modelo: 'JCB 3C',
      ano: 2017,
      horas: 5100,
      custoHora: 300.0,
      local: 'Obras internas',
      status: MachineStatus.manutencao,
      ultimaManutencao: 'Troca de bomba: 02/08/2024',
      proximaManutencao: 'Retorna: 12/09/2024',
    ),
    Machine(
      id: 'MAC008',
      apelido: 'Pulverizador 02',
      type: MachineType.pulverizador,
      modelo: 'Kuhn Boxer',
      ano: 2016,
      horas: 6890,
      custoHora: 210.0,
      local: 'Talhão E - Trigo',
      status: MachineStatus.inativo,
      ultimaManutencao: 'Revisão completa: 19/04/2022',
      proximaManutencao: 'Aguardando decisão',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Machine> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _list.where((m) {
      final byStatus = _statusFilter == null || m.status == _statusFilter;
      final byType = _typeFilter == null || m.type == _typeFilter;
      final byQuery =
          q.isEmpty ||
          m.apelido.toLowerCase().contains(q) ||
          m.modelo.toLowerCase().contains(q) ||
          m.id.toLowerCase().contains(q) ||
          m.type.label.toLowerCase().contains(q) ||
          m.local.toLowerCase().contains(q);
      return byStatus && byType && byQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
            Icon(Icons.agriculture_rounded, color: Colors.black54),
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
          _topAction('Importar', Icons.file_upload_rounded, () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Importar (demo)')));
          }),
          const SizedBox(width: 8),
          _topAction('Exportar', Icons.file_download_rounded, () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Exportar (demo)')));
          }),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adicionar maquinário (demo)')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2FA34A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _FiltersBar(
              controller: _searchCtrl,
              status: _statusFilter,
              type: _typeFilter,
              onPickStatus: (v) => setState(() => _statusFilter = v),
              onClearStatus: () => setState(() => _statusFilter = null),
              onPickType: (v) => setState(() => _typeFilter = v),
              onClearType: () => setState(() => _typeFilter = null),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.92,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _MachineCard(m: _filtered[i]),
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

/* ======================= BARRA DE FILTROS ======================= */

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.controller,
    required this.status,
    required this.type,
    required this.onPickStatus,
    required this.onClearStatus,
    required this.onPickType,
    required this.onClearType,
  });

  final TextEditingController controller;
  final MachineStatus? status;
  final MachineType? type;
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
              onChanged: (_) => (context as Element).markNeedsBuild(),
              decoration: InputDecoration(
                hintText: 'Pesquisar por ID, tipo, modelo, local ou apelido',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          controller.clear();
                          (context as Element).markNeedsBuild();
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2FA34A),
                    width: 1.4,
                  ),
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
        PopupMenuDivider(),
        PopupMenuItem(
          value: MachineStatus.ativo,
          child: Row(
            children: [
              _StatusDot(color: MachineStatus.ativo.color),
              const SizedBox(width: 8),
              Text(MachineStatus.ativo.label),
            ],
          ),
        ),
        PopupMenuItem(
          value: MachineStatus.manutencao,
          child: Row(
            children: [
              _StatusDot(color: MachineStatus.manutencao.color),
              const SizedBox(width: 8),
              Text(MachineStatus.manutencao.label),
            ],
          ),
        ),
        PopupMenuItem(
          value: MachineStatus.inativo,
          child: Row(
            children: [
              _StatusDot(color: MachineStatus.inativo.color),
              const SizedBox(width: 8),
              Text(MachineStatus.inativo.label),
            ],
          ),
        ),
      ],
      child: InputChip(
        label: Text(
          selected == null ? '$label: Todos' : '$label: ${selected!.label}',
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
        PopupMenuDivider(),
        for (final t in MachineType.values)
          PopupMenuItem(
            value: t,
            child: Row(
              children: [
                Icon(t.icon, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Text(t.label),
              ],
            ),
          ),
      ],
      child: InputChip(
        label: Text(
          selected == null ? '$label: Todos' : '$label: ${selected!.label}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        avatar: const Icon(Icons.category_rounded),
        onPressed: null,
        onDeleted: selected == null ? null : onClear,
        deleteIcon: const Icon(Icons.close),
        backgroundColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/* ======================= CARD DE MAQUINÁRIO ======================= */

class _MachineCard extends StatelessWidget {
  const _MachineCard({required this.m});
  final Machine m;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topo: status + menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: m.status.bg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: m.status.color, width: 1.2),
                  ),
                  child: Text(
                    m.status.label,
                    style: TextStyle(
                      color: m.status.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<int>(
                  tooltip: 'Mais ações',
                  itemBuilder: (_) => <PopupMenuEntry<int>>[
                    PopupMenuItem(value: 1, child: const Text('Ver detalhes')),
                    PopupMenuItem(value: 2, child: const Text('Editar')),
                    PopupMenuDivider(),
                    PopupMenuItem(value: 3, child: const Text('Desativar')),
                  ],
                  onSelected: (v) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ação $v em ${m.apelido} (demo)')),
                    );
                  },
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ícone + título
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(m.type.icon, color: const Color(0xFF2FA34A)),
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
                        '${m.type.label} • ${m.modelo} • ${m.ano}',
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

            // Caixa de infos
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8EAED)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _infoRow(Icons.tag, '#${m.id}'),
                  const SizedBox(height: 8),
                  _infoRow(Icons.speed_rounded, 'Uso: ${_horas(m.horas)}'),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.payments_rounded,
                    'Custo/h: ${_brl(m.custoHora)}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(Icons.place_outlined, m.local),
                ],
              ),
            ),

            const Spacer(),

            // Rodapé: manutenção (texto fixo)
            Row(
              children: [
                Expanded(
                  child: Text(
                    m.ultimaManutencao,
                    style: t.bodySmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    m.proximaManutencao,
                    style: t.bodySmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
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
  }
}
