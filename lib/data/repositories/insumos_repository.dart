import '../api_client.dart';
import '../models/paginated.dart';
import '../models/insumo.dart';

class InsumosRepository {
  InsumosRepository(this._api);
  final ApiClient _api;

  Future<Paginated<Insumo>> list({
    String? q,
    InsumoStatus? status,
    InsumoTipo? tipo,
    int page = 1,
    int pageSize = 20,
    String? sort, // ex.: "nome,-created_at"
  }) async {
    final json =
        await _api.get(
              '/api/insumos',
              query: {
                'q': q,
                'status': status == null ? null : insumoStatusTo(status),
                'tipo': tipo == null ? null : insumoTipoTo(tipo),
                'page': page,
                'page_size': pageSize,
                'sort': sort,
              },
            )
            as Map<String, dynamic>;

    return Paginated.fromJson<Insumo>(json, (m) => Insumo.fromJson(m));
  }

  Future<Insumo> getById(String id) async {
    final json = await _api.get('/api/insumos/$id') as Map<String, dynamic>;
    return Insumo.fromJson(json);
  }

  Future<Insumo> create(Insumo payload) async {
    final json =
        await _api.post('/api/insumos', body: payload.toPayload())
            as Map<String, dynamic>;
    return Insumo.fromJson(json);
  }

  Future<Insumo> update(String id, Insumo payload) async {
    final json =
        await _api.patch('/api/insumos/$id', body: payload.toPayload())
            as Map<String, dynamic>;
    return Insumo.fromJson(json);
  }

  Future<void> delete(String id) => _api.delete('/api/insumos/$id');
}
