import 'package:flutter/cupertino.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

class PersonalInfoVM extends ChangeNotifier {
  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();

  TextEditingController dobController = TextEditingController();
  final FocusNode dobFocus = FocusNode();

  String? selectedEducation;
  String? selectedGender;
  String? selectedCategory;
  String? selectedDate;

  bool isLoading = false;

  List<DropdownItem> educationalDetailsList = [
    DropdownItem("Graduate", "Graduate"),
    DropdownItem("Non Graduate", "NonGraduate")
  ];
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Other", "O"),
  ];
  List<Category>? categoryList;
  DateTime eventDate = DateTime.now();
  String? membershipId;
  bool editMode = false;
  bool enableMediaEdit = false;
  bool enableDOBEdit = false;
  bool enableDistrictEdit = false;
  bool disableFields = false;
  List<String> scrutinyCodeList = [];

  ///----------------------------///

  changeGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  changeCategory(String val) {
    selectedCategory = val;
    notifyListeners();
  }

  changeEducation(String val) {
    selectedEducation = val;
    notifyListeners();
  }

  bool validatePage(BuildContext context) {
    selectedGender == null
        ? showCustomSnackBar("Select Gender", context)
        : selectedEducation == null
            ? showCustomSnackBar("Select Education", context)
            : selectedCategory == null
                ? showCustomSnackBar("Select Category", context)
                : selectedDate == null
                    ? showCustomSnackBar("Select a date", context)
                    : null;
    //bool isValid = secondFormKey.currentState!.validate();
    bool isValid = (selectedGender != null &&
        selectedDate != null &&
        selectedCategory != null &&
        selectedEducation != null);
    return isValid;
  }

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    notifyListeners();
  }

  checkForPrefillData(BuildContext context) async {
    isLoading = true;
    categoryList = await DbServices.db.getAllCategory();

    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    selectedEducation = membershipRequestModel.education;

    selectedGender = membershipRequestModel.gender;
    selectedCategory = membershipRequestModel.category;
    selectedDate = membershipRequestModel.dob;

    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = membershipRequestModel.scrutinyCode!.split(';');
      scrutinyCodeList.forEach((element) {
        if (element == "2") {
          enableMediaEdit = true;
          disableFields = true;
        }
        if (element == "9" || element == "18") {
          disableFields = true;
          enableDOBEdit = true;
        }
        if (element == "1") {
          disableFields = true;
          enableDistrictEdit = true;
        }
      });
    }
    isLoading = false;
    notifyListeners();
    return isLoading;
  }

  populateIntoModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    membershipRequestModel.dob = selectedDate;
    membershipRequestModel.category = selectedCategory;
    membershipRequestModel.gender = selectedGender;
    membershipRequestModel.education = selectedEducation;
    context.read<MembershipVM>().setCurrentMember(membershipRequestModel);
  }
}
