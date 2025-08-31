import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ColaboradoresScreen extends StatefulWidget {
  const ColaboradoresScreen({super.key});

  @override
  State<ColaboradoresScreen> createState() => _ColaboradoresScreenState();
}

/* ======================= DATA / MODELS ======================= */

enum EmpStatus { ativo, inativo, convidado }

extension EmpStatusX on EmpStatus {
  String get label => switch (this) {
    EmpStatus.ativo => 'Ativo',
    EmpStatus.inativo => 'Inativo',
    EmpStatus.convidado => 'Convidado',
  };

  Color get color => switch (this) {
    EmpStatus.ativo => const Color(0xFF2FA34A),
    EmpStatus.inativo => const Color(0xFF8E8E8E),
    EmpStatus.convidado => const Color(0xFF2F80ED),
  };

  Color get bg => switch (this) {
    EmpStatus.ativo => const Color(0xFFE6F5EA),
    EmpStatus.inativo => const Color(0xFFECECEC),
    EmpStatus.convidado => const Color(0xFFE6F0FD),
  };
}

class Employee {
  final String id;
  final String name;
  final String role;
  final double salary; // BRL
  final String email;
  final String phone;
  final EmpStatus status;
  final String joinedText; // <-- TEXTO FIXO (ex.: "Admitido em 29/10/2020")

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
    required this.email,
    required this.phone,
    required this.status,
    required this.joinedText,
  });
}

String _formatCurrencyBR(double v) {
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
  final str = buf.toString();
  return '${neg ? '- ' : ''}R\$ $str,$decPart';
}

/* ======================= SCREEN ======================= */

class _ColaboradoresScreenState extends State<ColaboradoresScreen> {
  final _searchCtrl = TextEditingController();
  EmpStatus? _statusFilter;

  final List<Employee> _employees = const [
    Employee(
      id: 'EMP001',
      name: 'Ana Souza',
      role: 'Gerente de Produção',
      salary: 15800.00,
      email: 'ana.souza@agro.com',
      phone: '(11) 91234-5678',
      status: EmpStatus.ativo,
      joinedText: 'Admitido em 29/10/2020',
    ),
    Employee(
      id: 'EMP002',
      name: 'Carlos Lima',
      role: 'Técnico Agrícola',
      salary: 7200.50,
      email: 'carlos.lima@agro.com',
      phone: '(11) 99876-1122',
      status: EmpStatus.ativo,
      joinedText: 'Admitido em 01/02/2019',
    ),
    Employee(
      id: 'EMP003',
      name: 'Marina Alves',
      role: 'Engenheira Agrônoma',
      salary: 12950.75,
      email: 'marina.alves@agro.com',
      phone: '(31) 98888-2211',
      status: EmpStatus.ativo,
      joinedText: 'Admitido em 01/02/2021',
    ),
    Employee(
      id: 'EMP004',
      name: 'João Henrique',
      role: 'Operador de Colheitadeira',
      salary: 5800.00,
      email: 'joao.henrique@agro.com',
      phone: '(62) 97777-3344',
      status: EmpStatus.ativo,
      joinedText: 'Admitido em 21/09/2018',
    ),
    Employee(
      id: 'EMP005',
      name: 'Rafaela Pires',
      role: 'RH • Pesquisas',
      salary: 9800.00,
      email: 'rafaela.pires@agro.com',
      phone: '(21) 93456-7788',
      status: EmpStatus.convidado,
      joinedText: 'Admitido em 10/06/2024',
    ),
    Employee(
      id: 'EMP006',
      name: 'Pedro Martins',
      role: 'UI Designer (Interno)',
      salary: 6500.30,
      email: 'pedro.martins@agro.com',
      phone: '(47) 95555-9911',
      status: EmpStatus.inativo,
      joinedText: 'Admitido em 01/01/2019',
    ),
    Employee(
      id: 'EMP007',
      name: 'Bruna Costa',
      role: 'Planejadora de Safra',
      salary: 11500.00,
      email: 'bruna.costa@agro.com',
      phone: '(41) 95330-2277',
      status: EmpStatus.ativo,
      joinedText: 'Admitido em 12/05/2022',
    ),
    Employee(
      id: 'EMP008',
      name: 'Luís Amaral',
      role: 'Mecânico de Máquinas',
      salary: 7400.00,
      email: 'luis.amaral@agro.com',
      phone: '(51) 94444-5566',
      status: EmpStatus.ativo,
      joinedText: 'Admitido em 30/11/2023',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Employee> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _employees.where((e) {
      final byStatus = _statusFilter == null || e.status == _statusFilter;
      final byText =
          q.isEmpty ||
          e.name.toLowerCase().contains(q) ||
          e.role.toLowerCase().contains(q) ||
          e.email.toLowerCase().contains(q) ||
          e.id.toLowerCase().contains(q);
      return byStatus && byText;
    }).toList();
  }

  // ---------- IMPRESSÃO BÁSICA (PDF + diálogo do sistema) ----------
  Future<void> _printEmployees() async {
    final data = _filtered; // usa a lista filtrada/resultado da busca
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(margin: const pw.EdgeInsets.all(24)),
        build: (context) => [
          pw.Text(
            'Colaboradores',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: const [
              'ID',
              'Nome',
              'Função',
              'Salário',
              'Status',
              'Email',
              'Telefone',
              'Admissão',
            ],
            data: data
                .map(
                  (e) => [
                    e.id,
                    e.name,
                    e.role,
                    _formatCurrencyBR(e.salary),
                    e.status.label,
                    e.email,
                    e.phone,
                    e.joinedText, // já vem como texto fixo
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.centerLeft,
            headerAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FlexColumnWidth(1.2), // ID um pouco menor
              3: const pw.FlexColumnWidth(1.3), // Salário
            },
          ),
        ],
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
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
            Icon(Icons.people_alt_rounded, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              'Colaboradores',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          // NOVO: botão Imprimir
          _topAction('Imprimir', Icons.print_rounded, () {
            _printEmployees();
          }),
          const SizedBox(width: 8),
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
                  const SnackBar(content: Text('Adicionar colaborador (demo)')),
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
              statusFilter: _statusFilter,
              onClearStatus: () => setState(() => _statusFilter = null),
              onPickStatus: (s) => setState(() => _statusFilter = s),
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
                childAspectRatio: 0.88,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _EmployeeCard(emp: _filtered[i]),
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

/* ======================= FILTERS BAR ======================= */

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.controller,
    required this.statusFilter,
    required this.onPickStatus,
    required this.onClearStatus,
  });

  final TextEditingController controller;
  final EmpStatus? statusFilter;
  final ValueChanged<EmpStatus?> onPickStatus;
  final VoidCallback onClearStatus;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Busca
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SizedBox(
            width: 420,
            child: TextField(
              controller: controller,
              onChanged: (_) => (context as Element).markNeedsBuild(),
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome, função, email ou #ID',
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

        // Filtro por status
        _StatusFilterChip(
          label: 'Status',
          selected: statusFilter,
          onSelected: onPickStatus,
          onClear: onClearStatus,
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
  final EmpStatus? selected;
  final ValueChanged<EmpStatus?> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<EmpStatus?>(
      tooltip: 'Filtrar por status',
      onSelected: onSelected,
      itemBuilder: (_) => <PopupMenuEntry<EmpStatus?>>[
        PopupMenuItem(value: null, child: const Text('Todos')),
        PopupMenuDivider(), // <- sem const
        PopupMenuItem(
          value: EmpStatus.ativo,
          child: Row(
            children: [
              _StatusDot(color: EmpStatus.ativo.color),
              const SizedBox(width: 8),
              Text(EmpStatus.ativo.label),
            ],
          ),
        ),
        PopupMenuItem(
          value: EmpStatus.convidado,
          child: Row(
            children: [
              _StatusDot(color: EmpStatus.convidado.color),
              const SizedBox(width: 8),
              Text(EmpStatus.convidado.label),
            ],
          ),
        ),
        PopupMenuItem(
          value: EmpStatus.inativo,
          child: Row(
            children: [
              _StatusDot(color: EmpStatus.inativo.color),
              const SizedBox(width: 8),
              Text(EmpStatus.inativo.label),
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

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/* ======================= EMPLOYEE CARD ======================= */

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.emp});
  final Employee emp;

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
            // Linha superior: status + menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: emp.status.bg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: emp.status.color, width: 1.2),
                  ),
                  child: Text(
                    emp.status.label,
                    style: TextStyle(
                      color: emp.status.color,
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
                    PopupMenuDivider(), // <- sem const
                    PopupMenuItem(value: 3, child: const Text('Remover')),
                  ],
                  onSelected: (v) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ação $v em ${emp.name} (demo)')),
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

            // "Avatar" simples + nome/role
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF2FA34A)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emp.name,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        emp.role,
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
                  _infoRow(Icons.tag, '#${emp.id}'),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.payments_rounded,
                    _formatCurrencyBR(emp.salary),
                  ),
                  const SizedBox(height: 8),
                  _infoRow(Icons.mail_outline_rounded, emp.email),
                  const SizedBox(height: 8),
                  _infoRow(Icons.phone_rounded, emp.phone),
                ],
              ),
            ),

            const Spacer(),

            // Rodapé (data fixa em texto)
            Row(
              children: [
                Text(
                  emp.joinedText,
                  style: t.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Detalhes de ${emp.name} (demo)')),
                    );
                  },
                  child: const Text('Ver detalhes'),
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
