enum EmpStatus { ativo, inativo, convidado }

EmpStatus empStatusFrom(String? v) {
  switch (v) {
    case 'ativo':
      return EmpStatus.ativo;
    case 'inativo':
      return EmpStatus.inativo;
    case 'convidado':
      return EmpStatus.convidado;
    default:
      return EmpStatus.ativo;
  }
}

String empStatusTo(EmpStatus v) {
  switch (v) {
    case EmpStatus.ativo:
      return 'ativo';
    case EmpStatus.inativo:
      return 'inativo';
    case EmpStatus.convidado:
      return 'convidado';
  }
}

class Employee {
  final String id;
  final String name;
  final String role;
  final double salary;
  final String email;
  final String phone;
  final EmpStatus status;
  final String joinedText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
    required this.email,
    required this.phone,
    required this.status,
    required this.joinedText,
    this.createdAt,
    this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    role: json['role'] as String? ?? '',
    salary: (json['salary'] as num?)?.toDouble() ?? 0,
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    status: empStatusFrom(json['status'] as String?),
    joinedText: json['joined_text'] as String? ?? '',
    createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
  );

  /// Payload para create/update (não inclui `id`, datas)
  Map<String, dynamic> toPayload() => {
    'name': name,
    'role': role,
    'salary': salary,
    'email': email,
    'phone': phone,
    'status': empStatusTo(status),
    'joined_text': joinedText,
  };

  Employee copyWith({
    String? id,
    String? name,
    String? role,
    double? salary,
    String? email,
    String? phone,
    EmpStatus? status,
    String? joinedText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      salary: salary ?? this.salary,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      joinedText: joinedText ?? this.joinedText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
