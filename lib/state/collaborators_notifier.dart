import 'package:flutter/foundation.dart';
import '../data/models/employee.dart';
import '../data/models/paginated.dart';
import '../data/repositories/collaborators_repository.dart';

class CollaboratorsNotifier extends ChangeNotifier {
  CollaboratorsNotifier(this._repo);

  final CollaboratorsRepository _repo;

  // estado
  List<Employee> items = [];
  int page = 1, pageSize = 20, total = 0;
  String? q;
  EmpStatus? status;
  bool isLoading = false;
  String? error;

  Future<void> load({int page = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final Paginated<Employee> res = await _repo.list(
        q: q,
        status: status,
        page: page,
        pageSize: pageSize,
        sort: 'name',
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

  void setStatus(EmpStatus? v) {
    status = v;
  }

  Future<void> create(Employee e) async {
    await _repo.create(e);
    await load(page: 1);
  }

  Future<void> update(String id, Employee e) async {
    await _repo.update(id, e);
    await load(page: this.page);
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    await load(page: 1);
  }
}
