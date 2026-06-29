import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';

class ContributionsController extends GetxController with GetSingleTickerProviderStateMixin{

  int currentIndexForPointSystem = 0;

  late TabController tabviewControllerForPointSystem =
  Get.put(TabController(vsync: this, length: 3));

  void updateCurrentIndexForPointSystem(int index){
    currentIndexForPointSystem = index;
    update();
  }

  TextEditingController donationController = TextEditingController();

  String? selectedGender;
  List<DropdownItem> genders = [
    DropdownItem("मध्य प्रदेश समृद्धि कार्ड", "M"),
    DropdownItem("తెలంగాణ సమృద్ధి కార్డ్", "F"),
    DropdownItem("छत्तीगढ़ हितगृह कार्ड", "O"),
    DropdownItem("राजस्थान महागार्ड राहत कैम्प ", "O")
  ];
  void onChangeGender(String value) {
    selectedGender = value;
    update();
  }
}