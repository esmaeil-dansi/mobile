import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/model/shop_item_tamin_info.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/widgets/methodes.dart';
import 'package:get/get.dart' as g;
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/shop_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopService {
  var _httpService = GetIt.I.get<HttpService>();
  var _fileService = GetIt.I.get<FileService>();
  var _autService = GetIt.I.get<AutService>();
  var _logger = Logger();

  var units = Map<String, String>();

  String _SHOP_IMAGE = "SHOP_IMAGE";
  String _SHOP_NAME = "SHOP_NAME";

  final shopImage = "".obs;

  final _shopRepo = GetIt.I.get<ShopRepo>();
  late SharedPreferences sharedPreferences;

  ShopService() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  Future<void> fetchShopInfo() async {
    try {
      var res = await _httpService
          .get("/api/method/get_supplier?name_user=${_autService.getUserId()}");
      await _shopRepo.deleteAllSShop();
      _extractShopInf(res!.data!["res"]);
    } catch (e) {
      _logger.e(e);
    }
  }

  String getShopName() {
    return sharedPreferences.getString(_SHOP_NAME) ?? "";
  }

  void _extractShopInf(List<dynamic> data) {
    try {
      var l = data.length;
      List<List<dynamic>> sData = [];
      int j = 0;
      while (j < l) {
        List<dynamic> s = data.sublist(j, min(l, j + 6));
        sData.add(s);
        j = j + 6;
      }
      for (var info in sData) {
        try {
          _shopRepo.save(ShopInfo(
              name: (info[0] ?? "").toString(),
              id: info.length > 1 ? info[1] ?? "" : "",
              items: info.length > 2
                  ? ((info[2] ?? <dynamic>[]) as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                  : [],
              items_prices: info.length > 3
                  ? ((info[3] ?? <dynamic>[]) as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                  : [],
              items_amount: info.length > 4
                  ? ((info[4] ?? <dynamic>[]) as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                  : [],
              descriptions: info.length > 5
                  ? ((info[5] ?? <dynamic>[]) as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                  : []));
        } catch (e) {
          _logger.e(e);
        }
      }

      // _fetchShopAvatar(shopName);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchAllItemsUnit() async {
    fetchShopGroupItems("دام");
    fetchShopGroupItems("نهاده");
  }

  Future<List<ShopItemBaseModel>> fetchShopGroupItems(String group) async {
    try {
      String key = "مواد اولیه" + " " + group;
      var res = await _httpService.get("/api/method/get_item?item_group=$key");
      var items =
          (res?.data["res"] as List<dynamic>).map((e) => e.toString()).toList();
      var result = <ShopItemBaseModel>[];
      int j = 0;
      while (j < items.length - 1) {
        result.add(ShopItemBaseModel(name: items[j], unit: items[j + 1]));
        j = j + 2;
      }
      result.forEach((element) {
        units[element.name] = element.unit;
      });
      return result;
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<List<ShopItemBaseModel>> fetchAvailableShopGroupItems(
      String group) async {
    try {
      String key = "مواد اولیه" + " " + group;
      var res =
          await _httpService.get("/api/method/get_avail_item?item_group=$key");
      var items =
          (res?.data["res"] as List<dynamic>).map((e) => e.toString()).toList();
      var result = <ShopItemBaseModel>[];
      int j = 0;
      while (j < items.length) {
        result.add(ShopItemBaseModel(name: items[j], unit: ""));
        j = j + 1;
      }
      return result;
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<String> getShopAvatar(String sn) async {
    var avatar = sharedPreferences.getString(_SHOP_IMAGE);
    if (avatar == null) {
      await _fetchShopAvatar(sn);
      return shopImage.value;
    }
    return avatar;
  }

  Future<void> _fetchShopAvatar(String shopName) async {
    try {
      var res = await _httpService.get(
          "/api/method/frappe.desk.form.load.getdoc?doctype=Supplier&name=$shopName&_=${DateTime.now().millisecondsSinceEpoch}");
      var avatar = res?.data["docs"][0]["image"];
      shopImage.value = avatar;
      sharedPreferences.setString(_SHOP_IMAGE, avatar);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<bool> changeShopAvatar(String path) async {
    try {
      String name = sharedPreferences.getString(_SHOP_NAME) ?? "";
      var result = await _fileService.uploadFile(path, "Supplier",
          docname: name, fieldname: "image");
      if (result != null) {
        var res = await _httpService.post(
            "/api/method/frappe.desk.form.save.savedocs",
            FormData.fromMap({
              "doc": json.encode({
                "image": result,
                "name": name,
                "owner": GetIt.I.get<AutService>().getUserId()
              }),
              "action": "Save"
            }));
        shopImage.value = result;
      }
      return true;
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }

  Future<List<ShopItemServerModel>> searchInShopItem(String name) async {
    try {
      List<List<String>> filters = [];
      if (name.isNotEmpty) {
        filters.add(["Item", "item_name", "like", "%$name%"]);
      }
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': 'Item',
            'fields': json.encode([
              "`tabItem`.`name`",
              "`tabItem`.`owner`",
              "`tabItem`.`creation`",
              "`tabItem`.`modified`",
              "`tabItem`.`modified_by`",
              "`tabItem`.`_user_tags`",
              "`tabItem`.`_comments`",
              "`tabItem`.`_assign`",
              "`tabItem`.`_liked_by`",
              "`tabItem`.`docstatus`",
              "`tabItem`.`idx`",
              "`tabItem`.`item_name`",
              "`tabItem`.`item_group`",
              "`tabItem`.`is_stock_item`",
              "`tabItem`.`image`",
              "`tabItem`.`stock_uom`",
              "`tabItem`.`has_variants`",
              "`tabItem`.`end_of_life`",
              "`tabItem`.`disabled`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabItem`.`modified` DESC',
            'start': 0,
            'page_length': 70,
            'view': 'List',
            'group_by': '`tabItem`.`name`',
            'with_comment_count': 1
          }));
      return ShopUtils.extract(result?.data["message"]["values"]);
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<List<ShopTamin>> fetchShopTamin(String group) async {
    try {
      List<List<String>> filters = [];
      filters.add(["Items supplier", "supplier_items", "=", group]);
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': 'Supplier',
            'fields': json.encode([
              "`tabSupplier`.`name`",
              "`tabSupplier`.`owner`",
              "`tabSupplier`.`creation`",
              "`tabSupplier`.`modified`",
              "`tabSupplier`.`modified_by`",
              "`tabSupplier`.`_user_tags`",
              "`tabSupplier`.`_comments`",
              "`tabSupplier`.`_assign`",
              "`tabSupplier`.`_liked_by`",
              "`tabSupplier`.`docstatus`",
              "`tabSupplier`.`idx`",
              "`tabSupplier`.`supplier_name`",
              "`tabSupplier`.`custom_emdad_supplier`",
              "`tabSupplier`.`supplier_group`",
              "`tabSupplier`.`custom_province`",
              "`tabSupplier`.`image`",
              "`tabSupplier`.`on_hold`",
              "`tabSupplier`.`disabled`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabSupplier`.`creation` desc',
            'start': 0,
            'page_length': 20,
            'view': 'List',
            'group_by': '`tabSupplier`.`name`',
            'with_comment_count': 1
          }));
      // if (kDebugMode)
      //   return [
      //     ShopTamin(
      //         name: "test tamin",
      //         owner: "owner",
      //         supplier_name: "supplier_name",
      //         supplier_group: "supplier_group",
      //         custom_provinc: "custom_provinc")
      //   ];
      List<ShopTamin> r = [];
      var sData = (result!.data["message"]["values"]) as List<dynamic>;
      for (var d in sData) {
        var ex = ShopTamin.fromJson(d);
        if (ex != null) {
          r.add(ex);
        }
      }
      return r;
    } catch (e) {
      return [];
    }
  }

  Future<List<ShopItemTaminInfo>> fetchShiopItemsTaminInfo(String id) async {
    List<ShopItemTaminInfo> items = [];
    try {
      var res =
          await _httpService.get("/api/method/get_supplier_by_id?name=$id");

      // if (kDebugMode) {
      //   items.addAll([
      //     ShopItemTaminInfo(amount: "1000", name: "test item", price: 1000),
      //     ShopItemTaminInfo(amount: "2000", name: "test item 2", price: 1000),
      //     ShopItemTaminInfo(amount: "3000", name: "test item 3", price: 3000)
      //   ]);
      // }
      var names = (res?.data?["res"][1] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      var amounts = (res?.data?["res"][3] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      var prices = (res?.data?["res"][2] as List<dynamic>)
          .map((e) => double.parse(e.toString()))
          .toList();

      for (var i = 0; i < names.length; i++) {
        items.add(ShopItemTaminInfo(
            name: names[i], amount: amounts[i], price: prices[i]));
      }

      return items;
    } catch (e) {
      _logger.e(e);
    }
    return items;
  }

  Future<bool> addShopItem(
      {required String name, required ShopItemTaminInfo info}) async {
    try {
      var res = await _httpService.post(
          "/api/method/frappe.desk.form.save.savedocs",
          FormData.fromMap({
            "doc": json.encode({
              "name": name,
              "owner": _autService.getUserId(),
              "modified_by": _autService.getUserId(),
              "docstatus": 0,
              "idx": 2,
              "creation": "2024-06-23 09:19:36.952077",
              "modified": "2024-07-13 13:08:32.973431",
              "doctype": "Supplier",
              "custom__county": [],
              "custom_items_supplier": [
                {
                  "name": "504626c4d1",
                  "owner": _autService.getUserId(),
                  "modified_by": _autService.getUserId(),
                  "docstatus": 0,
                  "idx": 1,
                  "creation": "2024-06-23 09:19:36.952077",
                  "modified": "2024-07-13 13:08:32.973431",
                  "supplier_items": info.name,
                  "amount": info.amount,
                  "price": info.price,
                  "parent": name,
                  "parentfield": "custom_items_supplier",
                  "parenttype": "Supplier",
                  "doctype": "Items supplier"
                },
              ],
              "__unsaved": 1,
              "__last_sync_on": "2024-07-19T20:10:37.044Z"
            }),
            "action": "Save"
          }));
      showErrorMessage(res?.data["_server_messages"]);
      print(res!.data);
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }
}
