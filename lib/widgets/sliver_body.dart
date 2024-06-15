import 'package:flutter/cupertino.dart';

Widget sliverBody(Widget body) {
  return SliverList(delegate: SliverChildListDelegate([body]));
}
