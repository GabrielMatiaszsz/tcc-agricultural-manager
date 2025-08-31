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

InsumoStatus insumoStatusFrom(String? v) {
  switch (v) {
    case 'disponivel':
      return InsumoStatus.disponivel;
    case 'baixo':
      return InsumoStatus.baixo;
    case 'vencido':
      return InsumoStatus.vencido;
    default:
      return InsumoStatus.disponivel;
  }
}

String insumoStatusTo(InsumoStatus v) {
  switch (v) {
    case InsumoStatus.disponivel:
      return 'disponivel';
    case InsumoStatus.baixo:
      return 'baixo';
    case InsumoStatus.vencido:
      return 'vencido';
  }
}

InsumoTipo insumoTipoFrom(String? v) {
  switch (v) {
    case 'semente':
      return InsumoTipo.semente;
    case 'fertilizante':
      return InsumoTipo.fertilizante;
    case 'herbicida':
      return InsumoTipo.herbicida;
    case 'fungicida':
      return InsumoTipo.fungicida;
    case 'inseticida':
      return InsumoTipo.inseticida;
    case 'diesel':
      return InsumoTipo.diesel;
    case 'aduboFoliar':
      return InsumoTipo.aduboFoliar;
    case 'corretivo':
      return InsumoTipo.corretivo;
    default:
      return InsumoTipo.semente;
  }
}

String insumoTipoTo(InsumoTipo v) {
  switch (v) {
    case InsumoTipo.semente:
      return 'semente';
    case InsumoTipo.fertilizante:
      return 'fertilizante';
    case InsumoTipo.herbicida:
      return 'herbicida';
    case InsumoTipo.fungicida:
      return 'fungicida';
    case InsumoTipo.inseticida:
      return 'inseticida';
    case InsumoTipo.diesel:
      return 'diesel';
    case InsumoTipo.aduboFoliar:
      return 'aduboFoliar';
    case InsumoTipo.corretivo:
      return 'corretivo';
  }
}

class Insumo {
  final String id;
  final String nome;
  final InsumoTipo tipo;
  final String unidade;
  final double quantidade;
  final double minimo;
  final double custoUnit;
  final String fornecedor;
  final String local;
  final InsumoStatus status;
  final String? validade;
  final String? lote;
  final String? ultimoMov;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Insumo({
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
    this.validade,
    this.lote,
    this.ultimoMov,
    this.createdAt,
    this.updatedAt,
  });

  factory Insumo.fromJson(Map<String, dynamic> json) => Insumo(
    id: json['id'] as String,
    nome: json['nome'] as String? ?? '',
    tipo: insumoTipoFrom(json['tipo'] as String?),
    unidade: json['unidade'] as String? ?? '',
    quantidade: (json['quantidade'] as num?)?.toDouble() ?? 0,
    minimo: (json['minimo'] as num?)?.toDouble() ?? 0,
    custoUnit: (json['custo_unit'] as num?)?.toDouble() ?? 0,
    fornecedor: json['fornecedor'] as String? ?? '',
    local: json['local'] as String? ?? '',
    status: insumoStatusFrom(json['status'] as String?),
    validade: json['validade'] as String?,
    lote: json['lote'] as String?,
    ultimoMov: json['ultimo_mov'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
  );

  Map<String, dynamic> toPayload() => {
    'nome': nome,
    'tipo': insumoTipoTo(tipo),
    'unidade': unidade,
    'quantidade': quantidade,
    'minimo': minimo,
    'custo_unit': custoUnit,
    'fornecedor': fornecedor,
    'local': local,
    'status': insumoStatusTo(status),
    'validade': validade,
    'lote': lote,
    'ultimo_mov': ultimoMov,
  };
}
