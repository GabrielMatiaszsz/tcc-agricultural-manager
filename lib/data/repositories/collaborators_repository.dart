import '../api_client.dart';
import '../models/paginated.dart';
import '../models/employee.dart';

class CollaboratorsRepository {
  CollaboratorsRepository(this._api);
  final ApiClient _api;

  Future<Paginated<Employee>> list({
    String? q,
    EmpStatus? status,
    int page = 1,
    int pageSize = 20,
    String? sort, // ex.: "name,-created_at"
  }) async {
    final json =
        await _api.get(
              '/api/collaborators',
              query: {
                'q': q,
                'status': status == null ? null : empStatusTo(status),
                'page': page,
                'page_size': pageSize,
                'sort': sort,
              },
            )
            as Map<String, dynamic>;

    // uso correto do método estático:
    return Paginated.fromJson<Employee>(json, (m) => Employee.fromJson(m));
  }

  Future<Employee> getById(String id) async {
    final json =
        await _api.get('/api/collaborators/$id') as Map<String, dynamic>;
    return Employee.fromJson(json);
  }

  Future<Employee> create(Employee payload) async {
    final json =
        await _api.post('/api/collaborators', body: payload.toPayload())
            as Map<String, dynamic>;
    return Employee.fromJson(json);
  }

  Future<Employee> update(String id, Employee payload) async {
    final json =
        await _api.patch('/api/collaborators/$id', body: payload.toPayload())
            as Map<String, dynamic>;
    return Employee.fromJson(json);
  }

  Future<void> delete(String id) => _api.delete('/api/collaborators/$id');
}
