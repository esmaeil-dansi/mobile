import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:logger/logger.dart';
import 'aut_service.dart';

class HttpService {
  var _logger = Logger();
  final _autService = GetIt.I.get<AutService>();
  final _dio = Dio(BaseOptions(baseUrl: "https://icasp.ir"));

  List<Cookie> cookies = [];

  HttpService() {
    _initCookie();
  }

  String getCookie() {
    cookies.clear();
    cookies.add(Cookie("system_user", "yes"));
    cookies.add(Cookie("sid", _autService.getSid()));
    cookies.add(Cookie("user_id", _autService.getUserId()));
    cookies.add(Cookie("full_name", _autService.getFullNameChar()));
    return CookieManager.getCookies(cookies);
  }

  Future<void> _initCookie() async {
    CookieJar cookieJar = CookieJar();
    cookies = await cookieJar.loadForRequest(Uri.parse("https://icasp.ir/"));
  }

  Future<Response<dynamic>?> post(String path, FormData data) async {
    return await _dio.post(path,
        data: data,
        options: Options(
          headers: {
            'cookie': getCookie(),
          },
        ));
  }

  Future<Response<dynamic>?> get(String path, FormData data) async {
    return await _dio.get(path,
        options: Options(
          headers: {
            'cookie': getCookie(),
          },
        ));
  }
}
