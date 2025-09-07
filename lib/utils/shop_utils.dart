import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:get_it/get_it.dart';

class ShopUtils {
  static List<ShopItemServerModel> extract(List<dynamic> values) {
    var res = <ShopItemServerModel>[];
    values.forEach((element) {
      res.add(ShopItemServerModel(
          name: element[0], id: element[14], group: element[11]));
    });
    return res;
  }

  static Widget shopItemSelector(
      Function(ShopItemServerModel) onSelect, ShopItemServerModel? model) {
    var textController = TextEditingController(text: model?.name);
    return TypeAheadField(
      emptyBuilder: (c) {
        return Text("موردی یافت نشد");
      },
      builder: (c, controller, f) {
        return TextField(
          controller: controller,
          focusNode: f,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: "محصول",
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        return (await GetIt.I.get<ShopService>().searchInShopItem(pattern));
      },
      // Widget to build each suggestion in the list
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name),
        );
      },
      // Callback when a suggestion is selected
      onSelected: (suggestion) {
        textController.text = suggestion.name;
        onSelect(suggestion);
      },
    );
  }
}
