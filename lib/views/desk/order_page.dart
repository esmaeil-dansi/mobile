import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_order_model.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/methodes.dart';
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
  final _idController = TextEditingController();
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
    _idController.addListener(() {
      var text = _idController.text;
      if (text.isEmpty) {
        _buyOrderList.clear();
        _buyOrderList.addAll(allBuy);
        _sellOrderList.clear();
        _sellOrderList.addAll(allSell);
      } else {
        _buyOrderList.clear();
        _buyOrderList.addAll(allBuy.where((_) => _.name.contains(text)));
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
          title: Text(
            "سفارشات",
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.greenAccent,
              indicatorWeight: 2,
              tabs: [
                Tab(
                  text: "\t\t\t\t\t\t\tخرید\t\t\t\t\t\t\t",
                ),
                Tab(
                  text: "\t\t\t\t\t\t\tفروش\t\t\t\t\t\t\t",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) {
                    // getReport();
                  },
                  decoration: InputDecoration(
                    labelText: "کد پیگیری",
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Obx(() => _buyOrderList.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Expanded(
                                      child: transactionBuilder(
                                          _buyOrderList, false),
                                    ),
                                  ],
                                ),
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
                        Obx(() => _sellOrderList.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: transactionBuilder(
                                          _sellOrderList, true),
                                    ),
                                  ],
                                ),
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
