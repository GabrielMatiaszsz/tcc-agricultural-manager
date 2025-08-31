import 'package:flutter/foundation.dart';
import '../data/models/insumo.dart';
import '../data/models/paginated.dart';
import '../data/repositories/insumos_repository.dart';

class InsumosNotifier extends ChangeNotifier {
  InsumosNotifier(this._repo);
  final InsumosRepository _repo;

  List<Insumo> items = [];
  int page = 1, pageSize = 20, total = 0;
  String? q;
  InsumoStatus? status;
  InsumoTipo? tipo;
  bool isLoading = false;
  String? error;

  Future<void> load({int page = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final Paginated<Insumo> res = await _repo.list(
        q: q,
        status: status,
        tipo: tipo,
        page: page,
        pageSize: pageSize,
        sort: 'nome',
      );
      this.page = res.page;
      pageSize = res.pageSize;
      total = res.total;
      items = res.items;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String? value) {
    q = (value ?? '').trim().isEmpty ? null : value!.trim();
  }

  void setStatus(InsumoStatus? v) => status = v;
  void setTipo(InsumoTipo? v) => tipo = v;

  Future<void> create(Insumo i) async {
    await _repo.create(i);
    await load(page: 1);
  }

  Future<void> update(String id, Insumo i) async {
    await _repo.update(id, i);
    await load(page: page);
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    await load(page: 1);
  }
}
