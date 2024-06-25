import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/shop_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ShopService {
  var _httpService = GetIt.I.get<HttpService>();
  var _logger = Logger();

  Future<List<String>> fetchShopGroupItems(String group) async {
    try {
      String key ="مواد اولیه"+" "+group;
      var res = await _httpService.get("/api/method/get_item?item_group=$key");
      return (res?.data["item_name"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
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
}
