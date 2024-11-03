import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/dao/price_dao.dart';
import 'package:frappe_app/db/price_avg.dart';
import 'package:frappe_app/model/SortKey.dart';
import 'package:frappe_app/model/add_initial_visit_from_model.dart';
import 'package:frappe_app/model/add_per_vsiti_form_model.dart';
import 'package:frappe_app/model/add_product_form_model.dart';
import 'package:frappe_app/model/add_vetvisit_form_model.dart';
import 'package:frappe_app/model/agent.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/model/init_visit_Info.dart';
import 'package:frappe_app/model/periodic_visit_info_model.dart';
import 'package:frappe_app/model/product_report_model.dart';
import 'package:frappe_app/model/report.dart';
import 'package:frappe_app/model/sort_dir.dart';
import 'package:frappe_app/model/vet_visit_info_model.dart';
import 'package:frappe_app/repo/request_repo.dart';
import 'package:frappe_app/repo/file_repo.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:frappe_app/utils/city_utils.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../db/request.dart';
import '../db/request_statuse.dart';
import '../widgets/methodes.dart';
import 'aut_service.dart';

class VisitService {
  var _shared = GetIt.I.get<SharedPreferencesHelper>();
  final _fileService = GetIt.I.get<FileService>();
  final _autService = GetIt.I.get<AutService>();
  final _httpService = GetIt.I.get<HttpService>();
  final _requestRepo = GetIt.I.get<RequestRepo>();
  final _priceDao = GetIt.I.get<PriceAvgDao>();
  final _fileRepo = GetIt.I.get<FileRepo>();
  var _logger = Logger();

  Map<String, String> prices = {
    "SHOTOR": "شتر پرواری",
    "GOV": "گاو شیری",
    "GO": "جو دامی وارداتی",
    "GOSFAND": "گوسفند داشتی"
  };

  Future<void> fetchPrices() async {
    var time = _shared.getInt(LAST_FETCH_AVG_PRICE_TIME);
    if (time == null ||
        DateTime.now().millisecondsSinceEpoch - time > 24 * 60 * 60 * 1000) {
      var np = await _fetch();
      savePrice(np);
    }
  }

  Future<Map<String, int>> _fetch() async {
    Map<String, int> p = {};
    for (var m in prices.keys) {
      try {
        var result = await _httpService
            .get("/api/method/get_market_price?item=${prices[m]}");
        p[m] = (result?.data["avg"] ?? 0);
        _shared.setInt(
            LAST_FETCH_AVG_PRICE_TIME, DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        _logger.e(e);
      }
    }
    return p;
  }

  Future<void> savePrice(Map<String, int> s) async {
    try {
      var oldP = await _priceDao.getMainPrice();
      var newP = PriceAvg(
          shotor: (s["SHOTOR"] ?? oldP?.shotor) ?? 0,
          go: (s["GO"] ?? oldP?.go) ?? 0,
          gosfand: (s["GOSFAND"] ?? oldP?.gosfand) ?? 0,
          gov: (s["GOV"] ?? oldP?.gov) ?? 0);
      _priceDao.save(newP);
    } catch (e) {
      _logger.e(e);
    }
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
      return info..nationId = nationalCode;
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<List<ProductReportModel>> fetchProductVisitReport(
      {String id = "",
      required SortKey sortKey,
      required SortDir sortDir,
      int start = 0}) async {
    List<List<String>> filters = [];
    if (id.isNotEmpty) {
      filters.add(["Productivity File", "name", "like", "%$id%"]);
    }
    // if (province.isNotEmpty) {
    //   filters.add(["Initial Visit", "province", "=", province]);
    // }
    // if (city.isNotEmpty) {
    //   filters.add(["Initial Visit", "city", "=", city]);
    // }
    try {
      var reports = <ProductReportModel>[];
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': "Productivity File",
            'fields': json.encode([
              "`tabProductivity File`.`name`",
              "`tabProductivity File`.`owner`",
              "`tabProductivity File`.`creation`",
              "`tabProductivity File`.`modified`",
              "`tabProductivity File`.`modified_by`",
              "`tabProductivity File`.`_user_tags`",
              "`tabProductivity File`.`_comments`",
              "`tabProductivity File`.`_assign`",
              "`tabProductivity File`.`_liked_by`",
              "`tabProductivity File`.`docstatus`",
              "`tabProductivity File`.`idx`",
              "`tabProductivity File`.`id`",
              "`tabProductivity File`.`province`",
              "`tabProductivity File`.`last_name`"
            ]),
            'filters': json.encode(filters),
            'order_by': '${sortKey.key} ${sortDir.name}',
            'start': start,
            'page_length': 50,
            'view': "List",
            'with_comment_count': 1
          }));

      for (var m in result!.data["message"]["values"]) {
        reports.add(ProductReportModel.fromJson(m));
      }
      return reports;
    } catch (e) {
      print(e);
    }
    return [];
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
    model.owner = _autService.getUserId();
    model.rahbar = agentInfo.rahbar;
    model.city = agentInfo.city;
    model.province = agentInfo.province;
    model.mobile = agentInfo.mobile;
    model.fullName = agentInfo.full_name;
    model.address = agentInfo.address;
    model.department = agentInfo.department;
    var body = json.encode(model.toJson());
    try {
      if (model.image1 != null) {
        body = await _uploadInitVisitFile(model.image1 ?? '', body, "image1") ??
            body;
      }
      if (model.image2 != null) {
        body = await _uploadInitVisitFile(model.image2 ?? '', body, "image2") ??
            body;
      }
      if (model.image3 != null) {
        body = await _uploadInitVisitFile(model.image3 ?? '', body, "image3") ??
            body;
      }
      var result = await _sendRequest(body);
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
        sendUserTag(nationalId: model.nationalId ?? "", type: "Initial Visit");
        Fluttertoast.showToast(msg: "ثبت شد");
        return true;
      } else {
        await _saveInitVisitFile(time, model);
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
        Progressbar.dismiss();
        showErrorMessage(result?.data["_server_messages"]);
        return false;
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      Future.delayed(Duration(milliseconds: 800), () {
        handleDioError(e);
      });
    } catch (e) {
      showErrorToast(null);
    }
    await _saveInitVisitFile(time, model);

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

  Future<void> _saveInitVisitFile(
      int time, AddInitialVisitFormModel model) async {
    if (model.image1 != null) {
      var path = await _fileRepo.saveFile(
          time: time, key: "image1", path: model.image1!);
      if (path != null) {
        model.image1 = path;
      }
    }
    if (model.image2 != null) {
      var path2 = await _fileRepo.saveFile(
          time: time, key: "image2", path: model.image2!);
      if (path2 != null) {
        model.image2 = path2;
      }
    }
    if (model.image3 != null) {
      var path3 = await _fileRepo.saveFile(
          time: time, key: "image3", path: model.image3!);
      if (path3 != null) {
        model.image3 = path3;
      }
    }
  }

  Future<void> _savePerVisitFile(int time, AddPerVisitFormModel model) async {
    if (model.image != null) {
      var path = await _fileRepo.saveFile(
          time: time, key: "image2", path: model.image!);
      if (path != null) {
        model.jaigahDam = path;
      }
    }
    if (model.jaigahDam != null) {
      var path = await _fileRepo.saveFile(
          time: time, key: "jaigahDam", path: model.jaigahDam!);
      if (path != null) {
        model.jaigahDam = path;
      }
    }
    if (model.jaigahDam1 != null) {
      var path2 = await _fileRepo.saveFile(
          time: time, key: "jaigahDam1", path: model.jaigahDam1!);
      if (path2 != null) {
        model.jaigahDam1 = path2;
      }
    }
    if (model.jaigahDam2 != null) {
      var path3 = await _fileRepo.saveFile(
          time: time, key: "jaigahDam2", path: model.jaigahDam2!);
      if (path3 != null) {
        model.jaigahDam2 = path3;
      }
    }
  }

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

  Future<String?> _uploadPerVisitFile(
      String path, String body, String key) async {
    try {
      if (path.isEmpty) {
        return body;
      }
      var image = await _fileService.uploadFile(path, "Periodic visits",
          fieldname: key, docname: 'new-periodic-visits-1');
      if (image != null) {
        var newBody = json.decode(body);
        newBody[key] = image;
        return json.encode(newBody);
      }
    } catch (e) {}
    return null;
  }

  Future<bool> sendPeriodicVisits(
      {required AddPerVisitFormModel addPerVisitFormModel,
      required int time,
      required}) async {
    var body = json.encode(addPerVisitFormModel);
    try {
      addPerVisitFormModel.owner = _autService.getUserId();
      var updated = body;
      if (addPerVisitFormModel.image != null &&
          addPerVisitFormModel.image!.isNotEmpty) {
        updated = await _uploadPerVisitFile(
                addPerVisitFormModel.image ?? '', body, "jaigah_dam") ??
            body;
      }
      var updated1 = await _uploadPerVisitFile(
              addPerVisitFormModel.jaigahDam ?? '', updated, "jaigah_dam") ??
          updated;
      var updated2 = await _uploadPerVisitFile(
              addPerVisitFormModel.jaigahDam1 ?? '', updated1, "jaigah_dam1") ??
          updated1;
      var updated3 = await _uploadPerVisitFile(
              addPerVisitFormModel.jaigahDam2 ?? '', updated2, "jaigah_dam2") ??
          updated2;
      var res = await _sendRequest(updated3);
      unawaited(_requestRepo.save(Request(
          time: time,
          type: "Periodic visits",
          nationId: addPerVisitFormModel.nationalId!,
          filePaths: [],
          status: res?.statusCode == 200
              ? RequestStatus.Success
              : RequestStatus.Pending,
          body: json.encode(addPerVisitFormModel))));

      if (res?.statusCode == 200) {
        sendUserTag(
            nationalId: addPerVisitFormModel.nationalId ?? "",
            type: "Periodic visits");
        Fluttertoast.showToast(msg: "ثبت شد");
        return true;
      } else {
        _savePerVisitFile(time, addPerVisitFormModel);
        unawaited(_requestRepo.save(Request(
            time: time,
            type: "Periodic visits",
            nationId: addPerVisitFormModel.nationalId!,
            filePaths: [],
            status: res?.statusCode == 200
                ? RequestStatus.Success
                : RequestStatus.Pending,
            body: json.encode(addPerVisitFormModel))));
        Progressbar.dismiss();
        showErrorMessage(res?.data["_server_messages"]);
        return false;
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      Future.delayed(Duration(milliseconds: 1000), () {
        handleDioError(e);
      });
    } catch (e) {
      Progressbar.dismiss();
      showErrorToast(null);
    }
    _savePerVisitFile(time, addPerVisitFormModel);
    unawaited(_requestRepo.save(Request(
        time: time,
        type: "Periodic visits",
        filePaths: [],
        nationId: addPerVisitFormModel.nationalId!,
        status: RequestStatus.Pending,
        body: json.encode(addPerVisitFormModel))));
    return false;
  }

  Future<String?> _uploadProductFile(String path, String fieldName) async {
    try {
      var res = await _fileService.uploadFile(path, "Productivity File",
          docname: "new-productivity-file-1", fieldname: fieldName);
      if (res != null && res.isNotEmpty) {
        return res;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> sendProductFrom(
      {required ProductivityFormModel model, required int time}) async {
    ProductivityFormModel baseModel = model;
    bool errorInUploadFile = false;
    model.owner = _autService.getUserId();
    try {
      if ((model.antro1Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.antro1Img!, "iromaction_img");
        if (s != null) {
          model.antro1Img = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.antro2Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.antro2Img!, "antro2Img");
        if (s != null) {
          model.antro2Img = s;
        } else {
          errorInUploadFile = true;
        }
      }
      if ((model.sharbonImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.sharbonImg!, "sharbonImg");
        if (s != null) {
          model.sharbonImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.abeleImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.abeleImg!, "abeleImg");
        if (s != null) {
          model.abeleImg = s;
        } else {
          errorInUploadFile = true;
        }
      }
      if ((model.brucellosisImg ?? "").isNotEmpty) {
        var s =
            await _uploadProductFile(model.brucellosisImg!, "brucellosisImg");
        if (s != null) {
          model.brucellosisImg = s;
        } else {
          errorInUploadFile = true;
        }
      }
      if ((model.sharbon1Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.sharbon1Img!, "sharbon1Img");
        if (s != null) {
          model.sharbon1Img = s;
        } else {
          errorInUploadFile = true;
        }
      }
      if ((model.taonImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.taonImg!, "taonImg");
        if (s != null) {
          model.taonImg = s;
        } else {
          errorInUploadFile = true;
        }
      }
      if ((model.pasteuroseImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.pasteuroseImg!, "pasteuroseImg");
        if (s != null) {
          model.pasteuroseImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.barfakiImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.barfakiImg!, "barfakiImg");
        if (s != null) {
          model.barfakiImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.agalacciImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.agalacciImg!, "agalacciImg");
        if (s != null) {
          model.agalacciImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.antiparaTabImg ?? "").isNotEmpty) {
        var s =
            await _uploadProductFile(model.antiparaTabImg!, "antiparaTabImg");
        if (s != null) {
          model.antiparaTabImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.froblokImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.froblokImg!, "barfakiImg");
        if (s != null) {
          model.froblokImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.somchiniImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.somchiniImg!, "somchiniImg");
        if (s != null) {
          model.somchiniImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.ghochandaziImg ?? "").isNotEmpty) {
        var s =
            await _uploadProductFile(model.ghochandaziImg!, "ghochandaziImg");
        if (s != null) {
          model.ghochandaziImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.pashm2Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.pashm2Img!, "pashm2Img");
        if (s != null) {
          model.pashm2Img = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.ghochImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.ghochImg!, "ghochImg");
        if (s != null) {
          model.ghochImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.pashmImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.pashmImg!, "pashmImg");
        if (s != null) {
          model.pashmImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.iromactionImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.iromactionImg!, "iromactionImg");
        if (s != null) {
          model.iromactionImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.spraying1Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.spraying1Img!, "iromactionImg");
        if (s != null) {
          model.spraying1Img = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.spraying2Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.spraying2Img!, "spraying2Img");
        if (s != null) {
          model.spraying2Img = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.iverImg ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.iverImg!, "iverImg");
        if (s != null) {
          model.iverImg = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if ((model.iver2Img ?? "").isNotEmpty) {
        var s = await _uploadProductFile(model.iver2Img!, "iver2Img");
        if (s != null) {
          model.iver2Img = s;
        } else {
          errorInUploadFile = true;
        }
      }

      if (!errorInUploadFile) {
        var res = await _sendRequest(json.encode(model));
        unawaited(_requestRepo.save(Request(
            time: time,
            type: "Product",
            nationId: model.nationalId!,
            filePaths: [],
            status: res?.statusCode == 200
                ? RequestStatus.Success
                : RequestStatus.Pending,
            body: json.encode(baseModel))));

        if (res?.statusCode == 200) {
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        } else {
          _saveProductFile(baseModel, time).then((value) {
            unawaited(_requestRepo.save(Request(
                time: time,
                type: "Product",
                nationId: model.nationalId!,
                filePaths: [],
                status: RequestStatus.Pending,
                body: json.encode(baseModel))));
          });
          Progressbar.dismiss();
          showErrorMessage(res?.data["_server_messages"]);
          return false;
        }
      } else {
        Progressbar.dismiss();
        _saveProductFile(baseModel, time).then((value) {
          unawaited(_requestRepo.save(Request(
              time: time,
              type: "Product",
              nationId: model.nationalId!,
              filePaths: [],
              status: RequestStatus.Pending,
              body: json.encode(baseModel))));
        });
        Future.delayed(Duration(milliseconds: 700), () {
          handleDioError(DioException.connectionError(
              requestOptions: RequestOptions(), reason: "reason"));
        });
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      Future.delayed(Duration(milliseconds: 1000), () {
        handleDioError(e);
      });
    } catch (e) {
      Progressbar.dismiss();
      showErrorToast(null);
    }
    _saveProductFile(baseModel, time).then((value) {
      unawaited(_requestRepo.save(Request(
          time: time,
          type: "Product",
          nationId: model.nationalId!,
          filePaths: [],
          status: RequestStatus.Pending,
          body: json.encode(baseModel))));
    });
    unawaited(_requestRepo.save(Request(
        time: time,
        type: "Periodic visits",
        filePaths: [],
        nationId: model.nationalId!,
        status: RequestStatus.Pending,
        body: json.encode(baseModel))));
    return false;
  }

  Future<void> _saveProductFile(ProductivityFormModel model, int time) async {
    if ((model.antro1Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "antro1Img", path: model.antro1Img!);
      if (s != null) {
        model.antro1Img = s;
      }
    }

    if ((model.antro2Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "antro2Img", path: model.antro2Img!);
      if (s != null) {
        model.antro2Img = s;
      }
    }
    if ((model.sharbonImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "sharbonImg", path: model.sharbonImg!);
      if (s != null) {
        model.sharbonImg = s;
      }
    }

    if ((model.abeleImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "abeleImg", path: model.abeleImg!);
      if (s != null) {
        model.abeleImg = s;
      }
    }
    if ((model.brucellosisImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "brucellosisImg", path: model.brucellosisImg!);
      if (s != null) {
        model.brucellosisImg = s;
      }
    }
    if ((model.sharbon1Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "sharbon1Img", path: model.sharbon1Img!);
      if (s != null) {
        model.sharbon1Img = s;
      }
    }
    if ((model.taonImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "taonImg", path: model.taonImg!);
      if (s != null) {
        model.taonImg = s;
      }
    }
    if ((model.pasteuroseImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "pasteuroseImg", path: model.pasteuroseImg!);
      if (s != null) {
        model.pasteuroseImg = s;
      }
    }

    if ((model.barfakiImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "barfakiImg", path: model.barfakiImg!);
      if (s != null) {
        model.barfakiImg = s;
      }
    }

    if ((model.agalacciImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "agalacciImg", path: model.agalacciImg!);
      if (s != null) {
        model.agalacciImg = s;
      }
    }

    if ((model.antiparaTabImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "antiparaTabImg", path: model.antiparaTabImg!);
      if (s != null) {
        model.antiparaTabImg = s;
      }
    }

    if ((model.froblokImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "froblokImg", path: model.froblokImg!);
      if (s != null) {
        model.froblokImg = s;
      }
    }

    if ((model.somchiniImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "somchiniImg", path: model.somchiniImg!);
      if (s != null) {
        model.somchiniImg = s;
      }
    }

    if ((model.ghochandaziImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "ghochandaziImg", path: model.ghochandaziImg!);
      if (s != null) {
        model.ghochandaziImg = s;
      }
    }

    if ((model.pashm2Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "pashm2Img", path: model.pashm2Img!);
      if (s != null) {
        model.pashm2Img = s;
      }
    }

    if ((model.ghochImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "ghochImg", path: model.ghochImg!);
      if (s != null) {
        model.ghochImg = s;
      }
    }

    if ((model.pashmImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "pashmImg", path: model.pashmImg!);
      if (s != null) {
        model.pashmImg = s;
      }
    }

    if ((model.iromactionImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "iromactionImg", path: model.iromactionImg!);
      if (s != null) {
        model.iromactionImg = s;
      }
    }

    if ((model.spraying1Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "spraying1Img", path: model.spraying1Img!);
      if (s != null) {
        model.spraying1Img = s;
      }
    }

    if ((model.spraying2Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "spraying2Img", path: model.spraying2Img!);
      if (s != null) {
        model.spraying2Img = s;
      }
    }

    if ((model.iverImg ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "iverImg", path: model.iverImg!);
      if (s != null) {
        model.iverImg = s;
      }
    }

    if ((model.iver2Img ?? "").isNotEmpty) {
      var s = await _fileRepo.saveFile(
          time: time, key: "iver2Img", path: model.iver2Img!);
      if (s != null) {
        model.iver2Img = s;
      }
    }
  }

  Future<bool> saveVetVisit(
      {required AddVetVisitFormModel model,
      required int time,
      required AgentInfo agentInfo}) async {
    model.rahbar = agentInfo.rahbar;
    model.department = agentInfo.department;
    model.fullName = agentInfo.full_name;
    model.name1 = agentInfo.name;
    model.province = agentInfo.province;
    model.address = agentInfo.address;
    model.owner = _autService.getUserId();
    var body = json.encode(model.toJson());
    try {
      var newBody = await _uploadVetVisitFiles(model, body);
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
          sendUserTag(nationalId: agentInfo.nationId, type: "Vet Visit");
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        } else {
          await _saveVetVistiFiles(time, model);
          unawaited(_requestRepo.save(Request(
              time: time,
              type: "Vet Visit",
              nationId: model.nationalId ?? '',
              filePaths: [],
              status: res?.statusCode == 200
                  ? RequestStatus.Success
                  : RequestStatus.Pending,
              body: json.encode(model))));
          Progressbar.dismiss();
          showErrorMessage(res?.data["_server_messages"]);
          return false;
        }
      } else {
        showErrorToast(null);
      }
    } on DioException catch (e) {
      Progressbar.dismiss();
      Future.delayed(Duration(milliseconds: 800), () {
        handleDioError(e);
      });
    } catch (e) {
      showErrorToast(null);
    }
    await _saveVetVistiFiles(time, model);
    unawaited(_requestRepo.save(Request(
        time: time,
        nationId: model.nationalId ?? '',
        type: "Vet Visit",
        filePaths: [],
        status: RequestStatus.Pending,
        body: json.encode(model))));
    return false;
  }

  Future<void> _saveVetVistiFiles(int time, AddVetVisitFormModel model) async {
    var imageDam1 = await _fileRepo.saveFile(
        time: time, key: "imageDam1", path: model.imageDam1 ?? "");
    if (imageDam1 != null) {
      model.imageDam1 = imageDam1;
    }
    var licenseSalamat = await _fileRepo.saveFile(
        time: time, key: "licenseSalamat", path: model.licenseSalamat!);
    if (licenseSalamat != null) {
      model.licenseSalamat = licenseSalamat;
    }
    var imageDam2 = await _fileRepo.saveFile(
        time: time, key: "imageDam2", path: model.imageDam2 ?? "");
    if (imageDam2 != null) {
      model.imageDam2 = imageDam2;
    }
    var imageDam3 = await _fileRepo.saveFile(
        time: time, key: "imageDam3", path: model.imageDam3 ?? "");
    if (imageDam3 != null) {
      model.imageDam3 = imageDam3;
    }
    var imageDam = await _fileRepo.saveFile(
        time: time, key: "imageDam", path: model.imageDam ?? "");
    if (imageDam != null) {
      model.imageDam = imageDam;
    }
  }

  Future<String?> _uploadVetVisitFiles(
      AddVetVisitFormModel model, dynamic body) async {
    var newBody = json.decode(body);
    if (model.imageDam != null) {
      var image_dam_res = await _fileService.uploadFile(
          model.imageDam!, "Vet Visit",
          fieldname: "image_dam", docname: "new-vet-visit-1");
      newBody["image_dam"] = image_dam_res;
    }
    if (model.licenseSalamat != null) {
      var license_salamat_res = await _fileService.uploadFile(
          model.licenseSalamat!, "Vet Visit",
          fieldname: "license_salamat", docname: "new-vet-visit-1");
      newBody["license_salamat"] = license_salamat_res;
    }
    if (model.imageDam1 != null) {
      var image_dam1_res = await _fileService.uploadFile(
          model.imageDam1!, "Vet Visit",
          fieldname: "image_dam1", docname: "new-vet-visit-1");
      newBody["image_dam1"] = image_dam1_res;
    }
    if (model.imageDam2 != null) {
      var image_dam2_rs = await _fileService.uploadFile(
          model.imageDam2!, "Vet Visit",
          fieldname: "image_dam3", docname: "new-vet-visit-1");
      newBody["image_dam2"] = image_dam2_rs;
    }

    if (model.imageDam3 != null) {
      var image_dam3_rs = await _fileService.uploadFile(
          model.imageDam3!, "Vet Visit",
          fieldname: "image_dam3", docname: "new-vet-visit-1");
      newBody["image_dam3"] = image_dam3_rs;
    }

    return json.encode(newBody);
  }

  Future<Response<dynamic>?> _sendRequest(String body) {
    return _httpService.postForm(
        "/api/method/frappe.desk.form.save.savedocs",
        FormData.fromMap({
          'doc': body,
          'action': 'Save',
        }));
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

  Future<ProductivityFormModel?> getProductInfo(String name) async {
    try {
      var result = await _httpService.get(
        "/api/method/frappe.desk.form.load.getdoc?doctype=Productivity%20File&name=$name&_=1720104603",
      );
      return ProductivityFormModel.fromJson(result?.data["docs"][0]);
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

  Future<void> sendUserTag(
      {required String nationalId, required String type}) async {
    try {
      var rs = await _httpService.post(
          "/api/method/frappe.desk.doctype.tag.tag.add_tag",
          FormData.fromMap({"dn": nationalId, "dt": type, "tag": "ANDROID"}));
      print(rs);
    } catch (e) {
      _logger.e(e);
    }
  }
}
