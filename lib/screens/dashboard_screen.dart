import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool simulatorMode = false;

  // caminhos exatos (como estão na sua pasta)
  static const kBgInsumos = 'assets/images/bg_insumos.jpg';
  static const kBgMaquinarios = 'assets/images/bg_maquinarios.jpg';
  static const kBgColaboradores = 'assets/images/bg_colaboradores.jpg';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pré-carrega para evitar “piscadas”
    for (final p in [kBgInsumos, kBgMaquinarios, kBgColaboradores]) {
      rootBundle
          .load(p)
          .then((_) {
            precacheImage(AssetImage(p), context);
          })
          .catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _HeaderPanel(
                simulatorMode: simulatorMode,
                onChanged: (v) => setState(() => simulatorMode = v),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverGrid.count(
              crossAxisCount: isWide ? 3 : 1,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: isWide ? 1.65 : 1.45,
              children: const [
                _MetricCard(
                  title: 'Área',
                  primaryValue: '4.000,00 ha',
                  secondaryLabel: 'Produtividade',
                  secondaryValue: '70,00 sc60/ha',
                ),
                _MetricCard(
                  title: 'Plantio',
                  primaryValue: 'FINALIZADO',
                  primaryChipColor: Color(0xFFE6F5EA),
                  primaryChipBorder: Color(0xFF2FA34A),
                  items: {
                    'Duração': '22 dias',
                    'Início do plantio': '27/09/2023',
                    'Final do plantio': '14/10/2024',
                  },
                ),
                _MetricCard(
                  title: 'Colheita',
                  primaryValue: 'FINALIZADO',
                  primaryChipColor: Color(0xFFE6F5EA),
                  primaryChipBorder: Color(0xFF2FA34A),
                  items: {
                    'Duração': '84 dias',
                    'Início da colheita': '02/01/2024',
                    'Final da colheita': '25/03/2024',
                  },
                ),

                // Atalhos com IMAGEM LOCAL DE FUNDO
                _NavHeroCard(
                  label: 'Insumos',
                  route: '/insumos',
                  assetPath: _DashboardScreenState.kBgInsumos,
                  icon: Icons.inventory_2,
                ),
                _NavHeroCard(
                  label: 'Maquinários',
                  route: '/maquinarios',
                  assetPath: _DashboardScreenState.kBgMaquinarios,
                  icon: Icons.agriculture,
                ),
                _NavHeroCard(
                  label: 'Colaboradores',
                  route: '/colaboradores',
                  assetPath: _DashboardScreenState.kBgColaboradores,
                  icon: Icons.groups_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        children: const [
          SizedBox(width: 12),
          Icon(Icons.menu, color: Colors.black54),
          SizedBox(width: 8),
          Text(
            'Painel de controle',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: const [
        _OutlinedPillButton(label: 'Filtrar', icon: Icons.filter_list_rounded),
        SizedBox(width: 8),
        _OutlinedPillButton(label: 'Imprimir', icon: Icons.print_rounded),
        SizedBox(width: 12),
      ],
    );
  }
}

/* --------------------------- HEADER PANEL --------------------------- */

class _HeaderPanel extends StatelessWidget {
  const _HeaderPanel({required this.simulatorMode, required this.onChanged});

  final bool simulatorMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Quer fazer uma simulação com outros dados?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Modo Simulador',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: simulatorMode,
                  activeColor: const Color(0xFF2FA34A),
                  onChanged: onChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------- METRICS ----------------------------- */

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    this.primaryValue,
    this.primaryChipColor,
    this.primaryChipBorder,
    this.secondaryLabel,
    this.secondaryValue,
    this.items,
  });

  final String title;
  final String? primaryValue;
  final Color? primaryChipColor;
  final Color? primaryChipBorder;
  final String? secondaryLabel;
  final String? secondaryValue;
  final Map<String, String>? items;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: text.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            if (primaryValue != null && primaryChipColor == null)
              Text(
                primaryValue!,
                style: text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),

            if (primaryValue != null && primaryChipColor != null)
              Container(
                decoration: BoxDecoration(
                  color: primaryChipColor,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: primaryChipBorder ?? Colors.transparent,
                    width: 1.4,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: const Text(
                  'FINALIZADO',
                  style: TextStyle(
                    color: Color(0xFF2FA34A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

            if (secondaryLabel != null && secondaryValue != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _muted(secondaryLabel!, text),
                  Text(
                    secondaryValue!,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],

            if (items != null && items!.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...items!.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _muted(e.key, text),
                      Text(
                        e.value,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _muted(String text, TextTheme t) => Text(
    text,
    style: t.bodyMedium?.copyWith(
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    ),
  );
}

/* --------------------------- NAV HERO CARDS --------------------------- */

class _NavHeroCard extends StatelessWidget {
  const _NavHeroCard({
    required this.label,
    required this.route,
    required this.assetPath,
    required this.icon,
  });

  final String label;
  final String route;
  final String assetPath;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, route),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Imagem LOCAL
              Positioned.fill(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    // fallback caso o arquivo seja movido/renomeado
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Overlay escuro
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),
              // Badge
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5EA),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFF2FA34A),
                      width: 1.2,
                    ),
                  ),
                  child: const Text(
                    'Acessar',
                    style: TextStyle(
                      color: Color(0xFF2FA34A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              // Conteúdo
              Padding(
                padding: const EdgeInsets.all(18),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: const Color(0xFF2FA34A)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------------------------- OUTLINED BUTTON --------------------------- */

class _OutlinedPillButton extends StatelessWidget {
  const _OutlinedPillButton({
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed:
          onTap ??
          () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$label (demo)'))),
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
