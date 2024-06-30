import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/SortKey.dart';
import 'package:frappe_app/model/add_initial_visit_from_model.dart';
import 'package:frappe_app/model/add_per_vsiti_form_model.dart';
import 'package:frappe_app/model/add_vetvisit_form_model.dart';
import 'package:frappe_app/model/agent.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/model/init_visit_Info.dart';
import 'package:frappe_app/model/periodic_visit_info_model.dart';
import 'package:frappe_app/model/report.dart';
import 'package:frappe_app/model/sort_dir.dart';
import 'package:frappe_app/model/vet_visit_info_model.dart';
import 'package:frappe_app/repo/RequestRepo.dart';
import 'package:frappe_app/repo/file_repo.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/city_utils.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../db/request.dart';
import '../db/request_statuse.dart';
import '../widgets/methodes.dart';
import 'aut_service.dart';

class VisitService {
  final _fileService = GetIt.I.get<FileService>();
  final _autService = GetIt.I.get<AutService>();
  final _httpService = GetIt.I.get<HttpService>();
  final _requestRepo = GetIt.I.get<RequestRepo>();
  final _fileRepo = GetIt.I.get<FileRepo>();
  var _logger = Logger();
  g.RxMap<String, String?> avgPrices = <String, String?>{}.obs;

  Future<void> fetchPricess() async {
    ["شتر پرواری", "گاو شیری", "جو دامی وارداتی", "گوسفند داشتی"]
        .forEach((element) async {
      try {
        var result = await _httpService
            .get("/api/method/get_market_price?item=$element");
        avgPrices[element] = result?.data["avg"].toString() ?? "";
      } catch (e) {
        _logger.e(e);
      }
    });
  }

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

  Future<AgentInfo?> getAgentInfo(String nationalCode) async {
    try {
      var result = await _httpService.post(
        "/api/method/frappe.client.validate_link",
        FormData.fromMap({
          "doctype": "Job applicant",
          "docname": nationalCode,
          "fields": json.encode([
            "full_name",
            "province",
            "city",
            "address",
            "mobile",
            "rahbar",
            "department"
          ])
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
      required SortKey sortKey,
      required SortDir sortDir,
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
            'order_by': '${sortKey.key} ${sortDir.name}',
            'start': start,
            'page_length': 50,
            'view': "List",
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
      required SortDir sortDir,
      required SortKey sortKey,
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
            'order_by': '${sortKey.key} ${sortDir.name}',
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
      required SortKey sortKey,
      required SortDir sortDir,
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
            'order_by': '${sortKey.key} ${sortDir.name}',
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
      required AddInitialVisitFormModel model,
      required int time}) async {
    var body = json.encode({
      "docstatus": 0,
      "doctype": "Initial Visit",
      "name": "new-initial-visit-1",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": _autService.getUserId(),
      "tarh": model.tarh,
      "dam": model.dam,
      "noe_dam": model.noeDam,
      "malekiyat": model.malekiyat,
      "vaziat": model.vaziat,
      "noe_jaygah": model.noeJaygah,
      "quality_water": model.qualityWater,
      "tamin_water": model.taminWater,
      "ajor_madani": model.ajorMadani,
      "sang_namak": model.sangNamak,
      "adavat": model.adavat,
      "kaf_jaygah": model.kafJaygah,
      "status": model.status,
      "sayeban": model.sayeban,
      "adam_hesar": model.adamHesar,
      "astarkeshi": model.astarkeshi,
      "mahal_negahdari": model.mahalNegahdari,
      "adam_abkhor": model.adamAbkhor,
      "adam_noor": model.adamNoor,
      "adam_tahvie": model.adamTahvie,
      "national_id": model.nationalId,
      "full_name": agentInfo.full_name,
      "province": agentInfo.province,
      "city": agentInfo.city,
      "address": agentInfo.address,
      "mobile": agentInfo.mobile,
      "rahbar": agentInfo.rahbar,
      "department": agentInfo.department,
      "image1": "",
      "eghdamat": model.eghdamat,
      "sayer": model.sayer,
      "v_date": model.vDate,
      "geolocation":
          "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${model.lon},${model.lat}]}}]}"
    });
    try {
      var newBody =
          await _uploadInitVisitFile(model.image1 ?? '', body, "image1");
      if (newBody != null) {
        newBody =
            await _uploadInitVisitFile(model.image2 ?? '', newBody, "image2");
        if (newBody != null) {
          var result = await _sendRequest(newBody);
          unawaited(_requestRepo.save(Request(
            filePaths: [model.image1 ?? '', model.image2 ?? ''],
            nationId: model.nationalId!,
            body: json.encode(model),
            time: time,
            type: "Initial Visit",
            status: result?.statusCode == 200
                ? RequestStatus.Success
                : RequestStatus.Pending,
          )));
          if (result?.statusCode == 200) {
            Fluttertoast.showToast(msg: "ثبت شد");
            return true;
          } else {
            _saveFile(model.image1!, "image1", time);
            _saveFile(model.image2!, "image2", time);
            Progressbar.dismiss();
            showErrorMessage(result?.data["_server_messages"]);
            return false;
          }
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
    _saveFile(model.image1!, "image1", time);
    _saveFile(model.image2!, "image2", time);
    unawaited(_requestRepo.save(Request(
      filePaths: [model.image1 ?? '', model.image2 ?? ''],
      body: json.encode(model),
      nationId: model.nationalId!,
      time: time,
      type: "Initial Visit",
      status: RequestStatus.Pending,
    )));
    return false;
  }

  // Future<bool> resendInitVisit(Request request) async {
  //   try {
  //     var newBody = await _uploadInitVisitFile(
  //         request.filePaths?.first ?? '', request.body);
  //     if (newBody != null) {
  //       var res = await _sendRequest(newBody);
  //       Progressbar.dismiss();
  //       if (res?.statusCode == 200) {
  //         return true;
  //       } else {
  //         showErrorToast(null);
  //       }
  //       return false;
  //     } else {
  //       Progressbar.dismiss();
  //     }
  //     return false;
  //   } on DioException catch (e) {
  //     Progressbar.dismiss();
  //     handleDioError(e, showInfo: false);
  //   } catch (e) {
  //     Progressbar.dismiss();
  //     showErrorToast(null);
  //   }
  //   return false;
  // }

  Future<String?> _uploadInitVisitFile(
      String path, String body, String key) async {
    try {
      if (path.isEmpty) {
        return body;
      }
      var image =
          await _fileService.uploadFile(path, "Initial Visit", fieldname: key);
      if (image != null) {
        var newBody = json.decode(body);
        newBody[key] = image;
        return json.encode(newBody);
      }
    } catch (e) {}
    return null;
  }

  Future<String?> _uploadPerVisitFile(String path, String body) async {
    try {
      if (path.isEmpty) {
        return body;
      }
      var image = await _fileService.uploadFile(path, "Periodic visits",
          fieldname: "jaigah_dam", docname: 'new-periodic-visits-1');
      if (image != null) {
        var newBody = json.decode(body);
        newBody["jaigah_dam"] = image;
        return json.encode(newBody);
      }
    } catch (e) {}
    return null;
  }

  Future<bool> reSendPeriodicVisitsRequest(Request request) async {
    try {
      var newBody = await _uploadPerVisitFile(
          request.filePaths?.first ?? '', request.body);
      if (newBody != null) {
        var res = await _sendRequest(newBody);
        Progressbar.dismiss();
        if (res?.statusCode == 200) {
          return true;
        } else {
          showErrorToast(null);
        }
        return false;
      } else {
        Progressbar.dismiss();
      }
      return false;
    } on DioException catch (e) {
      Progressbar.dismiss();
      handleDioError(e, showInfo: false);
    } catch (e) {
      Progressbar.dismiss();
      Future.delayed(Duration(milliseconds: 500), () {
        showErrorToast(null);
      });
    }
    return false;
  }

  Future<bool> sendPeriodicVisits(
      {required AddPerVisitFormModel addPerVisitFormModel,
      required AgentInfo agentInfo,
      required int time,
      required}) async {
    var body = json.encode({
      "docstatus": 0,
      "doctype": "Periodic visits",
      "name": "new-periodic-visits-1",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": _autService.getUserId(),
      "outbreak": addPerVisitFormModel.outbreak,
      "stable_condition": addPerVisitFormModel.stableCondition,
      "manger": addPerVisitFormModel.manger,
      "losses": addPerVisitFormModel.losses,
      "bazdid": addPerVisitFormModel.bazdid,
      "water": addPerVisitFormModel.water,
      "supply_situation": addPerVisitFormModel.supplySituation,
      "ventilation": addPerVisitFormModel.ventilation,
      "vaziat": addPerVisitFormModel.vaziat,
      "jaigah_dam": "",
      "full_name": agentInfo.full_name,
      "province": agentInfo.province,
      "city": agentInfo.city,
      "rahbar": agentInfo.rahbar,
      "department": agentInfo.department,
      "national_id": addPerVisitFormModel.nationalId,
      "geolocation":
          "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${addPerVisitFormModel.lon},${addPerVisitFormModel.lat}]}}]}",
      "date": addPerVisitFormModel.date,
      "next_date": addPerVisitFormModel.nextDate,
      "description_p": addPerVisitFormModel.description_p,
      "description_l": addPerVisitFormModel.description_l,
      "enheraf": addPerVisitFormModel.enheraf,
    });
    try {
      var newBody =
          await _uploadPerVisitFile(addPerVisitFormModel.image ?? '', body);
      if (newBody != null) {
        var res = await _httpService.post(
            "/api/method/frappe.desk.form.save.savedocs",
            FormData.fromMap({'doc': newBody, 'action': 'Save'}));
        unawaited(_requestRepo.save(Request(
            time: time,
            type: "Periodic visits",
            nationId: addPerVisitFormModel.nationalId!,
            filePaths: [addPerVisitFormModel.image!],
            status: res?.statusCode == 200
                ? RequestStatus.Success
                : RequestStatus.Pending,
            body: json.encode(addPerVisitFormModel))));

        if (res?.statusCode == 200) {
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        } else {
          _saveFile(addPerVisitFormModel.image!, "image", time);
          Progressbar.dismiss();
          showErrorMessage(res?.data["_server_messages"]);
          return false;
        }
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      handleDioError(e);
    } catch (e) {
      showErrorToast(null);
    }
    _saveFile(addPerVisitFormModel.image!, "image", time);
    unawaited(_requestRepo.save(Request(
        time: time,
        type: "Periodic visits",
        filePaths: [],
        nationId: addPerVisitFormModel.nationalId!,
        status: RequestStatus.Pending,
        body: json.encode(addPerVisitFormModel))));
    return false;
  }

  Future<bool> saveVetVisit(
      {required AddVetVisitFormModel model,
      required int time,
      required AgentInfo agentInfo}) async {
    var body = json.encode({
      "docstatus": 0,
      "doctype": "Vet Visit",
      "name": "new-vet-visit-1",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": _autService.getUserId(),
      "bime": model.bime,
      "pelak": model.pelak,
      "galleh": model.galleh,
      "types": model.types,
      "result": model.result,
      "name_damp": model.nameDamp,
      "code_n": model.codeN,
      "national_id_doc": model.nationalIdDoc,
      "rahbar": agentInfo.rahbar,
      "department": agentInfo.department,
      "pelak_az": model.pelakAz,
      "pelak_ta": model.pelakTa,
      "national_id": model.nationalId,
      "teeth_1": model.teeth1,
      "teeth_2": model.teeth2,
      "teeth_3": model.teeth3,
      "province": agentInfo.province,
      "city": agentInfo.city,
      "galle_d": model.galleD,
      "age": model.age,
      "name_1": agentInfo.name,
      "full_name": agentInfo.full_name,
      "address": agentInfo.address,
      "eye_1": model.eye1,
      "eye_2": model.eye2,
      "eye_3": model.eye3,
      "eye_4": model.eye4,
      "eye_5": model.eye5,
      "breth_1": model.breth1,
      "breth_2": model.breth2,
      "breth_3": model.breth2,
      "mucus_1": model.mucus1,
      "mucus_2": model.mucus2,
      "mucus_3": model.mucus3,
      "mucus_4": model.mucus4,
      "mucus_5": model.mucus5,
      "ear_1": model.eye1,
      "ear_2": model.eye2,
      "skin_1": model.skin1,
      "skin_2": model.skin2,
      "skin_3": model.skin3,
      "skin_4": model.skin4,
      "skin_5": model.skin5,
      "skin_6": model.skin6,
      "leech_1": model.leech1,
      "leech_2": model.leech2,
      "leech_3": model.leech3,
      "mouth_1": model.mouth1,
      "mouth_2": model.mouth2,
      "mouth_3": model.mouth3,
      "mouth_4": model.mouth4,
      "hoof_1": model.hoof1,
      "hoof_2": model.hoof2,
      "hoof_3": model.hoof3,
      "hoof_4": model.hoof4,
      "urine_1": model.urine1,
      "urine_2": model.urine2,
      "urine_3": model.urine3,
      "nodes_1": model.nodes1,
      "nodes_2": model.nodes2,
      "nodes_3": model.nodes3,
      "crown_1": model.crown1,
      "crown_2": model.crown2,
      "crown_3": model.crown3,
      "sole_1": model.sole1,
      "sole_2": model.sole2,
      "sole_3": model.sole3,
      "number": model.number,
      "image_dam": "",
      "license_salamat": "",
      "disapproval_reason": model.disapprovalReason,
      "geolocation":
          "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${model.lon},${model.lat}]}}]}"
    });
    try {
      var newBody = await _uploadVetVisitFiles(
          model.imageDam ?? '', model.licenseSalamat ?? '', body);
      if (newBody != null) {
        var res = await _sendRequest(newBody);
        unawaited(_requestRepo.save(Request(
            time: time,
            type: "Vet Visit",
            nationId: model.nationalId ?? '',
            filePaths: [],
            status: res?.statusCode == 200
                ? RequestStatus.Success
                : RequestStatus.Pending,
            body: json.encode(model))));
        if (res?.statusCode == 200) {
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        } else {
          _saveFile(model.imageDam!, "imageDam", time);
          _saveFile(model.licenseSalamat!, "licenseSalamat", time);
          Progressbar.dismiss();
          showErrorMessage(res?.data["_server_messages"]);
          return false;
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
    _saveFile(model.imageDam!, "imageDam", time);
    _saveFile(model.licenseSalamat!, "licenseSalamat", time);
    unawaited(_requestRepo.save(Request(
        time: time,
        nationId: model.nationalId ?? '',
        type: "Vet Visit",
        filePaths: [],
        status: RequestStatus.Pending,
        body: json.encode(model))));
    return false;
  }

  Future<bool> resendVetVisit(Request request) async {
    try {
      if (request.filePaths != null) {
        var body = await _uploadVetVisitFiles(request.filePaths?.first ?? '',
            request.filePaths?.last ?? '', request.body);
        if (body != null) {
          var res = await _sendRequest(body);
          Progressbar.dismiss();
          if (res?.statusCode == 200) {
            return true;
          } else {
            showErrorToast(null);
          }
          return false;
        }
        Progressbar.dismiss();
        return false;
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      handleDioError(e, showInfo: false);
    } catch (e) {
      Progressbar.dismiss();
      showErrorToast(null);
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

  Future<Response<dynamic>?> _sendRequest(String body) {
    return _httpService.postForm("/api/method/frappe.desk.form.save.savedocs",
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

  Future<InitVisitInfoModel?> getInitVisitInfo(String id) async {
    try {
      var result = await _httpService.get(
        "/api/method/frappe.desk.form.load.getdoc?doctype=Initial Visit&name=$id&_=1719422952988",
      );
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
      );
      return PeriodicVisitInfoModel.fromJson(result?.data["docs"][0]);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<VetVisitInfoModel?> getVetVisitInfo(String id) async {
    try {
      var result = await _httpService.get(
        "/api/method/frappe.desk.form.load.getdoc?doctype=Vet%20Visit&name=$id&_=171648547368",
      );
      return VetVisitInfoModel.fromJson(result?.data["docs"][0]);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<List<String>> getAnimalType(String type, {String q = ""}) async {
    try {
      var resul = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': 'Livestock breeds',
            'fields': json.encode([
              "`tabLivestock breeds`.`name`",
              "`tabLivestock breeds`.`owner`",
              "`tabLivestock breeds`.`creation`",
              "`tabLivestock breeds`.`modified`",
              "`tabLivestock breeds`.`modified_by`",
              "`tabLivestock breeds`.`_user_tags`",
              "`tabLivestock breeds`.`_comments`",
              "`tabLivestock breeds`.`_assign`",
              "`tabLivestock breeds`.`_liked_by`",
              "`tabLivestock breeds`.`docstatus`",
              "`tabLivestock breeds`.`idx`",
              "`tabLivestock breeds`.`dam_type`"
            ]),
            'filters': json.encode([
              ["Livestock breeds", "dam_type", "=", "$type"],
              ["Livestock breeds", "name", "like", "%$q%"]
            ]),
            'start': 0,
            'page_length': 20,
            'view': 'List',
            'group_by': '`tabLivestock breeds`.`name`',
            'with_comment_count': 1
          }));

      return (resul?.data["message"]["values"] as List<dynamic>)
          .map((e) => (e as List<dynamic>)[0].toString())
          .toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  void _saveFile(String path, String key, int time) {
    _fileRepo.saveFile(time: time, key: key, path: path);
  }

  List<SortKey> initVistiSortKeys() => [
        SortKey(title: "آخرین بروزرسانی", key: "`tabInitial Visit`.`modified`"),
        SortKey(title: "شناسه", key: "`tabInitial Visit`.`name`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabInitial Visit`.`creation`"),
        SortKey(title: "مکان یابی", key: "`tabInitial Visit`.`geolocation`")
      ];

  List<SortKey> periodicVistiSortKeys() => [
        SortKey(
            title: "آخرین بروزرسانی", key: "`tabPeriodic visits`.`modified`"),
        SortKey(title: "شناسه", key: "`tabPeriodic visits`.`name`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabPeriodic visits`.`creation`"),
        SortKey(title: "مکان یابی", key: "`tabPeriodic visits`.`geolocation`")
      ];

  List<SortKey> vetVistiSortKeys() => [
// SortKey(title: "موقعیت محلی", key: "`tabVet Visit`.`geolocation`"),
        SortKey(title: "آخرین بروزرسانی", key: "`tabVet Visit`.`modified`"),
        SortKey(title: "شناسه", key: "`tabVet Visit`.`name`"),
        SortKey(title: "تعداد", key: "`tabVet Visit`.`number`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabVet Visit`.`creation`"),
      ];
}
