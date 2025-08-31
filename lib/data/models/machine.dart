enum MachineStatus { ativo, manutencao, inativo }

enum MachineType {
  trator,
  colheitadeira,
  pulverizador,
  semeadora,
  caminhao,
  retroescavadeira,
}

MachineStatus machineStatusFrom(String? v) {
  switch (v) {
    case 'ativo':
      return MachineStatus.ativo;
    case 'manutencao':
      return MachineStatus.manutencao;
    case 'inativo':
      return MachineStatus.inativo;
    default:
      return MachineStatus.ativo;
  }
}

String machineStatusTo(MachineStatus v) {
  switch (v) {
    case MachineStatus.ativo:
      return 'ativo';
    case MachineStatus.manutencao:
      return 'manutencao';
    case MachineStatus.inativo:
      return 'inativo';
  }
}

MachineType machineTypeFrom(String? v) {
  switch (v) {
    case 'trator':
      return MachineType.trator;
    case 'colheitadeira':
      return MachineType.colheitadeira;
    case 'pulverizador':
      return MachineType.pulverizador;
    case 'semeadora':
      return MachineType.semeadora;
    case 'caminhao':
      return MachineType.caminhao;
    case 'retroescavadeira':
      return MachineType.retroescavadeira;
    default:
      return MachineType.trator;
  }
}

String machineTypeTo(MachineType v) {
  switch (v) {
    case MachineType.trator:
      return 'trator';
    case MachineType.colheitadeira:
      return 'colheitadeira';
    case MachineType.pulverizador:
      return 'pulverizador';
    case MachineType.semeadora:
      return 'semeadora';
    case MachineType.caminhao:
      return 'caminhao';
    case MachineType.retroescavadeira:
      return 'retroescavadeira';
  }
}

class Machine {
  final String id;
  final String apelido;
  final MachineType type;
  final String modelo;
  final int ano;
  final int horas;
  final double custoHora;
  final String local;
  final MachineStatus status;
  final String? ultimaManutencao;
  final String? proximaManutencao;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Machine({
    required this.id,
    required this.apelido,
    required this.type,
    required this.modelo,
    required this.ano,
    required this.horas,
    required this.custoHora,
    required this.local,
    required this.status,
    this.ultimaManutencao,
    this.proximaManutencao,
    this.createdAt,
    this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) => Machine(
    id: json['id'] as String,
    apelido: json['apelido'] as String? ?? '',
    type: machineTypeFrom(json['type'] as String?),
    modelo: json['modelo'] as String? ?? '',
    ano: (json['ano'] as num?)?.toInt() ?? 0,
    horas: (json['horas'] as num?)?.toInt() ?? 0,
    custoHora: (json['custo_hora'] as num?)?.toDouble() ?? 0,
    local: json['local'] as String? ?? '',
    status: machineStatusFrom(json['status'] as String?),
    ultimaManutencao: json['ultima_manutencao'] as String?,
    proximaManutencao: json['proxima_manutencao'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
  );

  Map<String, dynamic> toPayload() => {
    'apelido': apelido,
    'type': machineTypeTo(type),
    'modelo': modelo,
    'ano': ano,
    'horas': horas,
    'custo_hora': custoHora,
    'local': local,
    'status': machineStatusTo(status),
    'ultima_manutencao': ultimaManutencao,
    'proxima_manutencao': proximaManutencao,
  };
}
