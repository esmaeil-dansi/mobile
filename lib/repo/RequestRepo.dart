import 'package:frappe_app/db/dao/request_dao.dart';
import 'package:frappe_app/db/request.dart';
import 'package:get_it/get_it.dart';

class RequestRepo {
  final _requestDao = GetIt.I.get<RequestDao>();

  Future<List<Request>> getAll() async {
    return _requestDao.getAll();
  }

  Future<void> save(Request request) => _requestDao.save(request);

  Future<void> delete(Request request) => _requestDao.delete(request.time);
}