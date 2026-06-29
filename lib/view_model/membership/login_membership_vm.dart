import 'package:flutter/material.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';

class LoginMembershipVM extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final FocusNode mobileFocus = FocusNode();
  final FocusNode verificationCode = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();

  List<States>? stateList;
  List<Districts>? districtList;
  Districts? selectedDistrict;
  States? selectedState;

  getStatesList() async {
    stateList = await DbServices.db.getAllStates();
    notifyListeners();
  }

  changeSelectedState(States state) {
    selectedState = state;
    notifyListeners();
    getDistrictList();
  }

  getDistrictList() async {
    districtList = await DbServices.db.getDistricts(selectedState!);
    notifyListeners();
  }

  changeSelectedDistrict(Districts district) {
    selectedDistrict = district;
    notifyListeners();
  }

  refresh() {
    selectedState = null;
    selectedDistrict = null;
    notifyListeners();
  }
}
