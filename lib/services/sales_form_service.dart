// lib/services/sales_form_service.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frappe_app/model/buyer_info.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../model/PurchaseItem.dart';
import '../model/sales_item_model.dart';

class SalesFormService {
  final HttpService _httpService = GetIt.I.get<HttpService>();
  final Logger _logger = Logger();
  final String credential = "username=chopoo&password=AqJ_Te";

  Future<BuyerInfo?> fetchBuyerInfo(String nationalId) async {
    try {
      final response = await _httpService.get(
          "/api/method/get_buyer_info_chopoo?national_id=$nationalId&$credential");
      if (response?.data["message"]['code'] == 2000) {
        return BuyerInfo.fromJson(response?.data["message"]["data"][0]);
      }
      return null;
    } catch (e) {
      _logger.e("Error fetching buyer info: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSellers(String? nationalId) async {
    try {
      final response = await _httpService
          .get("/api/method/get_store?seller=$nationalId&$credential");

      _logger.i("Sellers response: $response");
      final responseData = response?.data;
      if (responseData == null) throw Exception("پاسخ سرور خالی است");

      final Map<String, dynamic> result = responseData['result'];
      if (result['code'] == 2000) {
        final List<dynamic> sellersData = result['data'];
        return sellersData.map((seller) {
          return {"id": seller['id'].toString(), "name": seller['store_name']};
        }).toList();
      } else if (result['code'] == 5000) {
        throw Exception("اطلاعاتی برای فروشندگان یافت نشد");
      } else if (result['code'] == 4000) {
        throw Exception("نام کاربری یا رمز عبور اشتباه است");
      } else {
        throw Exception("خطای ناشناخته: ${result['message']}");
      }
    } catch (e) {
      _logger.e("Error fetching sellers: $e");
      rethrow;
    }
  }

  Future<List<SalesItemModel>> fetchItems() async {
    try {
      final response =
          await _httpService.get("/api/method/get_item?$credential");
      final responseData = response?.data;
      if (responseData == null) throw Exception("پاسخ سرور خالی است");

      if (responseData.containsKey('errorcode')) {
        final int errorCode = responseData['errorcode'];
        final String errorMessage = responseData['message'] ?? "خطای ناشناخته";
        if (errorCode == 4000)
          throw Exception("نام کاربری یا رمز عبور اشتباه است");
        throw Exception("خطا: $errorMessage (کد: $errorCode)");
      }

      if (responseData.containsKey('res')) {
        return (responseData["res"] as List<dynamic>)
            .map((item) => SalesItemModel.fromJson(item))
            .toList();
      }
      throw Exception("ساختار پاسخ سرور نامعتبر است");
    } catch (e) {
      _logger.e("Error fetching items: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchWarehouses(
      String? supplierId, String? seller) async {
    try {
      final response = await _httpService.get(
          "/api/method/get_warehouse_supplier?seller=$seller&supplier_id=$supplierId&$credential");
      _logger.i("Warehouses response: $response");
      final responseData = response?.data;
      if (responseData == null) throw Exception("پاسخ سرور خالی است");

      if (responseData.containsKey('message')) {
        final message = responseData['message'];

        if (responseData['code'] == 2000) {
          final List<dynamic> warehousesData = message['data'];
          return warehousesData.map((warehouse) {
            return {
              "id": warehouse['name'].toString(),
              "title": warehouse['warehouse_name'] ??
                  warehouse['title'] ??
                  warehouse['name'] ??
                  "نامشخص"
            };
          }).toList();
        } else if (responseData['code'] == 5000) {
          throw Exception("خطا در دریافت انبارها: ${message}");
        } else {
          throw Exception("خطا در دریافت انبارها: ${message['message']}");
        }
      } else if (responseData.containsKey('result')) {
        final Map<String, dynamic> result = responseData['result'];
        if (result['code'] == 2000) {
          final List<dynamic> warehousesData = result['data'];
          return warehousesData.map((warehouse) {
            return {
              "id": warehouse['name'].toString(),
              "title": warehouse['warehouse_name'] ??
                  warehouse['title'] ??
                  warehouse['name'] ??
                  "نامشخص"
            };
          }).toList();
        } else
          throw Exception("خطا در دریافت انبارها: ${result['message']}");
      } else if (responseData.containsKey('data')) {
        final List<dynamic> warehousesData = responseData['data'];
        return warehousesData.map((warehouse) {
          return {
            "id": warehouse['name'].toString(),
            "title": warehouse['warehouse_name'] ??
                warehouse['title'] ??
                warehouse['name'] ??
                "نامشخص"
          };
        }).toList();
      }
      throw Exception("ساختار پاسخ سرور نامعتبر است");
    } catch (e) {
      _logger.e("Error fetching warehouses: $e");
      rethrow;
    }
  }

  Future<List<PurchaseItem>> fetchPurchaseDocuments(
      String itemCode, String warehouse) async {
    try {
      final response = await _httpService.get(
          "/api/method/purchase_list?item_code=$itemCode&warehouse=$warehouse&$credential");
      _logger.i(
          "Purchase documents response: $itemCode&warehouse=$warehouse&$credential");
      _logger.i("data: $response");
      final responseData = response?.data;
      return (response?.data["message"]["purchase_list"] as List<dynamic>)
          .map((item) => PurchaseItem.fromJson(item))
          .toList();
    } catch (e) {
      _logger.e("Error fetching purchase documents: $e");
      return [];
    }
  }

  Future<bool> sendSmsCode(String nationalId) async {
    try {
      if(kDebugMode){
        return true;
      }
      final Map<String, dynamic> requestData = {
        "username": "chopoo",
        "password": "AqJ_Te",
        "national_id": nationalId,
      };

      final response = await _httpService.post(
          "/api/method/send_verification_chopoo",
          FormData.fromMap(requestData));

      _logger.i("Send SMS response: $response");
      final responseData = response?.data;
      if (responseData == null) throw Exception("پاسخ سرور خالی است");

      // در این API نتیجه مستقیم داخل body است
      if (responseData['code'] == 2000) {
        return true;
      } else if (responseData['errorcode'] == 5000) {
        throw Exception("شماره موبایل برای این خریدار یافت نشد");
      } else if (responseData['errorcode'] == 4000) {
        throw Exception("نام کاربری یا رمز عبور اشتباه است");
      } else {
        throw Exception("خطای ناشناخته: ${responseData['message']}");
      }
    } catch (e) {
      _logger.e("Error sending SMS: $e");
      rethrow;
    }
  }

  Future<bool> verifySmsCode(String code, String nationalId) async {
    try {
      if(kDebugMode){
        return true;
      }
      final response = await _httpService.get(
          "/api/method/confirm_buyer_chopoo?national_id=$nationalId&verify_code=$code&$credential");

      _logger.i("Verify SMS response: $response");

      final responseData = response?.data;
      if (responseData == null) throw Exception("پاسخ سرور خالی است");

      final Map<String, dynamic> result = responseData;

      if (result['code'] == 2000) {
        // ✅ verification successful
        final buyerData = result['data'];
        _logger.i("Buyer confirmed: $buyerData");
        return true;
      } else if (result['code'] == 5000) {
        throw Exception("کد اشتباه است. لطفا کد صحیح را وارد کنید");
      } else if (result['code'] == 5300) {
        throw Exception("شماره موبایل برای این خریدار یافت نشد");
      } else if (result['code'] == 5100) {
        throw Exception("برای کاربری با این شماره موبایل کدی ارسال نشده است");
      } else if (result['errorcode'] == 4000) {
        throw Exception("نام کاربری یا رمز عبور اشتباه است");
      } else {
        throw Exception("خطای ناشناخته: ${result['message']}");
      }
    } catch (e) {
      _logger.e("Error verifying SMS: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> finalSubmitInvoice({
    required String nationalId,
    required String supplierId,
    required String warehouse,
    required String description,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // ساختار داده‌های درخواست مطابق مستندات
      final Map<String, dynamic> requestData = {
        "username": "chopoo",
        "password": "AqJ_Te",
        "national_id": nationalId,
        "supplier_id": supplierId,
        "warehouse": warehouse,
        "description": description,
        "items": items,
      };

      _logger.i("Final submit request: $requestData");

      final response = await _httpService.postFormData(
          "/api/method/create_invoice_chopoo", requestData);

      final responseData = response?.data;
      if (responseData == null) {
        throw Exception("پاسخ سرور خالی است");
      }

      _logger.i("Final submit response: $responseData");

      // بررسی انواع خطاها بر اساس مستندات
      if (responseData.containsKey('errorcode')) {
        final dynamic errorCode = responseData['errorcode'];
        final String errorMessage =
            responseData['message']?.toString() ?? "خطای ناشناخته";

        // مدیریت خطاهای خاص بر اساس کد
        switch (errorCode.toString()) {
          case '4000':
            throw Exception("نام کاربری یا رمز عبور اشتباه است");
          case '5000':
            throw Exception("متقاضی مورد نظر یافت نشد");
          case '5001':
            throw Exception("تأمین‌کننده یافت نشد");
          default:
            throw Exception("$errorMessage (کد خطا: $errorCode)");
        }
      }

      // بررسی کد پاسخ برای موفقیت آمیز بودن
      if (responseData.containsKey('code')) {
        final dynamic responseCode = responseData['code'];

        switch (responseCode.toString()) {
          case '2000':
            // موفقیت آمیز
            return {
              "invoice_id": responseData['invoice_id']?.toString() ?? "نامشخص",
              "message": responseData['message']?.toString() ??
                  "صورتحساب با موفقیت ایجاد شد",
              "code": responseCode.toString(),
            };

          case '6001':
            throw Exception("خطا: گروه کالا معتبر نیست");

          default:
            final String errorMessage = responseData['message']?.toString() ??
                "خطای ناشناخته (کد: $responseCode)";
            throw Exception(errorMessage);
        }
      }

      // اگر ساختار پاسخ نامعتبر باشد
      throw Exception("ساختار پاسخ سرور نامعتبر است");
    } catch (e) {
      _logger.e("Error in final submit: $e");
      rethrow;
    }
  }
}
