import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سفارشات"),
      ),
      body: Center(
        child: Text("سفارشی ثبت نشده است."),
      ),
    );
  }
}
