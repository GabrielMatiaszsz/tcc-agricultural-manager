import 'package:flutter/foundation.dart';
import '../data/models/machine.dart';
import '../data/models/paginated.dart';
import '../data/repositories/machines_repository.dart';

class MachinesNotifier extends ChangeNotifier {
  MachinesNotifier(this._repo);
  final MachinesRepository _repo;

  List<Machine> items = [];
  int page = 1, pageSize = 20, total = 0;
  String? q;
  MachineStatus? status;
  MachineType? type;
  bool isLoading = false;
  String? error;

  Future<void> load({int page = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final Paginated<Machine> res = await _repo.list(
        q: q,
        status: status,
        type: type,
        page: page,
        pageSize: pageSize,
        sort: 'apelido',
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

  void setStatus(MachineStatus? v) => status = v;
  void setType(MachineType? v) => type = v;

  Future<void> create(Machine m) async {
    await _repo.create(m);
    await load(page: 1);
  }

  Future<void> update(String id, Machine m) async {
    await _repo.update(id, m);
    await load(page: page);
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    await load(page: 1);
  }
}
