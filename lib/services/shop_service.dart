import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/model/shop_item_tamin_info.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
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
  var _logger = Logger();

  String _SHOP_IMAGE = "SHOP_IMAGE";
  String _SHOP_NAME = "SHOP_NAME";

  final shopImage = "".obs;

  final _shopRepo = GetIt.I.get<ShopRepo>();
  late SharedPreferences sharedPreferences;

  ShopService() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  Future<void> fetchShopInfo(String userId) async {
    try {
      var res =
          await _httpService.get("/api/method/get_supplier?name_user=$userId");
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
      var shopName = data[0];
      sharedPreferences.setString(_SHOP_NAME, shopName);
      _shopRepo.save(ShopInfo(
          name: shopName,
          id: data[1] ?? "",
          items: (data[2] as List<dynamic>).map((e) => e.toString()).toList(),
          items_amount:
              (data[3] as List<dynamic>).map((e) => e.toString()).toList()));
      _fetchShopAvatar(shopName);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<List<String>> fetchShopGroupItems(String group) async {
    try {
      String key = "مواد اولیه" + " " + group;
      var res = await _httpService.get("/api/method/get_item?item_group=$key");
      return (res?.data["item_name"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
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

  // {"name":"تامین کننده تست","owner":"mmokary@gmail.com","creation":"2024-06-23 09:19:36.952077","modified":"2024-06-28 23:05:10.273659","modified_by":"mmokary@gmail.com","docstatus":0,"idx":0,"naming_series":"SUP-.YYYY.-","supplier_name":"تامین کننده تست","country":"Iran","custom_national_id":"0082424705","custom_emdad_supplier":1,"supplier_group":"خدمات","supplier_type":"Individual","is_transporter":0,"image":"/files/dar5 (1).jpg","custom_province":"تهران","is_internal_supplier":0,"represents_company":"","language":"fa","allow_purchase_invoice_creation_without_purchase_order":0,"allow_purchase_invoice_creation_without_purchase_receipt":0,"is_frozen":0,"disabled":0,"warn_rfqs":0,"warn_pos":0,"prevent_rfqs":0,"prevent_pos":0,"on_hold":0,"hold_type":"","doctype":"Supplier","custom__county":[],"custom_items_supplier":[],"accounts":[],"companies":[],"portal_users":[{"name":"642799ca5b","owner":"mmokary@gmail.com","creation":"2024-06-23 09:19:36.952077","modified":"2024-06-28 23:05:10.273659","modified_by":"mmokary@gmail.com","docstatus":0,"idx":1,"user":"mmokary@gmail.com","parent":"تامین کننده تست","parentfield":"portal_users","parenttype":"Supplier","doctype":"Portal User"}],"__onload":{"addr_list":[],"contact_list":[],"dashboard_info":[]},"__unsaved":1}
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
    try {
      var res = await _httpService.get(
          "/api/method/frappe.desk.form.load.getdoc?doctype=Supplier&name=SUP-IMP-114620&_=${DateTime.now().millisecondsSinceEpoch}");
      List<ShopItemTaminInfo> items = [];
      for(var data in res!.data["docs"][0]["custom_items_supplier"]){
        var ex = ShopItemTaminInfo.fromJson(data);
        if(ex!= null){
          items.add(ex);
        }
      }
      var labels = (res.data["_link_titles"]);
      items.forEach((element) {
        element.name = labels["Item::"+element.supplier_items];
      });

      return items;



    } catch (e) {
      _logger.e(e);
    }
    return [];
  }
}
