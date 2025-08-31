import '../api_client.dart';
import '../models/paginated.dart';
import '../models/machine.dart';

class MachinesRepository {
  MachinesRepository(this._api);
  final ApiClient _api;

  Future<Paginated<Machine>> list({
    String? q,
    MachineStatus? status,
    MachineType? type,
    int page = 1,
    int pageSize = 20,
    String? sort, // ex.: "apelido,-created_at"
  }) async {
    final json =
        await _api.get(
              '/api/machines',
              query: {
                'q': q,
                'status': status == null ? null : machineStatusTo(status),
                'type': type == null ? null : machineTypeTo(type),
                'page': page,
                'page_size': pageSize,
                'sort': sort,
              },
            )
            as Map<String, dynamic>;

    return Paginated.fromJson<Machine>(json, (m) => Machine.fromJson(m));
  }

  Future<Machine> getById(String id) async {
    final json = await _api.get('/api/machines/$id') as Map<String, dynamic>;
    return Machine.fromJson(json);
  }

  Future<Machine> create(Machine payload) async {
    final json =
        await _api.post('/api/machines', body: payload.toPayload())
            as Map<String, dynamic>;
    return Machine.fromJson(json);
  }

  Future<Machine> update(String id, Machine payload) async {
    final json =
        await _api.patch('/api/machines/$id', body: payload.toPayload())
            as Map<String, dynamic>;
    return Machine.fromJson(json);
  }

  Future<void> delete(String id) => _api.delete('/api/machines/$id');
}
