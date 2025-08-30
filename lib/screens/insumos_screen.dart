import 'package:flutter/material.dart';

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({super.key});

  @override
  State<InsumosScreen> createState() => _InsumosScreenState();
}

/* ======================= MODELOS / DADOS ======================= */

enum InsumoStatus { disponivel, baixo, vencido }

enum InsumoTipo {
  semente,
  fertilizante,
  herbicida,
  fungicida,
  inseticida,
  diesel,
  aduboFoliar,
  corretivo,
}

extension InsumoStatusX on InsumoStatus {
  String get label {
    switch (this) {
      case InsumoStatus.disponivel:
        return 'Disponível';
      case InsumoStatus.baixo:
        return 'Baixo estoque';
      case InsumoStatus.vencido:
        return 'Vencido';
    }
  }

  Color get color {
    switch (this) {
      case InsumoStatus.disponivel:
        return const Color(0xFF2FA34A);
      case InsumoStatus.baixo:
        return const Color(0xFFFF8A00);
      case InsumoStatus.vencido:
        return const Color(0xFFD32F2F);
    }
  }

  Color get bg {
    switch (this) {
      case InsumoStatus.disponivel:
        return const Color(0xFFE6F5EA);
      case InsumoStatus.baixo:
        return const Color(0xFFFFF2E5);
      case InsumoStatus.vencido:
        return const Color(0xFFFFEAEA);
    }
  }
}

extension InsumoTipoX on InsumoTipo {
  String get label {
    switch (this) {
      case InsumoTipo.semente:
        return 'Semente';
      case InsumoTipo.fertilizante:
        return 'Fertilizante';
      case InsumoTipo.herbicida:
        return 'Herbicida';
      case InsumoTipo.fungicida:
        return 'Fungicida';
      case InsumoTipo.inseticida:
        return 'Inseticida';
      case InsumoTipo.diesel:
        return 'Diesel';
      case InsumoTipo.aduboFoliar:
        return 'Adubo foliar';
      case InsumoTipo.corretivo:
        return 'Corretivo';
    }
  }

  IconData get icon {
    switch (this) {
      case InsumoTipo.semente:
        return Icons.eco; // semente
      case InsumoTipo.fertilizante:
        return Icons.spa; // fertilizante / adubo
      case InsumoTipo.herbicida:
        return Icons.science; // defensivo
      case InsumoTipo.fungicida:
        return Icons.biotech; // defensivo
      case InsumoTipo.inseticida:
        return Icons.bug_report; // insetos
      case InsumoTipo.diesel:
        return Icons.local_gas_station; // combustível
      case InsumoTipo.aduboFoliar:
        return Icons.local_florist; // foliar
      case InsumoTipo.corretivo:
        return Icons.terrain; // corretivos de solo
    }
  }
}

class Insumo {
  final String id;
  final String nome;
  final InsumoTipo tipo;
  final String unidade; // ex.: "kg", "L", "sc 60kg", "t"
  final double quantidade;
  final double minimo; // ponto de reposição
  final double custoUnit; // BRL
  final String fornecedor;
  final String local;
  final InsumoStatus status;
  final String validade; // texto fixo
  final String lote;
  final String ultimoMov; // texto fixo

  const Insumo({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.unidade,
    required this.quantidade,
    required this.minimo,
    required this.custoUnit,
    required this.fornecedor,
    required this.local,
    required this.status,
    required this.validade,
    required this.lote,
    required this.ultimoMov,
  });
}

/* ---------- helpers de formatação simples (sem intl) ---------- */

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

String _qtd(double q) {
  final s = q.toStringAsFixed(q % 1 == 0 ? 0 : 2); // 0 ou 2 casas
  final parts = s.split('.');
  final intPart = parts[0];
  final dec = parts.length > 1 ? ',${parts[1]}' : '';
  final buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    final idx = intPart.length - i;
    buf.write(intPart[i]);
    if ((idx - 1) % 3 == 0 && i != intPart.length - 1) buf.write('.');
  }
  return buf.toString() + dec;
}

/* ======================= TELA ======================= */

class _InsumosScreenState extends State<InsumosScreen> {
  final _searchCtrl = TextEditingController();
  InsumoStatus? _statusFilter;
  InsumoTipo? _tipoFilter;

  final List<Insumo> _items = const [
    Insumo(
      id: 'INS001',
      nome: 'Semente Soja RR 62',
      tipo: InsumoTipo.semente,
      unidade: 'sc 60kg',
      quantidade: 320,
      minimo: 200,
      custoUnit: 460.00,
      fornecedor: 'AgroSeeds',
      local: 'Almox 1',
      status: InsumoStatus.disponivel,
      validade: 'Validade: 15/11/2025',
      lote: 'Lote L220318',
      ultimoMov: 'Entrada 120 sc em 12/08/2025',
    ),
    Insumo(
      id: 'INS002',
      nome: 'Ureia 46%',
      tipo: InsumoTipo.fertilizante,
      unidade: 'kg',
      quantidade: 12500,
      minimo: 8000,
      custoUnit: 3.20,
      fornecedor: 'FertiBras',
      local: 'Graneleiro',
      status: InsumoStatus.disponivel,
      validade: 'Validade: 30/06/2026',
      lote: 'UR-46-2506',
      ultimoMov: 'Saída 2.000 kg em 22/08/2025',
    ),
    Insumo(
      id: 'INS003',
      nome: 'Glifosato 480 SL',
      tipo: InsumoTipo.herbicida,
      unidade: 'L',
      quantidade: 380,
      minimo: 250,
      custoUnit: 22.90,
      fornecedor: 'AgroChem',
      local: 'Químicos A',
      status: InsumoStatus.disponivel,
      validade: 'Validade: 10/02/2027',
      lote: 'GF-480-24',
      ultimoMov: 'Entrada 80 L em 18/08/2025',
    ),
    Insumo(
      id: 'INS004',
      nome: 'Diesel S10',
      tipo: InsumoTipo.diesel,
      unidade: 'L',
      quantidade: 8200,
      minimo: 6000,
      custoUnit: 5.79,
      fornecedor: 'Posto Rural',
      local: 'Tanque Principal',
      status: InsumoStatus.disponivel,
      validade: 'Validade: —',
      lote: 'N/A',
      ultimoMov: 'Abastecido 1.200 L em 28/08/2025',
    ),
    Insumo(
      id: 'INS005',
      nome: 'Carbendazim 500 SC',
      tipo: InsumoTipo.fungicida,
      unidade: 'L',
      quantidade: 40,
      minimo: 100,
      custoUnit: 39.50,
      fornecedor: 'ProtectAgro',
      local: 'Químicos B',
      status: InsumoStatus.baixo,
      validade: 'Validade: 05/12/2025',
      lote: 'CB-500-25',
      ultimoMov: 'Saída 30 L em 26/08/2025',
    ),
    Insumo(
      id: 'INS006',
      nome: 'Lambda-cialotrina 50 EC',
      tipo: InsumoTipo.inseticida,
      unidade: 'L',
      quantidade: 18,
      minimo: 60,
      custoUnit: 42.00,
      fornecedor: 'AgroDefense',
      local: 'Químicos B',
      status: InsumoStatus.baixo,
      validade: 'Validade: 20/09/2025',
      lote: 'LC-50-24',
      ultimoMov: 'Saída 12 L em 25/08/2025',
    ),
    Insumo(
      id: 'INS007',
      nome: 'Calcário PRNT 90',
      tipo: InsumoTipo.corretivo,
      unidade: 't',
      quantidade: 85,
      minimo: 50,
      custoUnit: 120.00,
      fornecedor: 'SoloMinas',
      local: 'Pátio 3',
      status: InsumoStatus.disponivel,
      validade: 'Validade: —',
      lote: 'CAL-PRNT-90',
      ultimoMov: 'Entrega 35 t em 05/08/2025',
    ),
    Insumo(
      id: 'INS008',
      nome: 'Boro 10% (foliar)',
      tipo: InsumoTipo.aduboFoliar,
      unidade: 'L',
      quantidade: 0,
      minimo: 40,
      custoUnit: 28.00,
      fornecedor: 'LeafNutrients',
      local: 'Químicos C',
      status: InsumoStatus.vencido,
      validade: 'Validade: 01/08/2024',
      lote: 'BORO-10-23',
      ultimoMov: 'Bloqueado por validade',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Insumo> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _items.where((i) {
      final byStatus = _statusFilter == null || i.status == _statusFilter;
      final byTipo = _tipoFilter == null || i.tipo == _tipoFilter;
      final byQuery =
          q.isEmpty ||
          i.nome.toLowerCase().contains(q) ||
          i.id.toLowerCase().contains(q) ||
          i.fornecedor.toLowerCase().contains(q) ||
          i.local.toLowerCase().contains(q) ||
          i.tipo.label.toLowerCase().contains(q);
      return byStatus && byTipo && byQuery;
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
                  const SnackBar(content: Text('Adicionar insumo (demo)')),
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
              tipo: _tipoFilter,
              onPickStatus: (v) => setState(() => _statusFilter = v),
              onClearStatus: () => setState(() => _statusFilter = null),
              onPickTipo: (v) => setState(() => _tipoFilter = v),
              onClearTipo: () => setState(() => _tipoFilter = null),
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
              itemBuilder: (context, i) => _InsumoCard(item: _filtered[i]),
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
    required this.tipo,
    required this.onPickStatus,
    required this.onClearStatus,
    required this.onPickTipo,
    required this.onClearTipo,
  });

  final TextEditingController controller;
  final InsumoStatus? status;
  final InsumoTipo? tipo;
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
              onChanged: (_) => (context as Element).markNeedsBuild(),
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome, ID, tipo, local ou fornecedor',
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
        PopupMenuDivider(),
        PopupMenuItem(
          value: InsumoStatus.disponivel,
          child: Row(
            children: [
              _Dot(color: InsumoStatus.disponivel.color),
              const SizedBox(width: 8),
              Text(InsumoStatus.disponivel.label),
            ],
          ),
        ),
        PopupMenuItem(
          value: InsumoStatus.baixo,
          child: Row(
            children: [
              _Dot(color: InsumoStatus.baixo.color),
              const SizedBox(width: 8),
              Text(InsumoStatus.baixo.label),
            ],
          ),
        ),
        PopupMenuItem(
          value: InsumoStatus.vencido,
          child: Row(
            children: [
              _Dot(color: InsumoStatus.vencido.color),
              const SizedBox(width: 8),
              Text(InsumoStatus.vencido.label),
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
        PopupMenuDivider(),
        for (final t in InsumoTipo.values)
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
        backgroundColor: const Color(0xFFFFFFFF),
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/* ======================= CARD DE INSUMO ======================= */

class _InsumoCard extends StatelessWidget {
  const _InsumoCard({required this.item});
  final Insumo item;

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
                    color: item.status.bg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: item.status.color, width: 1.2),
                  ),
                  child: Text(
                    item.status.label,
                    style: TextStyle(
                      color: item.status.color,
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
                    PopupMenuItem(
                      value: 3,
                      child: const Text('Baixar estoque'),
                    ),
                  ],
                  onSelected: (v) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ação $v em ${item.nome} (demo)')),
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

            // Ícone + nome / subtítulo
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.tipo.icon, color: const Color(0xFF2FA34A)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nome,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.tipo.label} • ${item.fornecedor}',
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
                  _infoRow(Icons.tag, '#${item.id}'),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.inventory_2,
                    'Estoque: ${_qtd(item.quantidade)} ${item.unidade}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.report,
                    'Mínimo: ${_qtd(item.minimo)} ${item.unidade}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.payments_rounded,
                    'Custo/un.: ${_brl(item.custoUnit)}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(Icons.place_outlined, item.local),
                ],
              ),
            ),

            const Spacer(),

            // Rodapé: validade, lote e último movimento (textos fixos)
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.validade,
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
                    '${item.lote} • ${item.ultimoMov}',
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
