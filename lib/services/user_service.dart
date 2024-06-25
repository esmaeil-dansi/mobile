import 'package:dio/dio.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class UserService {
  var _httpService = GetIt.I.get<HttpService>();
  var _logger = Logger();

  Future<void> fetchUserPermissions() async {
    try {
      var result = await _httpService.get("app/user-permission");
      _logger.i(result);
    } catch (e) {
      _logger.e(e);
    }
  }
}
