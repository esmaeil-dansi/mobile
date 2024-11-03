import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/store_keeper.dart';
import 'package:frappe_app/model/transaction.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/utils/date_mapper.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../model/shop_order_model.dart';

class StoreKeeperPage extends StatefulWidget {
  @override
  State<StoreKeeperPage> createState() => _StoreKeeperPageState();
}

class _StoreKeeperPageState extends State<StoreKeeperPage> {
  var _shopService = GetIt.I.get<ShopService>();

  RxList<StoreKeeper> shops = <StoreKeeper>[].obs;
  List<StoreKeeper> allShop = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _shopService.getTaminForCurrentUser().then((_) {
      if (_.isNotEmpty) {
        allShop.addAll(_);
        shops.addAll(_);
      }
    });
    _idController.addListener(() {
      var text = _idController.text;
      shops.clear();
      if (text.isEmpty) {
        shops.addAll(allShop);
      } else {
        shops.addAll(allShop.where((_) => _.id.contains(text)));
      }
    });
  }

  final _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "انبار",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _idController,
                  // keyboardType: TextInputType.number,
                  onSubmitted: (_) {
                    // getReport();
                  },
                  decoration: InputDecoration(
                    labelText: "نام فروشگاه",
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => shops.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      itemCount: shops.length,
                      itemBuilder: (BuildContext context, int index) {
                        var shop = shops[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    spreadRadius: 0,
                                    blurRadius: 1,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black26)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          shop.id,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "(${shop.name})",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Get.to(() => StoreKeeperItem(shop));
                                          },
                                          child: Container(
                                              width: 170,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  gradient: LinearGradient(
                                                      colors: GRADIANT_COLOR)),
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                child: Text(
                                                  "مشاهده سفارشات",
                                                  style: Get.textTheme.bodyLarge
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                ),
                                              ))),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox();
                      },
                    ),
                  )
                : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}

class StoreKeeperItem extends StatefulWidget {
  StoreKeeper storeKeeper;

  StoreKeeperItem(this.storeKeeper);

  @override
  State<StoreKeeperItem> createState() => _StoreKeeperItemState();
}

class _StoreKeeperItemState extends State<StoreKeeperItem> {
  var _shopService = GetIt.I.get<ShopService>();

  RxList<ShopOrderModel> transactions = <ShopOrderModel>[].obs;
  final _buyIdController = TextEditingController();
  List<ShopOrderModel> allBuy = [];
  final fetch = false.obs;

  @override
  void initState() {
    _shopService.fetchSellOrders(id: widget.storeKeeper.name).then((res) {
      fetch.value = true;
      if (res.isNotEmpty) {
        allBuy.clear();
        transactions.clear();
        transactions.addAll(res);

        allBuy.addAll(transactions);
      }
    });
    _buyIdController.addListener(() {
      var text = _buyIdController.text;
      transactions.clear();
      if (text.isEmpty) {
        transactions.addAll(allBuy);
      } else {
        transactions.addAll(allBuy.where((_) => _.name.contains(text)));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeKeeper.id,
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _buyIdController,
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
          SizedBox(
            height: 10,
          ),
          Obx(() => transactions.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    itemCount: transactions.length,
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () async {
                                    Progressbar.showProgress();
                                    var info = await _shopService
                                        .fetchBuyTransactionsInfo(
                                            transactions[i].name);
                                    Progressbar.dismiss();
                                    if (info != null) {
                                      Get.to(() => TransactionInfoPage(
                                          transactions[i], info));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "خطایی در دریافت اطلاعات رخ داده است");
                                    }
                                  },
                                  child: Container(
                                      width: Get.width * 0.7,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: Get.width * 0.4,
                                                  child: Text(
                                                      maxLines: 1,
                                                      transactions[i].shopName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white)),
                                                ),
                                                Text(
                                                  DateMapper.convert(
                                                      transactions[i].time),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    maxLines: 2,
                                                    transactions[i].status,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white)),
                                                Text(
                                                  transactions[i].name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                      )))
                            ],
                          ),
                        )),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                )
              : !fetch.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text("موردی یافت نشده است.")),
        ],
      ),
    );
  }
}

class TransactionInfoPage extends StatefulWidget {
  TransactionInfo transactionInfo;
  ShopOrderModel code;

  TransactionInfoPage(this.code, this.transactionInfo);

  @override
  State<TransactionInfoPage> createState() => _TransactionInfoPageState();
}

class _TransactionInfoPageState extends State<TransactionInfoPage> {
  var _shopService = GetIt.I.get<ShopService>();
  var _shopRepo = GetIt.I.get<ShopRepo>();

  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "جزئیات معامله",
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Container(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: Get.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        readOnly: true,
                        label: "فروشگاه",
                        value: widget.transactionInfo.store_name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        readOnly: true,
                        label: "روش پرداخت",
                        value: widget.code.paymentType,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        readOnly: true,
                        label: "فروشنده",
                        value: widget.transactionInfo.seller_name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        readOnly: true,
                        label: "خریدار",
                        value: widget.transactionInfo.name_buyer,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        readOnly: true,
                        label: "وضعیت",
                        value: widget.transactionInfo.status,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: " محصولات",
                            labelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        child: Column(
                          children: widget.transactionInfo.transactions
                              .map((t) => Column(
                                    children: [
                                      CustomTextFormField(
                                        readOnly: true,
                                        label: t.supplier_items,
                                        prefix: Text(_shopService
                                                .units[t.supplier_items] ??
                                            ""),
                                        value: t.amount.toString(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        readOnly: true,
                                        prefix: Text("تومان"),
                                        label: "قیمت",
                                        value: t.price.toString(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        readOnly: true,
                                        label: "توضیحات",
                                        maxLine: 3,
                                        value: t.description,
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.transactionInfo.status != "تحویل شده")
                FutureBuilder(
                    future: _shopRepo.getTransactionState(widget.code.name),
                    builder: (c, s) {
                      if (s.connectionState == ConnectionState.waiting ||
                          (s.data?.closed ?? false)) {
                        return SizedBox.shrink();
                      }
                      if (s.data == null) {
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () async {
                              await _shopService.saveAndSendVerificationCode(
                                  widget.code.name,
                                  widget.transactionInfo.id_buyer);
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              width: Get.width * 0.8,
                              child: Center(
                                  child: Text(
                                "ارسال کد تحویل برای خریدار",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              )),
                            ));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  TextEditingController _textController =
                                      TextEditingController();
                                  showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.key,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "کد تحویل را وارد کنید",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    child: TextField(
                                                      autofocus: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLength: 4,
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                      controller:
                                                          _textController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "1234",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black26),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .red),
                                                          //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        // gapSpace: 20,
                                                      ),
                                                      onChanged: (_) {
                                                        if (_.length == 4) {
                                                          _submit(
                                                              _textController,
                                                              c);
                                                        }
                                                      },
                                                      onSubmitted: (_) {
                                                        _submit(
                                                            _textController, c);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent),
                                                  onPressed: () async {
                                                    await _submit(
                                                        _textController, c);
                                                  },
                                                  child: Text("ثبت"))
                                            ],
                                          ));
                                },
                                child: Container(
                                  width: Get.width * 0.3,
                                  child: Center(
                                      child: Text(
                                    "تحویل",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  )),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  _shopService.saveAndSendVerificationCode(
                                      widget.code.name,
                                      widget.transactionInfo.id_buyer);
                                },
                                child: Container(
                                  width: Get.width * 0.3,
                                  child: Center(
                                      child: Text(
                                    "ارسال مجدد کد ",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  )),
                                ))
                          ],
                        ),
                      );
                    })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(
      TextEditingController _textController, BuildContext c) async {
    final transaction = await _shopRepo.getTransactionState(widget.code.name);
    if (_textController.text.length < 4) {
      Fluttertoast.showToast(msg: "کد تحویل اشتباه است");
    } else if (int.parse(_textController.text) ==
        int.parse(transaction!.verificationCode ?? '0')) {
      _shopRepo.saveTransaction(widget.code.name, "", close: true);
      Navigator.pop(c);
      await _shopService.changeTransactionState(widget.code.name);
      await _shopService.closeTransaction(transaction.code);

      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "کد تحویل اشتباه است");
    }
  }
}
