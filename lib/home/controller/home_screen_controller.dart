import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_demo/utills/pref_string.dart';
import 'package:todo_list_demo/utills/preferences.dart';

class HomeScreenController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController editSubTitleController = TextEditingController();
  List<dynamic> getData = [];

  bool isLod = false;

  bool isConform = false;

  @override
  void onInit() {
    // TODO: implement onInit
    getValue();
    super.onInit();
  }

  void getValue() {
    isLod = true;
    if (PrefService.getString(PrefString.data).isNotEmpty) {
      getData = jsonDecode(PrefService.getString(PrefString.data));
    }
    isLod = false;
    print("getData--->$getData");
    update(["data"]);
  }

  void onSave() {
    List<dynamic> newData = [
      {
        "title": titleController.text,
        "subTitle": subTitleController.text,
        "conform": false,
      }
    ];
    if (PrefService.getString(PrefString.data).isNotEmpty) {
      List oldData = jsonDecode(PrefService.getString(PrefString.data));
      oldData.map((e) {
        newData.add(e);
      }).toList();
    }
    PrefService.clearPref();
    PrefService.setValue(PrefString.data, jsonEncode(newData)).then((value) {
      Get.back();
      getValue();
      titleController.clear();
      subTitleController.clear();
    });
    update(["data"]);
  }

  void onDialogEdit(BuildContext context, index) {
    List editData = [];
    if (PrefService.getString(PrefString.data).isNotEmpty) {
      editData = jsonDecode(PrefService.getString(PrefString.data));
    }
    editTitleController.text = editData[index]["title"];
    editSubTitleController.text = editData[index]["subTitle"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: editTitleController,
                    ),
                    TextFormField(
                      controller: editSubTitleController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          color: Colors.green,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () => onEdit(editTitleController.text,
                              editSubTitleController.text, index),
                          child: const Text("Save Change"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onEdit(String title, String subTitle, index) {
    List editData = [];
    if (PrefService.getString(PrefString.data).isNotEmpty) {
      editData = jsonDecode(PrefService.getString(PrefString.data));
    }
    editData[index] = {
      "title": title,
      "subTitle": subTitle,
      "conform": false,
    };
    PrefService.clearPref();
    PrefService.setValue(PrefString.data, jsonEncode(editData)).then((value) {
      Get.back();
      getValue();
      titleController.clear();
      subTitleController.clear();
    });
    update(["data"]);
  }

  void onClear(data) {
    List deleteData = [];
    if (PrefService.getString(PrefString.data).isNotEmpty) {
      deleteData = jsonDecode(PrefService.getString(PrefString.data));
    }
    deleteData.removeWhere((element) => mapEquals(element, data));
    PrefService.clearPref();
    PrefService.setValue(PrefString.data, jsonEncode(deleteData)).then((value) {
      getValue();
    });
    update(["data"]);
  }

  void onConform(index) {
    List conformData = [];
    if (PrefService.getString(PrefString.data).isNotEmpty) {
      conformData = jsonDecode(PrefService.getString(PrefString.data));
    }
    conformData[index] = {
      "title": conformData[index]["title"],
      "subTitle": conformData[index]["subTitle"],
      "conform": true,
    };
    PrefService.clearPref();
    PrefService.setValue(PrefString.data, jsonEncode(conformData))
        .then((value) {
      getValue();
      titleController.clear();
      subTitleController.clear();
    });
    update(["data"]);
  }
}
