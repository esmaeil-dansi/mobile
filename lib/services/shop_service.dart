import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/cart.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/db/shop_item_tamin_info.dart';
import 'package:frappe_app/model/shop_order_model.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/model/store_keeper.dart';
import 'package:frappe_app/model/transaction.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';

import 'package:frappe_app/widgets/methodes.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart' as g;
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/shop_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ShopService {
  var _httpService = GetIt.I.get<HttpService>();
  var _fileService = GetIt.I.get<FileService>();
  var _autService = GetIt.I.get<AutService>();
  var _logger = Logger();

  var hasShop = false;

  var units = Map<String, String>();

  String _SHOP_IMAGE = "SHOP_IMAGE";
  String _SHOP_NAME = "SHOP_NAME";

  final shopImage = "".obs;

  final _shopRepo = GetIt.I.get<ShopRepo>();
  final _shared = GetIt.I.get<SharedPreferencesHelper>();

  Future<void> fetchShopInfo() async {
    try {
      var res = await _httpService
          .get("/api/method/get_supplier?name_user=${_autService.getUserId()}");
      // await _shopRepo.deleteAllSShop();
      _extractShopInf(res!.data!["res"]);
    } catch (e) {
      _logger.e(e);
    }
  }

  String getShopName() {
    return _shared.getString(_SHOP_NAME) ?? "";
  }

  void _extractShopInf(List<dynamic> info) {
    try {
      try {
        for (int i = 0; i < info.length; i++) {
          var data = info[i];
          _shopRepo.save(ShopInfo(
              name: (data["supplier_info"]["supplier_name"] ?? ""),
              id: (data["supplier_info"]["name"] ?? ""),
              items: data["items_list"].length > 0
                  ? (data["items_list"] as List<dynamic>)
                      .map((item) => ShopItemTaminInfo.fromJson(item))
                      .toList()
                  : []));
        }
      } catch (e) {
        _logger.e(e);
      }
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
    var avatar = _shared.getString(_SHOP_IMAGE);
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
      _shared.setString(_SHOP_IMAGE, avatar);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<bool> changeShopAvatar(String path) async {
    try {
      String name = _shared.getString(_SHOP_NAME) ?? "";
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
      var result = await _httpService.get(
        "/api/method/get_supplier_byitem?item=$group",
      );

      List<ShopTamin> r = [];
      var sData = (result!.data["res"]) as List<dynamic>;
      for (var d in sData) {
        var ex = ShopTamin.fromJson(d);
        if (ex != null &&
            (_autService.getProvince().isEmpty ||
                (_autService.getProvince().contains(ex.custom_province) ||
                    _autService.getProvince() == ex.custom_province ||
                    ex.custom_province.contains(_autService.getProvince())))) {
          r.add(ex);
        }
      }
      return r;
    } catch (e) {
      return [];
    }
  }

  Future<bool> addShopItem(
      {required ShopInfo shopInfo, required ShopItemTaminInfo info}) async {
    try {
      var res = await _httpService.post(
          "/api/method/add_item_chopo?name=${shopInfo.id}&supplier_items=${info.name}&amount=${info.amount}&price=${info.price}&description=${info.description}&name_supplier=${shopInfo.id}",
          FormData.fromMap({}));

      Fluttertoast.showToast(msg: res?.data["message"]);
      return res?.statusCode == 200;
    } catch (e) {
      Fluttertoast.showToast(msg: "خطایی رخ داده است");
      _logger.e(e);
    }
    return false;
  }

  Future<bool> saveTransaction(
      {required List<Cart> items, required String paymentType}) async {
    try {
      Progressbar.showProgress();
      var sellerName = await getSellerName(items.first.shopId);

      var res = await _httpService.postFormData(
          "/api/method/add_market_transactions",
          jsonEncode({
            "id_store": items.first.shopId,
            "payment_type": paymentType,
            "id_seller": sellerName,
            "id_buyer":
                _autService.getUserId().toString().replaceAll("%40", "@"),
            "status": "آماده تحویل",
            "items": items
                .map((d) => Transaction(
                        supplier_items: d.item,
                        amount: d.amount.floor(),
                        price: d.price.floor(),
                        description: "_")
                    .toJson())
                .toList()
          }));
      Progressbar.dismiss();
      showTransactionResult(res?.data["message"]);
      if (res?.statusCode == 200) {
        if (paymentType == "پرداخت از اعتبار") {
          decreaseCredit(int.parse((res?.data["total_sum"] ?? "0").toString()));
        }

        var code = res?.data["message"].replaceAll(new RegExp(r'[^0-9]'), '');
        _sendSmsToSeller(
            code: code,
            name: items.first.shopId,
            userId: items.first.shopOwner);
        _decreaseSupply(code);
      }
      return res?.statusCode == 200;
    } catch (e) {
      showErrorToast(null);
      _logger.e(e);
    }
    return false;
  }

  Future<String> getSellerName(String id) async {
    try {
      var res = await _httpService
          .get("/api/method/get_seller_fromsupplier?supplier_id=$id");
      return res!.data["res"][0][0];
    } catch (e) {
      _logger.e(e);
      return "";
    }
  }

  Future<void> _sendSmsToSeller(
      {required String code,
      required String userId,
      required String name}) async {
    var mobile = await _autService.fetchMobile(userId);
    if (mobile != null) {
      sendSms(
          text: "خریدی در بازار $name با کد پیگیری " +
              "" +
              " \t" +
              code +
              "\t" +
              "انجام شد برای مشاهده جزئیات به برنامه چوپو مراجعه کنید",
          phone: mobile);
    }
  }

  Future<void> sendSms(
      {required String text, required String phone, bool retry = true}) async {
    try {
      String uri =
          "https://services.mizbansms.com/api/Customer/SendSMS?Usertype=2&Username=09384501252&Password=0371201551&Message=$text&From=5000462992&To=$phone&Api=2016";
      Dio().get(uri);
    } catch (e) {
      if (retry) {
        sendSms(text: text, phone: phone, retry: false);
      }
      _logger.e(e);
    }
  }

  Future<List<ShopOrderModel>> fetchBuyOrders({String? id}) async {
    try {
      var result = await _httpService.get(
          "/api/method/get_buy_transaction?buyer_name=${id ?? _autService.getUserId()}");
      return (result?.data["res"] as List<dynamic>)
          .map((e) => ShopOrderModel.fromJson(e))
          .toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<List<ShopOrderModel>> fetchSellOrders({String? id}) async {
    try {
      // if (kDebugMode) {
      //   return [
      //     ShopOrderModel(
      //         name: 'tess',
      //         shopName: 'test',
      //         time: 'test',
      //         paymentType: 'test',
      //         status: 'test')
      //   ];
      // }
      var result = await _httpService.get(
          "/api/method/get_sell_transaction?seller_name=${id ?? _autService.getUserId()}");
      return (result?.data["res"] as List<dynamic>)
          .map((e) => ShopOrderModel.fromJson(e))
          .toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<void> changeTransactionState(String id,
      {String state = "تحویل شده"}) async {
    try {
      var result = await _httpService.post(
          "/api/method/change_status?transaction=$id&status=تحویل شده",
          FormData());
      Fluttertoast.showToast(msg: result?.data["message"]);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<List<StoreKeeper>> getTaminForCurrentUser() async {
    try {
      var result = await _httpService.get(
          "/api/method/get_supplier_bywarehouser?user_id=${_autService.getUserId()}");
      return ((result?.data["supplier_name"] ?? []) as List<dynamic>)
          .map((e) => StoreKeeper.fromJson(e))
          .toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<TransactionInfo?> fetchBuyTransactionsInfo(String id) async {
    try {
      if (kDebugMode) {
        await Future.delayed(Duration(seconds: 2));
        return TransactionInfo(
          store_name: 'test',
          seller_name: 'test',
          seller_phone: '09114583949',
          id_buyer: 'test',
          name_buyer: "test",
          status: 'test',
          transactions: [
            Transaction(
                supplier_items: "supplier_items",
                amount: 10,
                price: 10,
                description: 'description')
          ],
        );
      }
      var result = await _httpService
          .get("/api/method/get_buy_transaction?transaction=$id");
      return TransactionInfo.fromJson(result?.data);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<TransactionInfo?> fetchSellTransactionsInfo(String id) async {
    try {
      if (kDebugMode) {
        await Future.delayed(Duration(seconds: 2));
        return TransactionInfo(
          store_name: 'test',
          seller_name: 'test',
          seller_phone: '09114583949',
          id_buyer: 'test',
          name_buyer: "test",
          status: 'test',
          transactions: [
            Transaction(
                supplier_items: "supplier_items",
                amount: 10,
                price: 10,
                description: 'description')
          ],
        );
      }
      var result = await _httpService
          .get("/api/method/get_sell_transaction?transaction=$id");
      return TransactionInfo.fromJson(result?.data);
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<void> decreaseCredit(int amount) async {
    try {
      var nationCode = await _autService.fetchCurrentUserNationNumber();
      if (nationCode != null) {
        var result = await _httpService.post(
            "/api/method/deduction_credit?buyer_id=$nationCode&transaction_total=$amount",
            FormData.fromMap({}));
        print(result);
        _autService.fetchRemainCredit();
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> saveAndSendVerificationCode(String code, String userId) async {
    int randomNumber = new Random().nextInt(9000) + 1000;
    if (await sendVerificationCode(code, randomNumber.toString(), userId)) {
      _shopRepo.saveTransaction(code, randomNumber.toString());
      Fluttertoast.showToast(msg: "کد تحویل برای خریدار ارسال شد.");
    } else {
      Fluttertoast.showToast(msg: "خطایی رخ داده است");
    }
  }

  Future<bool> sendVerificationCode(
      String code, String verificationCode, String userId) async {
    var mobile =
        kDebugMode ? "09114583949" : await _autService.fetchMobile(userId);
    if (mobile != null) {
      await sendSms(
          text: "خرید با کد پیگیری" +
              "\t" +
              code +
              "\t" +
              "تحویل انبار دار شد\t" +
              "\n" +
              "کد تحویل" +
              ":" "\t" +
              verificationCode,
          phone: mobile);
      return true;
    }
    return false;
  }

  Future<void> closeTransaction(String code) async {
    try {
      var res = await _httpService.post(
          "/api/method/change_deposit_inventory?transaction=$code",
          FormData.fromMap({}));
      _logger.i(res);
    } catch (_) {
      _logger.e(_);
    }
  }

  Future<void> _decreaseSupply(String code) async {
    try {
      var res = await _httpService.post(
          "/api/method/change_inventory_supplier?transaction=$code",
          FormData.fromMap({}));
      _logger.i(res);
    } catch (_) {
      _logger.e(_);
    }
  }
}
