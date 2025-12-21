import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/views/desk/shop/seller_steps.dart';

import 'all_shop_page.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          bottom: const TabBar(
            tabs: [
              Tab(text: "فروشگاه من"),
              Tab(text: "فرایند فروش"),
            ],
          ),
        ),
        body: TabBarView(
          children: [AllShopPage(), SellerSteps()],
        ),
      ),
    );
  }
}
