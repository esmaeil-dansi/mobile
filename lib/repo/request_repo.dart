import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:frappe_app/db/dao/request_dao.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/model/add_initial_visit_from_model.dart';
import 'package:frappe_app/model/add_per_vsiti_form_model.dart';
import 'package:frappe_app/model/add_vetvisit_form_model.dart';
import 'package:frappe_app/repo/file_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestRepo {
  final _requestDao = GetIt.I.get<RequestDao>();
  var _fileRepo = GetIt.I.get<FileRepo>();
  var _logger = Logger();

  Stream<List<Request>> watch() => _requestDao.watch();

  Future<Request?> getByNationIdAndType(String id, String type) =>
      _requestDao.getByNationIdAndType(id, type);

  Future<void> save(Request request) => _requestDao.save(request);

  Future<void> delete(Request request) => _requestDao.delete(request.time);

  Future<Request> saveFile(Request request) async {
    if (request.type == "Initial Visit") {
      var body = await _saveInitVisitFile(request.time,
          AddInitialVisitFormModel.fromJson(json.decode(request.body)));
      request.body = json.encode(body);
      return request;
    } else if (request.type == "Periodic visits") {
      var body = await _savePerFiles(request.time,
          AddPerVisitFormModel.fromJson(json.decode(request.body)));
      request.body = json.encode(body);
      return request;
    } else if (request.type == "Vet Visit") {
      var body = await _saveVetVistiFiles(request.time,
          AddVetVisitFormModel.fromJson(json.decode(request.body)));
      request.body = json.encode(body);
      return request;
    }
    return request;
  }

  Future<AddPerVisitFormModel> _savePerFiles(
      int time, AddPerVisitFormModel model) async {
    var jaigahDam = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "image_j", path: model.jaigahDam ?? model.image??"");
    if (jaigahDam != null) {
      model.jaigahDam = jaigahDam;
    }
    var jaigahDam1 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "image_j2", path: model.jaigahDam1 ?? "");
    if (jaigahDam1 != null) {
      model.jaigahDam1 = jaigahDam1;
    }
    var jaigahDam2 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "image_j3", path: model.jaigahDam2 ?? "");
    if (jaigahDam2 != null) {
      model.jaigahDam2 = jaigahDam2;
    }
    return model;
  }

  Future<AddVetVisitFormModel> _saveVetVistiFiles(
      int time, AddVetVisitFormModel model) async {
    var imageDam1 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "imageDam1", path: model.imageDam1 ?? "");
    if (imageDam1 != null) {
      model.imageDam1 = imageDam1;
    }
    var licenseSalamat = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "licenseSalamat", path: model.licenseSalamat ?? "");
    if (licenseSalamat != null) {
      model.licenseSalamat = licenseSalamat;
    }
    var imageDam2 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "imageDam2", path: model.imageDam2 ?? "");
    if (imageDam2 != null) {
      model.imageDam2 = imageDam2;
    }
    var imageDam3 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "imageDam3", path: model.imageDam3 ?? "");
    if (imageDam3 != null) {
      model.imageDam3 = imageDam3;
    }
    var imageDam = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "imageDam", path: model.imageDam ?? "");
    if (imageDam != null) {
      model.imageDam = imageDam;
    }
    return model;
  }

  Future<AddInitialVisitFormModel> _saveInitVisitFile(
      int time, AddInitialVisitFormModel model) async {
    var path = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "image1", path: model.image1 ?? "");
    if (path != null) {
      model.image1 = path;
    }

    var path2 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "image2", path: model.image2 ?? "");
    if (path2 != null) {
      model.image2 = path2;
    }

    var path3 = await _fileRepo.saveFileInDownloadDir(
        time: time, key: "image3", path: model.image3 ?? '');
    if (path2 != null) {
      model.image3 = path3;
    }
    return model;
  }

  Future<bool> backupRequests() async {
    try {
      var file = await _file();

      var requests = await _requestDao.getAllFailed();
      List<Request> updatedRequests = [];
      for (var req in requests) {
        req = await saveFile(req);
        updatedRequests.add(req);
      }
      if (updatedRequests.isNotEmpty) {
        var map = Map.fromIterable(updatedRequests,
            key: (v) => (v as Request).time.toString(),
            value: (r) => r.toJson());
        var jsonMap = json.encode(map);
        await (file)?.writeAsString(jsonMap);
      }
      return true;
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }

  Future<File?> _file() async {
    if (await _checkPermission()) {
      final path = "/storage/emulated/0/Download";
      await Directory('$path/chopo').create(recursive: true);
      return File('$path/chopo/requests.json');
    }
  }

  Future<bool> _checkPermission() async {
    try {
      if (Platform.isAndroid &&
          (await DeviceInfoPlugin().androidInfo).version.sdkInt > 29) {
        if ((await Permission.manageExternalStorage.isGranted)) {
          return true;
        } else {
          return (await Permission.manageExternalStorage.request()).isGranted;
        }
      } else {
        if ((await Permission.storage.isGranted)) {
          return true;
        } else {
          return (await Permission.storage.request()).isGranted;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> restoreRequests() async {
    try {
      Map<String, dynamic> map =
          jsonDecode(await (await _file())!.readAsString());
      map.forEach((key, value) {
        try {
          Request? request = Request.fromJson(value);
          if (request != null) {
            _requestDao.save(request);
          }
        } catch (e) {
          _logger.e(e);
        }
      });
    } catch (e) {
      _logger.e(e);
    }
  }
}
