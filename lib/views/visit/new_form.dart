// lib/screens/new_form.dart
import 'package:device_preview/device_preview.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/sales_form_service.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

import '../../model/sales_item_model.dart';
import '../../widgets/form/custom_dropownbuttom_formField.dart';

class SellerSteps extends StatefulWidget {
  const SellerSteps({super.key});

  @override
  State<SellerSteps> createState() => _NewFormState();
}

class _NewFormState extends State<SellerSteps> {
  final _shared = GetIt.I.get<SharedPreferencesHelper>();
  final step = 0.obs;
  RxBool canResend = true.obs;
  RxInt countdown = 60.obs;
  Timer? _timer;
  final TextEditingController nationalIdController = TextEditingController();
  final SalesFormService _salesFormService = SalesFormService();
  bool isLoading = false;

  String? buyerNationalId;
  Map<String, dynamic>? buyerInfo;
  String? sellerId;
  String? warehouseId;
  String? smsCode;

  final _salesItemModel = Rxn();
  String? tempQuantity;
  String description = "";

  // Multi-item selection variables
  List<Map<String, dynamic>> selectedItems = [];
  Map<String, TextEditingController> quantityControllers = {};
  Map<String, String?> selectedDocuments = {};
  Map<String, List<Map<String, dynamic>>> availableDocuments = {};
  Map<String, bool> loadingDocuments = {};

  // Cache for seller and warehouse data
  List<Map<String, dynamic>> _sellersCache = [];
  List<Map<String, dynamic>> _warehousesCache = [];

  // Price calculation methods
  double _calculateTotalPrice() {
    double total = 0.0;

    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      final String itemId = item['id'];
      final String uniqueKey = '${itemId}_$i';

      final String? purchaseDoc = selectedDocuments[uniqueKey];
      final String quantity = quantityControllers[uniqueKey]?.text ?? '0';

      if (purchaseDoc != null && availableDocuments[uniqueKey] != null) {
        try {
          final document = availableDocuments[uniqueKey]!
              .firstWhere((doc) => doc['id'] == purchaseDoc);

          final double salePrice = double.tryParse(
                  document['details']?['saleprice']?.toString() ?? '0') ??
              0.0;
          final int qty = int.tryParse(quantity) ?? 0;

          total += salePrice * qty;
        } catch (e) {
          // Skip this item if there's an error
        }
      }
    }

    return total;
  }

  double _calculateRemainingCredit() {
    final double currentCredit =
        double.tryParse(buyerInfo?["credit"]?.toString() ?? '0') ?? 0.0;
    final double totalPrice = _calculateTotalPrice();
    return currentCredit - totalPrice;
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String? _getSalePrice(String uniqueKey, String? selectedDoc) {
    if (selectedDoc == null) return null;

    try {
      final documents = availableDocuments[uniqueKey];
      if (documents != null) {
        final document = documents.firstWhere(
          (doc) => doc['id'] == selectedDoc,
          orElse: () => {},
        );

        if (document.isNotEmpty) {
          final salePrice = document['details']?['saleprice']?.toString();
          return salePrice != null
              ? _formatPrice(double.parse(salePrice))
              : null;
        }
      }
    } catch (e) {
      print('Error getting sale price: $e');
    }

    return null;
  }

  // New method to check if item can be added with quantity validation
  bool _canAddItem(SalesItemModel item, String selectedDoc, int quantity) {
    return true;
    // Check if we already have this exact same item with same document
    for (int i = 0; i < selectedItems.length; i++) {
      final existingItem = selectedItems[i];
      final existingItemId = existingItem['id'];
      final existingUniqueKey = '${existingItemId}_$i';
      final existingDoc = selectedDocuments[existingUniqueKey];

      // if (existingItemId == itemId && existingDoc == selectedDoc) {
      //   // Same item and same document - we can merge
      //   final existingQuantity =
      //       int.tryParse(quantityControllers[existingUniqueKey]?.text ?? '0') ??
      //           0;
      //   final totalQuantity = existingQuantity + quantity;
      //
      //   // Check if total quantity exceeds available stock
      //   final document = availableDocuments[existingUniqueKey]!
      //       .firstWhere((doc) => doc['id'] == selectedDoc);
      //   final availableStock = document['details']['remain_quantity'];
      //
      //   if (totalQuantity > availableStock) {
      //     Fluttertoast.showToast(
      //         msg:
      //             "مجموع تعداد ($totalQuantity) بیشتر از موجودی سند ($availableStock) است");
      //     return false;
      //   }
      //   return true;
      // }
    }

    // New item or different document - check quantity against available stock
    try {
      final document =
          docsForTemp.firstWhere((doc) => doc['id'] == selectedDoc);
      final availableStock = document['details']['remain_quantity'];

      if (quantity > availableStock) {
        Fluttertoast.showToast(
            msg: "تعداد ($quantity) بیشتر از موجودی سند ($availableStock) است");
        return false;
      }
    } catch (e) {
      // If we can't find the document, allow adding (shouldn't happen)
      return true;
    }

    return true;
  }

  // New method to merge items with same itemId and document
  void _mergeOrAddItem(
      SalesItemModel itemId, String quantity, String selectedDoc) {
    final int newQuantity = int.tryParse(quantity) ?? 0;

    // Check if we can add this item
    if (!_canAddItem(itemId, selectedDoc, newQuantity)) {
      return;
    }

    // Look for existing item with same ID and document to merge
    bool merged = false;
    for (int i = 0; i < selectedItems.length; i++) {
      final existingItem = selectedItems[i];
      final existingItemId = existingItem['id'];
      final existingUniqueKey = '${existingItemId}_$i';
      final existingDoc = selectedDocuments[existingUniqueKey];

      if (existingItemId == itemId && existingDoc == selectedDoc) {
        // Merge quantities
        final existingQuantity =
            int.tryParse(quantityControllers[existingUniqueKey]?.text ?? '0') ??
                0;
        final totalQuantity = existingQuantity + newQuantity;

        setState(() {
          quantityControllers[existingUniqueKey]?.text =
              totalQuantity.toString();
        });

        merged = true;
        Fluttertoast.showToast(msg: "تعداد کالا به $totalQuantity افزایش یافت");
        break;
      }
    }

    // If not merged, add as new item
    if (!merged) {
      final controller = TextEditingController(text: quantity);
      final uniqueKey = '${itemId}_${selectedItems.length}';

      setState(() {
        // selectedItems.add();
        // quantityControllers[uniqueKey] = controller;
        // availableDocuments[uniqueKey] = List<Map<String, dynamic>>.from(docs);
        // selectedDocuments[uniqueKey] = selectedDoc;
      });

      Fluttertoast.showToast(msg: "کالا با موفقیت اضافه شد");
    }
  }

  // New method to get merged items for display
  List<Map<String, dynamic>> _getMergedItemsForDisplay() {
    final List<Map<String, dynamic>> mergedItems = [];
    final Set<String> processedKeys = {};

    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      final String itemId = item['id'];
      final String uniqueKey = '${itemId}_$i';

      if (processedKeys.contains(uniqueKey)) continue;

      // Find all items with same ID and document
      final List<int> matchingIndexes = [];
      String? currentDoc = selectedDocuments[uniqueKey];

      for (int j = i; j < selectedItems.length; j++) {
        final otherItem = selectedItems[j];
        final otherItemId = otherItem['id'];
        final otherUniqueKey = '${otherItemId}_$j';
        final otherDoc = selectedDocuments[otherUniqueKey];

        if (otherItemId == itemId && otherDoc == currentDoc) {
          matchingIndexes.add(j);
          processedKeys.add(otherUniqueKey);
        }
      }

      // Calculate total quantity for merged item
      int totalQuantity = 0;
      for (int index in matchingIndexes) {
        final itemId = selectedItems[index]['id'];
        final uniqueKey = '${itemId}_$index';
        final quantity =
            int.tryParse(quantityControllers[uniqueKey]?.text ?? '0') ?? 0;
        totalQuantity += quantity;
      }

      // Create merged item
      final mergedItem = Map<String, dynamic>.from(item);
      mergedItem['_mergedQuantity'] = totalQuantity;
      mergedItem['_originalIndexes'] = matchingIndexes;
      mergedItem['_document'] = currentDoc;
      mergedItems.add(mergedItem);
    }

    return mergedItems;
  }

  /// ------------------ Reusable Widgets ------------------
  Widget buildDropdown({
    required String label,
    required List<Map<String, dynamic>> data,
    required String? value,
    required Function(String?) onChanged,
    bool isSearchable = false,
  }) {
    final uniqueData = {for (var e in data) e["id"]: e}.values.toList();

    String getDisplayText(Map<String, dynamic> item) {
      return item["name"]?.toString() ?? item["title"]?.toString() ?? "";
    }

    // Regular dropdown (original)
    Widget buildRegularDropdown() {
      return DropdownButtonFormField<String>(
        value:
            uniqueData.any((e) => e["id"].toString() == value) ? value : null,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: uniqueData
            .map((e) => DropdownMenuItem<String>(
                  value: e["id"].toString(),
                  child: Text(getDisplayText(e)),
                ))
            .toList(),
        onChanged: onChanged,
      );
    }

    // Searchable dropdown using built-in widgets with dynamic height
    Widget buildSearchableDropdown() {
      // Use a local key that gets reset when value is null
      return Autocomplete<String>(
        key: ValueKey(value ?? 'empty'),
        // This will force rebuild when value changes to null
        displayStringForOption: (option) {
          final item = uniqueData.firstWhere(
            (e) => e["id"].toString() == option,
            orElse: () => {},
          );
          return getDisplayText(item);
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return uniqueData.map((e) => e["id"].toString());
          }
          return uniqueData
              .where((e) => getDisplayText(e)
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()))
              .map((e) => e["id"].toString());
        },
        onSelected: onChanged,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          // Clear the controller when value is null (when resetting)
          if (value == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              textEditingController.clear();
            });
          } else {
            // Set initial value text
            final selectedItem = uniqueData.firstWhere(
              (e) => e["id"].toString() == value,
              orElse: () => {},
            );
            if (selectedItem.isNotEmpty) {
              textEditingController.text = getDisplayText(selectedItem);
            }
          }

          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (value) => onFieldSubmitted(),
            decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          final itemCount = options.length;

          // Dynamic height calculation
          double getContainerHeight() {
            if (itemCount == 0) {
              return 80.0; // Height for "no results" message
            } else if (itemCount == 1) {
              return 60.0; // Smaller height for single item
            } else if (itemCount <= 3) {
              return itemCount * 56.0; // Compact height for few items
            } else {
              return 200.0; // Maximum height for many items
            }
          }

          return Align(
            alignment: Alignment.topRight,
            child: Material(
              elevation: 4,
              child: Container(
                height: getContainerHeight(), // Dynamic height applied here
                child: itemCount == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'موردی یافت نشد',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          final item = uniqueData.firstWhere(
                            (e) => e["id"].toString() == option,
                          );
                          return ListTile(
                            title: Text(getDisplayText(item)),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
              ),
            ),
          );
        },
      );
    }

    return isSearchable ? buildSearchableDropdown() : buildRegularDropdown();
  }

  Widget buildStepWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }

  Widget buildNextButton(VoidCallback onPressed, [String text = "ادامه"]) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  /// ------------------ Steps ------------------
  Widget stepBuyerNationalId() {
    return buildStepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nationalIdController,
            decoration: InputDecoration(
              labelText: "کد ملی خریدار",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() => buyerNationalId = value),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildNextButton(() async {
                  if (buyerNationalId == null || buyerNationalId!.isEmpty) {
                    Fluttertoast.showToast(msg: "لطفا کد ملی را وارد کنید");
                    return;
                  }
                  if (buyerNationalId!.length != 10 ||
                      !RegExp(r'^[0-9]+$').hasMatch(buyerNationalId!)) {
                    Fluttertoast.showToast(
                        msg: "کد ملی باید 10 رقمی و فقط شامل اعداد باشد");
                    return;
                  }
                  setState(() => isLoading = true);
                  try {
                    // buyerInfo = await _salesFormService
                    //     .fetchBuyerInfo(buyerNationalId!);
                    // step.value++;
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  } finally {
                    setState(() => isLoading = false);
                  }
                }, "استعلام خریدار"),
        ],
      ),
    );
  }

  Widget stepBuyerInfo() => buildStepWrapper(
        child: Column(
          children: [
            const Text("اطلاعات خریدار",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            buildStepWrapper(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow("نام", buyerInfo?["name"]),
                    const Divider(),
                    _buildInfoRow("استان", buyerInfo?["province"]),
                    const Divider(),
                    _buildInfoRow("شهر", buyerInfo?["city"]),
                    const Divider(),
                    _buildInfoRow("کد ملی", buyerInfo?["national_id"]),
                    const Divider(),
                    _buildInfoRow("شماره موبایل", buyerInfo?["mobile"]),
                    const Divider(),
                    _buildInfoRow("باقیمانده اعتبار",
                        _formatPrice(buyerInfo?["credit"] ?? 0)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildNextButton(() => step.value++),
          ],
        ),
      );

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 14)),
        ),
        Expanded(
          child: Text(value ?? "نامشخص",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget stepSellerSelection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _salesFormService.fetchSellers(_shared.getString(USERNAME)),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return buildStepWrapper(
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        // Cache the sellers data
        _sellersCache = data;

        return buildStepWrapper(
          child: Column(
            children: [
              buildDropdown(
                label: "انتخاب فروشنده",
                data: data,
                value: sellerId,
                onChanged: (v) => setState(() => sellerId = v),
              ),
              const SizedBox(height: 20),
              buildNextButton(() {
                if (sellerId == null || sellerId!.isEmpty) {
                  Fluttertoast.showToast(msg: "لطفا یک فروشنده انتخاب کنید");
                  return;
                }
                step.value++;
              }),
            ],
          ),
        );
      },
    );
  }

  Widget stepWarehouseSelection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _salesFormService.fetchWarehouses(
          sellerId, _shared.getString(USERNAME)),
      builder: (_, snapshot) {
        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildStepWrapper(
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Show error state with back button
        if (snapshot.hasError) {
          return buildStepWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "خطا در دریافت اطلاعات انبارها",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                buildBackButton(() {
                  step.value--;
                }),
              ],
            ),
          );
        }

        // Show empty state with back button
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildStepWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  "هیچ انباری یافت نشد",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                buildBackButton(() {
                  step.value--;
                }),
              ],
            ),
          );
        }

        // Data loaded successfully - NO back button
        final data = snapshot.data!;
        _warehousesCache = data;

        return buildStepWrapper(
          child: Column(
            children: [
              buildDropdown(
                label: "انتخاب انبار",
                data: data,
                value: warehouseId,
                onChanged: (v) => setState(() => warehouseId = v),
              ),
              const SizedBox(height: 20),
              // Only next button when we have data
              buildNextButton(() {
                if (warehouseId == null || warehouseId!.isEmpty) {
                  Fluttertoast.showToast(msg: "لطفا یک انبار انتخاب کنید");
                  return;
                }
                step.value++;
              }),
            ],
          ),
        );
      },
    );
  }

  Widget buildBackButton(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      child: const Text("بازگشت"),
    );
  }

  final TextEditingController tempQuantityController = TextEditingController();

  Widget stepItemAndDocumentSelection() {
    return buildStepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("افزودن کالاها",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          FutureBuilder<List<SalesItemModel>>(
            future: _salesFormService.fetchItems(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snapshot.data!;
              return Column(
                children: [
                  SizedBox(
                      height: 70,
                      child: DropdownSearch<SalesItemModel>(
                          popupProps: PopupProps.menu(
                            searchDelay: Duration(milliseconds: 40),

                            showSelectedItems: true,
                            showSearchBox: true,
                            fit: FlexFit.tight,
                            // disabledItemFn: (String s) => s.startsWith('I'),
                          ),
                          items: (_, __) => items,
                          itemAsString: (item) => item.itemName ?? '',
                          compareFn: (item1, item2) =>
                              item1.itemName == item2.itemName,
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: "انتخاب کالا",
                              labelStyle: TextStyle(
                                  fontSize: 13, color: Colors.black38),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.red),
                                //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onChanged: (_) {
                            if (_ != null) {
                              _salesItemModel.value = _;
                            }
                          },
                          selectedItem: _salesItemModel.value)),

                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => _salesItemModel.value != null
                      ? SizedBox(
                          height: 70,
                          child: FutureBuilder(
                            future: _salesFormService.fetchPurchaseDocuments("",""),
                            builder: (context, asyncSnapshot) {
                              return DropdownSearch<SalesItemModel>(
                                  popupProps: PopupProps.menu(
                                    searchDelay: Duration(milliseconds: 40),
                              
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    fit: FlexFit.tight,
                                    // disabledItemFn: (String s) => s.startsWith('I'),
                                  ),
                                  items: (_, __) => items,
                                  itemAsString: (item) => item.itemName ?? '',
                                  compareFn: (item1, item2) =>
                                      item1.itemName == item2.itemName,
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      labelText: "انتخاب سند خرید",
                                      labelStyle: TextStyle(
                                          fontSize: 13, color: Colors.black38),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.red),
                                        //<-- SEE HERE
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  onChanged: (_) {
                                    if (_ != null) {
                                      _salesItemModel.value = _;
                                    }
                                  },
                                  selectedItem: _salesItemModel.value);
                            }
                          ))
                      : SizedBox()),

                  const SizedBox(height: 16),

                  if (isLoadingDocs) ...[
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 16),
                  ],

                  // buildDropdown(
                  //   label: "انتخاب سند خرید",
                  //   data: docsForTemp,
                  //   value: selectedDocForTemp,
                  //   onChanged: (v) => setState(() => selectedDocForTemp = v),
                  // ),

                  const SizedBox(height: 16),

                  // تعداد
                  TextField(
                    controller: tempQuantityController,
                    decoration: InputDecoration(
                        labelText: "مقدار",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() => tempQuantity = value),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _salesItemModel.value == null ||
                            selectedDocForTemp == null ||
                            tempQuantity == null
                        ? null
                        : () {
                            final remain = docsForTemp.firstWhere((d) =>
                                    d['id'] == selectedDocForTemp)['details']
                                ['remain_quantity'];
                            final q = int.tryParse(tempQuantity ?? "0") ?? 1;

                            if (false || q <= 0) {
                              Fluttertoast.showToast(
                                  msg: "تعداد باید بیشتر از صفر باشد");
                              return;
                            }

                            // Use the new merge method instead of old add method
                            _mergeOrAddItem(
                              _salesItemModel.value!,
                              tempQuantity!, "",
                              // docsForTemp,
                              // selectedDocForTemp!,
                            );

                            // Reset the dropdown
                            _resetItemSelection();
                          },
                    child: const Text("افزودن کالا"),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 20),
          if (selectedItems.isNotEmpty) ...[
            const Text("کالاهای انتخاب شده:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._buildMergedItemCards(),
            const SizedBox(height: 30),
            // const Divider(),
            // نمایش جمع کل در این مرحله
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("جمع کل فعلی:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("${_formatPrice(_calculateTotalPrice())} ریال",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue.shade800)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                labelText: "توضیحات (اختیاری)",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
            maxLines: 3,
            onChanged: (value) => setState(() => description = value),
          ),
          const SizedBox(height: 30),
          buildNextButton(() {
            if (selectedItems.isEmpty) {
              Fluttertoast.showToast(msg: "لطفا حداقل یک کالا اضافه کنید");
              return;
            }
            step.value++;
          }),
        ],
      ),
    );
  }

  /// Add this method to reset the dropdown
  void _resetItemSelection() {
    // Reset all temporary variables
    setState(() {
      tempQuantity = null;
      tempQuantityController.clear();
      selectedDocForTemp = null;
      docsForTemp = [];
      isLoadingDocs = false;
    });
  }

  List<Map<String, dynamic>> docsForTemp = [];
  String? selectedDocForTemp;
  bool isLoadingDocs = false;

  /// New method to build merged item cards
  List<Widget> _buildMergedItemCards() {
    final mergedItems = _getMergedItemsForDisplay();

    return mergedItems.map((mergedItem) {
      final String itemName =
          mergedItem['title'] ?? mergedItem['name'] ?? "کالا";
      final int totalQuantity = mergedItem['_mergedQuantity'];
      final String? document = mergedItem['_document'];
      final List<int> originalIndexes = mergedItem['_originalIndexes'] ?? [];

      // Calculate price for this merged item
      double unitPrice = 0.0;
      double totalPrice = 0.0;

      if (originalIndexes.isNotEmpty) {
        final firstIndex = originalIndexes.first;
        final itemId = selectedItems[firstIndex]['id'];
        final uniqueKey = '${itemId}_$firstIndex';
        unitPrice = double.tryParse(
                _getSalePrice(uniqueKey, document)?.replaceAll(',', '') ??
                    '0') ??
            0.0;
        totalPrice = unitPrice * totalQuantity;
      }

      return buildStepWrapper(
        child: ListTile(
          title: Text(itemName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("تعداد کل: $totalQuantity"),
              Text("سند: ${document ?? 'انتخاب نشده'}"),
              Text("قیمت واحد: ${_formatPrice(unitPrice)} ریال"),
              Text("جمع: ${_formatPrice(totalPrice)} ریال",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700)),
              if (originalIndexes.length > 1)
                Text("${originalIndexes.length} بار اضافه شده",
                    style:
                        TextStyle(fontSize: 12, color: Colors.orange.shade700)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeMergedItem(originalIndexes),
          ),
        ),
      );
    }).toList();
  }

  /// Fixed method to remove merged item (all instances)
  void _removeMergedItem(List<int> indexes) {
    setState(() {
      // Remove items in reverse order to maintain index integrity
      indexes.sort((a, b) => b.compareTo(a)); // Sort descending

      // Store data to remove
      final itemsToRemove = <Map<String, dynamic>>[];
      final keysToRemove = <String>[];

      for (int index in indexes) {
        if (index >= 0 && index < selectedItems.length) {
          final item = selectedItems[index];
          final String itemId = item['id'];
          final String uniqueKey = '${itemId}_$index';

          itemsToRemove.add(item);
          keysToRemove.add(uniqueKey);
        }
      }

      // Remove items from selectedItems
      for (var item in itemsToRemove) {
        selectedItems.remove(item);
      }

      // Remove associated data
      for (var uniqueKey in keysToRemove) {
        quantityControllers.remove(uniqueKey)?.dispose();
        selectedDocuments.remove(uniqueKey);
        availableDocuments.remove(uniqueKey);
      }

      // Rebuild the keys for remaining items
      _rebuildItemKeys();
    });

    Fluttertoast.showToast(msg: "کالا حذف شد");
  }

  /// Fixed method to rebuild item keys after removal
  void _rebuildItemKeys() {
    // Create temporary maps to hold the data
    final tempQuantityControllers = <String, TextEditingController>{};
    final tempSelectedDocuments = <String, String?>{};
    final tempAvailableDocuments = <String, List<Map<String, dynamic>>>{};

    // Store all current data with their original keys
    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      final String itemId = item['id'];

      // Try to find the existing data for this item
      bool found = false;

      // Look for existing data with matching item ID
      for (final oldKey in quantityControllers.keys) {
        if (oldKey.startsWith('${itemId}_')) {
          final newKey = '${itemId}_$i';
          tempQuantityControllers[newKey] = quantityControllers[oldKey]!;
          found = true;
          break;
        }
      }

      for (final oldKey in selectedDocuments.keys) {
        if (oldKey.startsWith('${itemId}_')) {
          final newKey = '${itemId}_$i';
          tempSelectedDocuments[newKey] = selectedDocuments[oldKey];
          found = true;
          break;
        }
      }

      for (final oldKey in availableDocuments.keys) {
        if (oldKey.startsWith('${itemId}_')) {
          final newKey = '${itemId}_$i';
          tempAvailableDocuments[newKey] = availableDocuments[oldKey]!;
          found = true;
          break;
        }
      }

      // If no existing data found, create new empty data (shouldn't happen)
      if (!found) {
        final newKey = '${itemId}_$i';
        tempQuantityControllers[newKey] = TextEditingController(text: '0');
        tempSelectedDocuments[newKey] = null;
        tempAvailableDocuments[newKey] = [];
      }
    }

    // Dispose of any controllers that are no longer needed
    for (final oldKey in quantityControllers.keys) {
      if (!tempQuantityControllers.containsKey(oldKey)) {
        quantityControllers[oldKey]?.dispose();
      }
    }

    // Replace the old maps with new ones
    setState(() {
      quantityControllers = Map.from(tempQuantityControllers);
      selectedDocuments = Map.from(tempSelectedDocuments);
      availableDocuments = Map.from(tempAvailableDocuments);
    });
  }

  void _removeItem(String uniqueKey, int index) {
    setState(() {
      // Remove the item at the specific index
      if (index >= 0 && index < selectedItems.length) {
        selectedItems.removeAt(index);
      }

      // Remove associated data using the unique key
      quantityControllers.remove(uniqueKey)?.dispose();
      selectedDocuments.remove(uniqueKey);
      availableDocuments.remove(uniqueKey);

      // Rebuild the keys for remaining items to maintain consistency
      _rebuildItemKeys();
    });
  }

  Widget stepSmsVerification() {
    void startCountdown() {
      canResend.value = false;
      countdown.value = 60;

      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown.value == 0) {
          canResend.value = true;
          timer.cancel(); // stop the timer
        } else {
          countdown.value--; // update countdown
        }
      });
    }

    return buildStepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "تایید شماره موبایل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: "کد تایید",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => setState(() => smsCode = v),
          ),
          const SizedBox(height: 24),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: canResend.value
                    ? () async {
                        try {
                          final ok = await _salesFormService
                              .sendSmsCode(buyerNationalId!);
                          if (ok) {
                            Fluttertoast.showToast(msg: "کد ارسال شد");
                            startCountdown();
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    : null,
                child: Text(canResend.value
                    ? "ارسال کد"
                    : "ارسال مجدد در ${countdown.value} ثانیه"),
              )),
          const SizedBox(height: 20),
          buildNextButton(() async {
            if (smsCode == null || smsCode!.isEmpty) {
              Fluttertoast.showToast(msg: "کد تایید وارد نشده");
              return;
            }
            try {
              final ok = await _salesFormService.verifySmsCode(
                  smsCode!, buyerNationalId!);
              if (ok)
                step.value++;
              else
                Fluttertoast.showToast(msg: "کد اشتباه است");
            } catch (e) {
              Fluttertoast.showToast(msg: e.toString());
            }
          }, "تایید"),
        ],
      ),
    );
  }

  Widget stepFinalSubmit() => buildStepWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 📋 خلاصه اطلاعات
            const Text(
              "خلاصه اطلاعات فاکتور",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            buildStepWrapper(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("مشخصات خریدار",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildSummaryRow("کد ملی", buyerNationalId ?? "نامشخص"),
                    _buildSummaryRow("نام", buyerInfo?["name"] ?? "نامشخص"),
                    _buildSummaryRow(
                        "استان", buyerInfo?["province"] ?? "نامشخص"),
                    _buildSummaryRow("شهر", buyerInfo?["city"] ?? "نامشخص"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Seller + warehouse
            buildStepWrapper(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("مشخصات فروش",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildSummaryRow("فروشنده", _getSellerName()),
                    _buildSummaryRow("انبار", _getWarehouseName()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Buyer info
            buildStepWrapper(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("اطلاعات مالی",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildSummaryRow("اعتبار فعلی",
                        "${_formatPrice(buyerInfo?["credit"] ?? 0)} ریال"),
                    _buildSummaryRow("جمع فاکتور",
                        "${_formatPrice(_calculateTotalPrice())} ریال"),
                    _buildSummaryRow("باقیمانده اعتبار",
                        "${_formatPrice(_calculateRemainingCredit())} ریال",
                        color: _calculateRemainingCredit() < 0
                            ? Colors.red
                            : null),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Items
            buildStepWrapper(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("کالاهای انتخابی",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._buildItemsSummary(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            if (description.isNotEmpty) ...[
              buildStepWrapper(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("توضیحات",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text(description),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 2),

            // ✅ Final submit button OR loading
            isLoading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 16), // فاصله از پایین
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : buildNextButton(() async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      // ساخت items
                      final List<Map<String, dynamic>> invoiceItems = [];

                      for (int i = 0; i < selectedItems.length; i++) {
                        final item = selectedItems[i];
                        final String itemId = item['id'];
                        final String uniqueKey = '${itemId}_$i';

                        final String? purchaseDoc =
                            selectedDocuments[uniqueKey];
                        final String quantity =
                            quantityControllers[uniqueKey]?.text ?? '';

                        if (purchaseDoc == null || quantity.isEmpty) {
                          Fluttertoast.showToast(
                              msg:
                                  "لطفا برای همه کالاها سند و تعداد مشخص کنید");
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }

                        final document = availableDocuments[uniqueKey]!
                            .firstWhere((doc) => doc['id'] == purchaseDoc);

                        invoiceItems.add({
                          "item_code": itemId,
                          "quantity": int.tryParse(quantity) ?? 0,
                          "saleprice": document['details']['saleprice'],
                          "discount": 0,
                          "purchase_doc": purchaseDoc,
                          "item_id":
                              document['details']['item_id']?.toString() ?? "",
                        });
                      }

                      // ارسال درخواست
                      final result = await _salesFormService.finalSubmitInvoice(
                        nationalId: buyerNationalId!,
                        supplierId: sellerId!,
                        warehouse: warehouseId!,
                        description: description,
                        items: invoiceItems,
                      );

                      if (result['code'] == '2000') {
                        Fluttertoast.showToast(msg: result['message']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DesktopView()),
                        );
                      } else {
                        Fluttertoast.showToast(msg: result['message']);
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "خطا در ثبت نهایی: ${e.toString()}");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }, "ثبت نهایی"),
          ],
        ),
      );

// Helper method for summary rows
  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child:
                Text("$label:", style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: color != null
                    ? TextStyle(color: color, fontWeight: FontWeight.bold)
                    : null),
          ),
        ],
      ),
    );
  }

// Helper method to build items summary
  List<Widget> _buildItemsSummary() {
    final mergedItems = _getMergedItemsForDisplay();

    if (mergedItems.isEmpty) {
      return [const Text("هیچ کالایی انتخاب نشده")];
    }

    final List<Widget> itemWidgets = [];
    double totalPrice = 0.0;

    // Build individual items
    itemWidgets.addAll(mergedItems.map((mergedItem) {
      final String itemName =
          mergedItem['title'] ?? mergedItem['name'] ?? "کالا";
      final int totalQuantity = mergedItem['_mergedQuantity'];
      final String? document = mergedItem['_document'];
      final List<int> originalIndexes = mergedItem['_originalIndexes'] ?? [];

      // Calculate price for this merged item
      double unitPrice = 0.0;
      double itemTotal = 0.0;

      if (originalIndexes.isNotEmpty) {
        final firstIndex = originalIndexes.first;
        final itemId = selectedItems[firstIndex]['id'];
        final uniqueKey = '${itemId}_$firstIndex';
        unitPrice = double.tryParse(
                _getSalePrice(uniqueKey, document)?.replaceAll(',', '') ??
                    '0') ??
            0.0;
        itemTotal = unitPrice * totalQuantity;
        totalPrice += itemTotal;
      }

      String docInfo = "سند نامشخص";
      if (document != null) {
        try {
          final firstIndex = originalIndexes.first;
          final itemId = selectedItems[firstIndex]['id'];
          final uniqueKey = '${itemId}_$firstIndex';
          final doc = availableDocuments[uniqueKey]!
              .firstWhere((doc) => doc['id'] == document);
          docInfo = "سند: ${doc['name'] ?? document}";
        } catch (e) {
          docInfo = "سند: $document";
        }
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(itemName, style: TextStyle(fontWeight: FontWeight.w500)),
                Text("${_formatPrice(itemTotal)} ریال",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700)),
              ],
            ),
            const SizedBox(height: 6),
            Text("تعداد: $totalQuantity"),
            const SizedBox(height: 6),
            Text(docInfo),
            const SizedBox(height: 6),
            Text("قیمت واحد: ${_formatPrice(unitPrice)} ریال"),
          ],
        ),
      );
    }).toList());

    // Add total price at the end
    itemWidgets.add(
      Container(
        margin: const EdgeInsets.only(top: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("جمع کل فاکتور:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("${_formatPrice(totalPrice)} ریال",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue.shade800)),
          ],
        ),
      ),
    );

    return itemWidgets;
  }

// Helper methods to get seller and warehouse names
  String _getSellerName() {
    if (sellerId == null) return "نامشخص";

    // Search in cached sellers data
    try {
      final seller = _sellersCache.firstWhere(
        (seller) => seller['id'].toString() == sellerId,
        orElse: () => {},
      );

      if (seller.isNotEmpty) {
        return seller['name']?.toString() ??
            seller['store_name']?.toString() ??
            "نامشخص";
      }
    } catch (e) {
      // If there's an error, fall back to ID
    }

    return sellerId ?? "نامشخص";
  }

  String _getWarehouseName() {
    if (warehouseId == null) return "نامشخص";

    // Search in cached warehouses data
    try {
      final warehouse = _warehousesCache.firstWhere(
        (warehouse) => warehouse['id'].toString() == warehouseId,
        orElse: () => {},
      );

      if (warehouse.isNotEmpty) {
        return warehouse['name']?.toString() ??
            warehouse['title']?.toString() ??
            "نامشخص";
      }
    } catch (e) {
      // If there's an error, fall back to ID
    }

    return warehouseId ?? "نامشخص";
  }

  /// ------------------ Build ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // غیرفعال کردن دکمه پیشفرض بک
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const Text(
            //   "فرآیند فروش",
            //   style: TextStyle(fontSize: 17),
            // ),
            Obx(() {
              if (step.value > 0) {
                return TextButton(
                  onPressed: () {
                    if (step.value > 0) step.value--;
                  },
                  child: const Text(
                    "مرحله قبل",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
      body: Obx(() {
        switch (step.value) {
          case 0:
            return stepBuyerNationalId();
          case 1:
            return stepBuyerInfo();
          case 2:
            return stepSellerSelection();
          case 3:
            return stepWarehouseSelection();
          case 4:
            return stepItemAndDocumentSelection();
          case 5:
            return stepSmsVerification();
          case 6:
            return stepFinalSubmit();
          default:
            return const Center(
                child: Text("پایان 🎉", style: TextStyle(fontSize: 20)));
        }
      }),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    nationalIdController.dispose();
    tempQuantityController.dispose();

    // Dispose all quantity controllers
    for (final controller in quantityControllers.values) {
      controller.dispose();
    }

    _timer?.cancel();
    super.dispose();
  }
}
