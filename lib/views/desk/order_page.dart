import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/shop_order_model.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/methodes.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _shopService = GetIt.I.get<ShopService>();
  final _shopRepo = GetIt.I.get<ShopRepo>();

  List<ShopOrderModel> allBuy = [];
  List<ShopOrderModel> allSell = [];
  RxList<ShopOrderModel> _buyOrderList = new RxList<ShopOrderModel>();
  RxList<ShopOrderModel> _sellOrderList = new RxList<ShopOrderModel>();
  final _buyIdController = TextEditingController();
  final _sellIdController = TextEditingController();
  var _init = false.obs;

  @override
  void initState() {
    _shopService.fetchBuyOrders().then((_) {
      allBuy.clear();
      _buyOrderList.value = _;
      allBuy.addAll(_buyOrderList);
      _init.value = true;
    });
    _shopRepo.getAll().then((_) {
      allSell.clear();
      if (_.isNotEmpty) {
        _.forEach((s) {
          _shopService.fetchSellOrders(id: s.id).then((_) {
            _sellOrderList.addAll(_);
            _init.value = true;
            allSell.addAll(_sellOrderList);
          });
          ;
        });
      }
    });
    _buyIdController.addListener(() {
      var text = _buyIdController.text;
      if (text.isEmpty) {
        _buyOrderList.clear();
        _buyOrderList.addAll(allBuy);
      } else {
        _buyOrderList.clear();
        _buyOrderList.addAll(allBuy.where((_) => _.name.contains(text)));
      }
    });

    _sellIdController.addListener(() {
      var text = _sellIdController.text;
      if (text.isEmpty) {
        _sellOrderList.clear();
        _sellOrderList.addAll(allSell);
      } else {
        _sellOrderList.clear();
        _sellOrderList.addAll(allSell.where((_) => _.name.contains(text)));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("سفارشات"),
        ),
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.greenAccent,
              indicatorWeight: 5,
              tabs: [
                Tab(
                  text: "\t\t\t\t\t\t\tخرید\t\t\t\t\t\t\t",
                ),
                Tab(
                  text: "\t\t\t\t\t\t\tفروش\t\t\t\t\t\t\t",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: SizedBox(
                            height: 60,
                            child: TextField(
                              controller: _buyIdController,
                              keyboardType: TextInputType.number,
                              onSubmitted: (_) {
                                // getReport();
                              },
                              decoration: InputDecoration(
                                labelText: "کد پیگیری",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(() => _buyOrderList.isNotEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  SizedBox(
                                      height: Get.height * 0.6,
                                      child: transactionBuilder(
                                          _buyOrderList, false)),
                                ],
                              )
                            : _init.value
                                ? Center(
                                    child: Text("لیست خرید شما خالی است"),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  )),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: SizedBox(
                            height: 60,
                            child: TextField(
                              controller: _sellIdController,
                              keyboardType: TextInputType.number,
                              onSubmitted: (_) {
                                // getReport();
                              },
                              decoration: InputDecoration(
                                labelText: "کد پیگیری",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(() => _sellOrderList.isNotEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      height: Get.height * 0.6,
                                      child: transactionBuilder(
                                          _sellOrderList, true)),
                                ],
                              )
                            : _init.value
                                ? Center(
                                    child: Text("لیست فروش شما خالی است"),
                                  )
                                : Center(child: CircularProgressIndicator())),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
