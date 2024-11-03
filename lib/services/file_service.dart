import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'aut_service.dart';

class FileService {
  final logger = Logger();
  final _autService = GetIt.I.get<AutService>();

  Future<String?> uploadFile(String path, String type,
      {String docname = "new-initial-visit-1",
      String fieldname = "image1",
      bool retry = true}) async {
    try {
      final bytes = (await _compressFile(path)) ?? File(path).readAsBytesSync();
      var form = FormData();
      form.files.add(MapEntry('file',
          MultipartFile.fromBytes(bytes, filename: path.split("\\").last)));
      form.fields.add(MapEntry("is_private", "0"));
      form.fields.add(MapEntry("folder", "Home"));
      form.fields.add(MapEntry("doctype", type));
      form.fields.add(MapEntry("docname", docname));
      form.fields.add(MapEntry("fieldname", fieldname));
      var res = await Dio().post("https://icasp.ir/api/method/upload_file",
          data: form,
          options: Options(
            headers: {
              'cookie': await getCookie(),
            },
          ));
      return res.data["message"]["file_url"];
    } catch (e) {
      if (retry) {
        return uploadFile(path, type,
            docname: docname, fieldname: fieldname, retry: false);
      }
      logger.e(e);
    }
    return "";
  }

  Future<Uint8List?> _compressFile(String path) async {
    var result = await FlutterImageCompress.compressWithFile(
      path,
      format: CompressFormat.webp,
      minWidth: 300,
      minHeight: 400,
      quality: 70,
    );
    return result;
  }

  Future<String> getCookie() async {
    CookieJar cookieJar = CookieJar();
    var cookies =
        await cookieJar.loadForRequest(Uri.parse("https://icasp.ir/"));
    cookies.add(Cookie("full_name", "Administrator"));
    cookies.add(Cookie("sid", _autService.sid()));
    cookies.add(Cookie("system_user", "yes"));
    cookies.add(Cookie("user_id", "Administrator"));
    return CookieManager.getCookies(cookies);
  }
}
