import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agent.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/model/init_visit_Info.dart';
import 'package:frappe_app/model/periodic_visit_info_model.dart';
import 'package:frappe_app/model/report.dart';
import 'package:frappe_app/model/vet_visit_info_model.dart';
import 'package:frappe_app/repo/RequestRepo.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/city_utils.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:latlong2/latlong.dart';

import '../db/request.dart';
import '../db/request_statuse.dart';
import '../widgets/methodes.dart';
import 'aut_service.dart';

class VisitService {
  final _fileService = GetIt.I.get<FileService>();
  final _autService = GetIt.I.get<AutService>();
  final _httpService = GetIt.I.get<HttpService>();
  final _requestRepo = GetIt.I.get<RequestRepo>();
  var _logger = Logger();

  Future<List<Agent>> getInitialAgents(String txt) async {
    return fetchAgents(txt: txt);
  }

  Future<List<Agent>> getPeriodicAgent(String txt) async {
    return fetchAgents(txt: txt, reference_doctype: "Periodic visits");
  }

  Future<List<Agent>> getVetVisitAgent(String txt) async {
    return fetchAgents(txt: txt, reference_doctype: "Vet Visit");
  }

  Future<List<String>> getDepartments(String txt) async {
    try {
      await _httpService.post(
          "/api/method/frappe.desk.search.search_link",
          FormData.fromMap({
            'txt': txt,
            'doctype': 'Department',
            'ignore_user_permissions': 0,
            'reference_doctype': 'Vet Visit'
          }));
      return [];
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<List<Agent>> fetchAgents(
      {String txt = "", String reference_doctype = 'Initial Visit'}) async {
    try {
      List<Agent> agents = [];
      var result = await _httpService.post(
          "/api/method/frappe.desk.search.search_link",
          FormData.fromMap({
            'txt': int.parse(txt),
            'doctype': 'Job applicant',
            'ignore_user_permissions': '0',
            'reference_doctype': reference_doctype
          }));

      for (var element in (result?.data["results"] as List<dynamic>)) {
        Agent? agent = Agent.fromJson(element);
        if (agent != null) {
          agents.add(agent);
        }
      }
      return agents;
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<void> fetchCities() async {
    try {
      // var result = await _httpService.get("");
    } catch (e) {}
  }

  Future<AgentInfo?> getAgentInfo(String nationalCode) async {
    try {
      var result = await _httpService.post(
        "/api/method/frappe.desk.link_preview.get_preview_data",
        FormData.fromMap({
          "doctype": "Job applicant",
          "docname": nationalCode,
        }),
      );
      var info = AgentInfo.fromJsom(result?.data["message"]);
      return info;
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<List<Report>> fetchInitialVisitReport(
      {int id = 0,
      String province = "",
      String city = "",
      int start = 0}) async {
    List<List<String>> filters = [];
    if (id != 0) {
      filters.add(["Initial Visit", "name", "like", "%$id%"]);
    }
    if (province.isNotEmpty) {
      filters.add(["Initial Visit", "province", "=", province]);
    }
    if (city.isNotEmpty) {
      filters.add(["Initial Visit", "city", "=", city]);
    }
    try {
      var reports = <Report>[];
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': "Initial Visit",
            'fields': json.encode([
              "`tabInitial Visit`.`name`",
              "`tabInitial Visit`.`owner`",
              "`tabInitial Visit`.`creation`",
              "`tabInitial Visit`.`modified`",
              "`tabInitial Visit`.`modified_by`",
              "`tabInitial Visit`.`_user_tags`",
              "`tabInitial Visit`.`_comments`",
              "`tabInitial Visit`.`_assign`",
              "`tabInitial Visit`.`_liked_by`",
              "`tabInitial Visit`.`docstatus`",
              "`tabInitial Visit`.`idx`",
              "`tabInitial Visit`.`full_name`",
              "`tabInitial Visit`.`province`",
              "`tabInitial Visit`.`city`",
              "`tabInitial Visit`.`v_date`",
              "`tabInitial Visit`.`tarh`",
              "`tabInitial Visit`.`dam`",
              "`tabInitial Visit`.`status`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabInitial Visit`.`modified` asc',
            'start': start,
            'page_length': 20,
            'view': "List",
            'group_by': '`tabInitial Visit`.`name`',
            'with_comment_count': 1
          }));

      for (var m in result!.data["message"]["values"]) {
        reports.add(Report.fromJson(m));
      }
      return reports;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<PeriodicReport>> fetchPeriodicReport(
      {int id = 0,
      int nationId = 0,
      String province = "",
      String city = "",
      int start = 0}) async {
    try {
      List<List<String>> filters = [];
      if (id != 0) {
        filters.add(["Periodic visits", "name", "like", "%$id%"]);
      }
      if (nationId > 0) {
        filters.add(["Periodic visits", "national_id", "like", "%$nationId%"]);
      }
      if (province.isNotEmpty) {
        filters.add(["Periodic visits", "province", "=", province]);
      }
      if (city.isNotEmpty) {
        filters.add(["Periodic visits", "city", "=", city]);
      }
      var reports = <PeriodicReport>[];
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': "Periodic visits",
            'fields': json.encode([
              "`tabPeriodic visits`.`name`",
              "`tabPeriodic visits`.`docstatus`",
              "`tabPeriodic visits`.`national_id`",
              "`tabPeriodic visits`.`full_name`",
              "`tabPeriodic visits`.`province`",
              "`tabPeriodic visits`.`city`",
              "`tabPeriodic visits`.`stable_condition`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabPeriodic visits`.`modified` desc',
            'start': 0,
            'page_length': 20,
            'view': "Report",
            'with_comment_count': 1
          }));

      for (var m in result!.data["message"]["values"]) {
        reports.add(PeriodicReport.fromJson(m));
      }
      return reports;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<VetVisitReport>> fetchVetVisitReport(
      {int id = 0,
      String province = "",
      String city = "",
      int start = 0}) async {
    try {
      List<List<String>> filters = [];
      if (id != 0) {
        filters.add(["Vet Visit", "name", "like", "%$id%"]);
      }

      if (province.isNotEmpty) {
        filters.add(["Vet Visit", "province", "=", province]);
      }
      if (city.isNotEmpty) {
        filters.add(["Vet Visit", "city", "=", city]);
      }
      var reports = <VetVisitReport>[];
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': "Vet Visit",
            'fields': json.encode([
              "`tabVet Visit`.`name`",
              "`tabVet Visit`.`owner`",
              "`tabVet Visit`.`creation`",
              "`tabVet Visit`.`modified`",
              "`tabVet Visit`.`modified_by`",
              "`tabVet Visit`.`_user_tags`",
              "`tabVet Visit`.`_comments`",
              "`tabVet Visit`.`_assign`",
              "`tabVet Visit`.`_liked_by`",
              "`tabVet Visit`.`docstatus`",
              "`tabVet Visit`.`idx`",
              "`tabVet Visit`.`name_damp`",
              "`tabVet Visit`.`galleh`",
              "`tabVet Visit`.`name_1`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabVet Visit`.`modified` DESC',
            'start': 0,
            'page_length': 20,
            'view': "List",
            'with_comment_count': 1
          }));

      for (var m in result!.data["message"]["values"]) {
        reports.add(VetVisitReport.fromJson(m));
      }
      return reports;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<bool> saveInitVisit(
      {required AgentInfo agentInfo,
      required String imagePath,
      required String tarh,
      required String nationId,
      required String noe_jaygah,
      required String quality_water,
      required String tamin_water,
      required String ajor_madani,
      required String sang_namak,
      required String adavat,
      required String kaf_jaygah,
      required int sayeban,
      required String date,
      required String status,
      required int adam_hesar,
      required int astarkeshi,
      required int mahal_negahdari,
      required int adam_abkhor,
      required int adam_noor,
      required int adam_tahvie,
      required String sayer,
      required String eghdamat,
      required int dam,
      required String noe_dam,
      required String malekiyat,
      required String vaziat,
      required LatLng latLng,
      required int time}) async {
    var body = json.encode({
      "docstatus": 0,
      "doctype": "Initial Visit",
      "name": "new-initial-visit-1",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": _autService.getUserId(),
      "tarh": tarh,
      "dam": dam,
      "noe_dam": noe_dam,
      "malekiyat": malekiyat,
      "vaziat": vaziat,
      "noe_jaygah": noe_jaygah,
      "quality_water": quality_water,
      "tamin_water": tamin_water,
      "ajor_madani": ajor_madani,
      "sang_namak": sang_namak,
      "adavat": adam_tahvie,
      "kaf_jaygah": kaf_jaygah,
      "status": status,
      "sayeban": sayeban,
      "adam_hesar": adam_hesar,
      "astarkeshi": astarkeshi,
      "mahal_negahdari": mahal_negahdari,
      "adam_abkhor": adam_abkhor,
      "adam_noor": adam_noor,
      "adam_tahvie": adam_tahvie,
      "national_id": nationId,
      "full_name": agentInfo.full_name,
      "province": agentInfo.province,
      "city": agentInfo.city,
      "address": agentInfo.address,
      "mobile": agentInfo.mobile,
      "rahbar": agentInfo.rahbar,
      "department": agentInfo.department,
      "image1": "",
      "eghdamat": eghdamat,
      "v_date": date,
      "geolocation":
          "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${latLng.longitude},${latLng.latitude}]}}]}"
    });
    try {
      var newBody = await _uploadInitVisitFile(imagePath, body);
      if (newBody != null) {
        var result = await _sendRequest(newBody);
        unawaited(_requestRepo.save(Request(
          filePaths: [imagePath],
          nationId: nationId,
          body: newBody,
          time: time,
          type: "Initial Visit",
          status: RequestStatus.Success,
        )));
        if (result?.statusCode == 200) {
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        }
      } else {
        Fluttertoast.showToast(msg: "خطایی رخ داده است.");
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      handleDioError(e);
    } catch (e) {
      showErrorToast(null);
    }
    unawaited(_requestRepo.save(Request(
      filePaths: [imagePath],
      body: body,
      nationId: nationId,
      time: time,
      type: "Initial Visit",
      status: RequestStatus.Pending,
    )));
    return false;
  }

  Future<bool> resendInitVisit(Request request) async {
    try {
      var newBody = await _uploadInitVisitFile(
          request.filePaths?.first ?? '', request.body);
      if (newBody != null) {
        _sendRequest(newBody);
      }
    } catch (e) {}
    return false;
  }

  Future<String?> _uploadInitVisitFile(String path, String body) async {
    try {
      if (path.isEmpty) {
        return body;
      }
      var image = await _fileService.uploadFile(path, "Initial Visit");
      if (image != null) {
        var newBody = json.decode(body);
        newBody["image1"] = image;
        return json.encode(newBody);
      }
    } catch (e) {}
    return null;
  }

  Future<bool> reSendPeriodicVisitsRequest(Request request) async {
    try {
      await _sendRequest(request.body);
      return true;
    } catch (e) {
      // showErrorToast(null);
    }
    return false;
  }

  Future<bool> sendPeriodicVisits(
      {required String outbreak,
      required String stable_condition,
      required String manger,
      required String losses,
      required String nationId,
      required String bazdid,
      required String water,
      required String supply_situation,
      required String ventilation,
      required String vaziat,
      required AgentInfo agentInfo,
      required String date,
      required String next_date,
      required LatLng latLng,
      required int time,
      required}) async {
    var body = json.encode({
      "docstatus": 0,
      "doctype": "Periodic visits",
      "name": "new-periodic-visits-1",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": _autService.getUserId(),
      "outbreak": outbreak,
      "stable_condition": stable_condition,
      "manger": manger,
      "losses": losses,
      "bazdid": bazdid,
      "water": water,
      "supply_situation": supply_situation,
      "ventilation": ventilation,
      "vaziat": vaziat,
      "full_name": agentInfo.full_name,
      "province": agentInfo.province,
      "city": agentInfo.city,
      "rahbar": agentInfo.rahbar,
      "department": agentInfo.department,
      "national_id": nationId,
      "geolocation_p":
          "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${latLng.longitude},${latLng.latitude}]}}]}",
      "date": date,
      "next_date": next_date,
    });
    try {
      var res = await _httpService.post(
          "/api/method/frappe.desk.form.save.savedocs",
          FormData.fromMap({'doc': body, 'action': 'Save'}));

      unawaited(_requestRepo.save(Request(
          time: time,
          type: "Periodic visits",
          nationId: nationId,
          filePaths: [],
          status: RequestStatus.Success,
          body: body)));

      if (res?.statusCode == 200) {
        Fluttertoast.showToast(msg: "ثبت شد");
        return true;
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      handleDioError(e);
    } catch (e) {
      showErrorToast(null);
    }
    unawaited(_requestRepo.save(Request(
        time: time,
        type: "Periodic visits",
        filePaths: [],
        nationId: nationId,
        status: RequestStatus.Pending,
        body: body)));
    return false;
  }

  Future<bool> saveVetVisit(
      {required int bime,
      required int pelak,
      required int galle_d,
      required int age,
      required String galleh,
      required String types,
      required String nationId,
      required String result,
      required String name_damp,
      required String code_n,
      required String national_id_doc,
      required String pelak_az,
      required String pelak_ta,
      required String disapproval_reason,
      required String image_dam,
      required String license_salamat,
      required int teeth_1,
      required int teeth_2,
      required int teeth_3,
      required int eye_1,
      required int eye_2,
      required int eye_3,
      required int eye_4,
      required int eye_5,
      required int breth_1,
      required int breth_2,
      required int breth_3,
      required int mucus_1,
      required int mucus_2,
      required int mucus_3,
      required int mucus_4,
      required int mucus_5,
      required int ear_1,
      required int ear_2,
      required int skin_1,
      required int skin_2,
      required int skin_3,
      required int skin_4,
      required int skin_5,
      required int skin_6,
      required int leech_1,
      required int leech_2,
      required int leech_3,
      required int mouth_1,
      required int mouth_2,
      required int mouth_3,
      required int mouth_4,
      required int hoof_1,
      required int hoof_2,
      required int hoof_3,
      required int hoof_4,
      required int urine_1,
      required int urine_2,
      required int urine_3,
      required int nodes_1,
      required int nodes_2,
      required String nodes_3,
      required int crown_1,
      required int crown_2,
      required int crown_3,
      required int sole_1,
      required int sole_2,
      required int sole_3,
      required int time,
      required int number,
      required AgentInfo agentInfo}) async {
    var body = json.encode({
      "docstatus": 0,
      "doctype": "Vet Visit",
      "name": "new-vet-visit-1",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": _autService.getUserId(),
      "bime": bime,
      "pelak": pelak,
      "galleh": galleh,
      "types": types,
      "result": result,
      "name_damp": name_damp,
      "code_n": code_n,
      "national_id_doc": national_id_doc,
      "rahbar": agentInfo.rahbar,
      "department": agentInfo.department,
      "pelak_az": pelak_az,
      "pelak_ta": pelak_ta,
      "national_id": nationId,
      "teeth_1": teeth_1,
      "teeth_2": teeth_2,
      "teeth_3": teeth_3,
      "province": agentInfo.province,
      "city": agentInfo.city,
      "galle_d": galle_d,
      "age": age,
      "name_1": agentInfo.name,
      "full_name": agentInfo.full_name,
      "address": agentInfo.address,
      "eye_1": eye_1,
      "eye_2": eye_2,
      "eye_3": eye_3,
      "eye_4": eye_4,
      "eye_5": eye_5,
      "breth_1": breth_1,
      "breth_2": breth_2,
      "breth_3": breth_3,
      "mucus_1": mucus_1,
      "mucus_2": mucus_2,
      "mucus_3": mucus_3,
      "mucus_4": mucus_4,
      "mucus_5": mucus_4,
      "ear_1": ear_1,
      "ear_2": ear_2,
      "skin_1": skin_1,
      "skin_2": skin_2,
      "skin_3": skin_3,
      "skin_4": skin_4,
      "skin_5": skin_5,
      "skin_6": skin_6,
      "leech_1": leech_1,
      "leech_2": leech_2,
      "leech_3": leech_3,
      "mouth_1": mouth_1,
      "mouth_2": mouth_2,
      "mouth_3": mouth_3,
      "mouth_4": mouth_4,
      "hoof_1": hoof_1,
      "hoof_2": hoof_2,
      "hoof_3": hoof_3,
      "hoof_4": hoof_4,
      "urine_1": urine_1,
      "urine_2": urine_2,
      "urine_3": urine_3,
      "nodes_1": nodes_1,
      "nodes_2": nodes_2,
      "nodes_3": nodes_3,
      "crown_1": crown_1,
      "crown_2": crown_2,
      "crown_3": crown_3,
      "sole_1": sole_1,
      "sole_2": sole_2,
      "sole_3": sole_3,
      "number": number,
      "image_dam": "",
      "license_salamat": "",
      "disapproval_reason": disapproval_reason
    });
    try {
      var newBody =
          await _uploadVetVisitFiles(image_dam, license_salamat, body);
      if (newBody != null) {
        var res = await _sendRequest(newBody);
        unawaited(_requestRepo.save(Request(
            time: time,
            type: "Vet Visit",
            nationId: nationId,
            filePaths: [license_salamat, image_dam],
            status: RequestStatus.Success,
            body: newBody)));
        if (res?.statusCode == 200) {
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        }
      } else {
        showErrorToast(null);
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      handleDioError(e);
    } catch (e) {
      showErrorToast(null);
    }
    unawaited(_requestRepo.save(Request(
        time: time,
        nationId: nationId,
        type: "Vet Visit",
        filePaths: [license_salamat, image_dam],
        status: RequestStatus.Pending,
        body: body)));
    return false;
  }

  Future<bool> resendVetVisit(Request request) async {
    try {
      if (request.filePaths != null) {
        var body = await _uploadVetVisitFiles(request.filePaths?.first ?? '',
            request.filePaths?.last ?? '', request.body);
        if (body != null) {
          await _sendRequest(body);
        }
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<String?> _uploadVetVisitFiles(
      String image_dam, String license_salamat, dynamic body) async {
    var newBody = json.decode(body);
    if (image_dam.isNotEmpty) {
      var image_dam_res = await _fileService.uploadFile(image_dam, "Vet Visit",
          fieldname: "image_dam", docname: "new-vet-visit-1");
      newBody["image_dam"] = image_dam_res;
    }
    if (license_salamat.isNotEmpty) {
      var license_salamat_res = await _fileService.uploadFile(
          license_salamat, "Vet Visit",
          fieldname: "license_salamat", docname: "new-vet-visit-1");
      newBody["license_salamat"] = license_salamat_res;
    }

    return json.encode(newBody);
  }

  Future<Response<dynamic>?> _sendRequest(String body) async {
    return await _httpService.post("/api/method/frappe.desk.form.save.savedocs",
        FormData.fromMap({'doc': body, 'action': 'Save'}));
  }

  Future<List<String>> searchInCity(String province, String city) async {
    try {
      List<List<String>> filters = [];
      if (province.isNotEmpty) {
        filters.add(["City", "province", "=", province]);
      }
      if (city.isNotEmpty) {
        filters.add(["City", "city_name", "like", "%$city%"]);
      }
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': 'City',
            'fields': json.encode([
              "`tabCity`.`name`",
              "`tabCity`.`owner`",
              "`tabCity`.`creation`",
              "`tabCity`.`modified`",
              "`tabCity`.`modified_by`",
              "`tabCity`.`_user_tags`",
              "`tabCity`.`_comments`",
              "`tabCity`.`_assign`",
              "`tabCity`.`_liked_by`",
              "`tabCity`.`docstatus`",
              "`tabCity`.`idx`",
              "`tabCity`.`city_name`",
              "`tabCity`.`province`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabCity`.`modified` DESC',
            'start': 0,
            'page_length': 100,
            'view': 'List',
            'group_by': '`tabCity`.`name`',
            'with_comment_count': 1
          }));
      return CityUtils.extract(result?.data["message"]["values"]);
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<InitVisitInfoModel?> getInitVisitInfo(int id) async {
    try {
      var result = await _httpService.get(
          "/api/method/frappe.desk.form.load.getdoc?doctype=Initial%20Visit&name=$id&_=1716470766443",
          FormData.fromMap(
              {"doctyp": "Initial Visit", "name": id, "_": 1716470766443}));
      return InitVisitInfoModel.fromJson(result?.data["docs"][0]);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<PeriodicVisitInfoModel?> getPeriodicVisitInfo(String id) async {
    try {
      var result = await _httpService.get(
          "/api/method/frappe.desk.form.load.getdoc?doctype=Periodic%20visits&name=$id&_=1716470766446",
          FormData.fromMap(
              {"doctype": "Periodic visits", "name": id, "_": 1716470766446}));
      return PeriodicVisitInfoModel.fromJson(result?.data["docs"][0]);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<VetVisitInfoModel?> getVetVisitInfo(int id) async {
    try {
      var result = await _httpService.get(
          "/api/method/frappe.desk.form.load.getdoc?doctype=Vet%20Visit&name=$id&_=171648547368",
          FormData.fromMap(
              {"doctype": "Vet Visit", "name": id, "_": 171648547368}));
      return VetVisitInfoModel.fromJson(result?.data["docs"][0]);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }
}
