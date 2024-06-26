import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/SortKey.dart';
import 'package:frappe_app/model/sort_dir.dart';
import 'package:get/get.dart';

class FilterForm extends StatefulWidget {
  List<SortKey> filters;
  SortDir sortDir;
  Function(SortKey) onChangeSortKey;
  Function(SortDir) onChangeSortDir;

  FilterForm(
      {required this.onChangeSortKey,
      required this.onChangeSortDir,
      required this.filters,
      this.sortDir = SortDir.DESC});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  Rx<SortDir> sortDir = SortDir.DESC.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Obx(() => IconButton(
                  onPressed: () {
                    if (sortDir.value == SortDir.DESC) {
                      sortDir.value = SortDir.ASC;
                    } else {
                      sortDir.value = SortDir.DESC;
                    }
                    widget.onChangeSortDir(sortDir.value);
                  },
                  icon: Icon(sortDir.value == SortDir.DESC
                      ? CupertinoIcons.sort_down
                      : CupertinoIcons.sort_up))),
              SizedBox(
                height: 120,
                width: 200,
                child: DropdownButtonFormField<SortKey>(
                  value: widget.filters.first,
                  decoration: InputDecoration(
                      // border: OutlineInputBorder(
                      //   borderSide: const BorderSide(width: 2, color: Colors.red),
                      //   //<-- SEE HERE
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      ),
                  items: widget.filters
                      .map((e) => DropdownMenuItem<SortKey>(
                            value: e,
                            child: Text(e.title),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      widget.onChangeSortKey(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
