import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'aut_service.dart';

class HttpService {
  final _autService = GetIt.I.get<AutService>();
  final _dio = Dio(BaseOptions(
    baseUrl: "https://icasp.ir",
    contentType: Headers.jsonContentType,
    validateStatus: (int? status) {
      return status != null;
      // return status != null && status >= 200 && status < 300;
    },
    receiveTimeout: const Duration(seconds: 20),
    connectTimeout: const Duration(seconds: 20),
  ));

  List<Cookie> cookies = [];

  HttpService() {
    _initCookie();
  }

  String getCookie() {
    cookies.clear();
    cookies.add(Cookie("system_user", "yes"));
    cookies.add(Cookie("sid", _autService.sid()));
    cookies.add(Cookie("user_id", _autService.getUserId()));
    cookies.add(Cookie("full_name", _autService.fullNameChar()));
    return CookieManager.getCookies(cookies);
  }

  Future<void> _initCookie() async {
    CookieJar cookieJar = CookieJar();
    cookies = await cookieJar.loadForRequest(Uri.parse("https://icasp.ir"));
  }

  Future<Response<dynamic>?> postForm(String path, FormData data,
      {Map<String, dynamic>? map}) async {
    return _dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          "cookie": getCookie(),
          // 'X-Frappe-Csrf-Token':
          //     "80b201c014cd400bbc4c5e6b197a68e473a2a7ad56366c36d71f71c0",
          // 'Origin': "https://icasp.ir",
          // 'Host': "icasp.ir",
        },
      ),
    );
  }

  Future<Response<dynamic>?> post(String path, FormData data,
      {Map<String, dynamic>? map}) async {
    Map<String, dynamic> ma = {};

    data.fields.forEach((element) {
      ma[element.key] = element.value;
    });

    return _dio.post(path,
        data: data,
        options: Options(
          headers: {
            "cookie": getCookie(),
            'X-Frappe-Csrf-Token':
                "2690da8ad105a01afdfe5bfced0c3b6ed780811c69bf9ed6362855b4",
            'Origin': "https://icasp.ir",
            'Host': "icasp.ir",
          },
        ),
        queryParameters: ma);
  }

  Future<Response<dynamic>?> postFormData(String path, dynamic data,
      {Map<String, dynamic>? map}) async {
    return _dio.post(path,
        data: data,
        options: Options(
          headers: {
            "cookie": getCookie(),
            'X-Frappe-Csrf-Token':
                "80b201c014cd400bbc4c5e6b197a68e473a2a7ad56366c36d71f71c0",
            'Origin': "https://icasp.ir",
            'Host': "icasp.ir",
          },
        ));
  }

  Future<Response<dynamic>?> get(String path) async {
    return await _dio.get(path,
        options: Options(
          headers: {
            'cookie': await getCookie(),
          },
        ));
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    final isValid = status != null && status >= 200 && status < 300;
    if (!isValid) {
      throw DioException.badResponse(
        statusCode: status!,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
    super.onResponse(response, handler);
  }
}
