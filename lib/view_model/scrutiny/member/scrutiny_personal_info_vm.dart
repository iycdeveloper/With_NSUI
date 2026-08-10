import 'package:iyc/utils/scrutiny_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

class ScrutinyPersonalInfoVM extends ChangeNotifier {
  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();

  TextEditingController dobController = TextEditingController();
  final FocusNode dobFocus = FocusNode();

  String? selectedEducation;
  String? selectedGender;
  String? selectedCategoryId;
  String? selectedDate;

  bool isLoading = false;

  List<DropdownItem> educationalDetailsList = [
    DropdownItem("Graduate", "Graduate")
  ];
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Others", "O"),
  ];
  List<Category>? categoryList;
  DateTime eventDate = DateTime.now();
  String? membershipId;
  bool editMode = false;
  bool enableDobEdit = false;
  bool enableGenderEdit = false;
  bool enableDistrictEdit = false;
  bool disableFields = true;
  List<String> scrutinyCodeList = [];

  ///----------------------------///

  changeGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  changeCategory(String val) {
    selectedCategoryId = val;
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
            : selectedCategoryId == null
                ? showCustomSnackBar("Select Category", context)
                : selectedDate == null
                    ? showCustomSnackBar("Select a date", context)
                    : null;
    //bool isValid = secondFormKey.currentState!.validate();
    bool isValid = (selectedGender != null &&
        selectedDate != null &&
        selectedCategoryId != null &&
        selectedEducation != null);
    return isValid;
  }

  bool mandatoryUploadID = false;
  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}/${timeData.month}/${timeData.year}";
    eventDate = timeData;
    mandatoryUploadID = true;
    notifyListeners();
  }

  checkForPrefillData(BuildContext context) async {
    isLoading = true;
    categoryList = await DbServices.db.getAllCategory();
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    selectedEducation = membershipRequestModel.education;

    selectedGender = membershipRequestModel.gender;

    /// A bare firstWhere here threw "Bad state: No element" and took down the
    /// whole Personal Info page whenever the member's category wasn't in the
    /// local list.
    selectedCategoryId = null;
    for (final category in categoryList ?? []) {
      if (category.categoryCode == membershipRequestModel.category) {
        selectedCategoryId = category.name;
        break;
      }
    }
    selectedDate = membershipRequestModel.dob;

    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = ScrutinyCodes.parse(membershipRequestModel.scrutinyCode);
      Log.printILog("---scrutinyCode");
      scrutinyCodeList.forEach((element) {
        Log.printILog(element);
        // if (element == "18") {
        //   selectedDate = null;
        //   enableDobEdit = true;
        //   disableFields = true;
        // }
        if (element == "10" || element == "18") {
          selectedDate = null;
          enableDobEdit = true;
          disableFields = true;
        }
        if (element == "9") {
          disableFields = true;
          enableDobEdit = true;
        }
        if (element == "1") {
          disableFields = true;
          enableDistrictEdit = true;
        }

        /// 26 = GENDER MISMATCH — let the scrutiniser correct the gender.
        /// The ID re-upload that backs it up is unlocked on the Identity page.
        if (element == ScrutinyCodes.genderMismatch) {
          enableGenderEdit = true;
          disableFields = true;
        }
      });
    }
    isLoading = false;
    notifyListeners();
    return isLoading;
  }

  populateIntoModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipRequestModel.dob = selectedDate;

    /// Gender was never written back, so a code-26 correction would have been
    /// silently discarded.
    membershipRequestModel.gender = selectedGender;

    context
        .read<ScrutinyMembershipEditVM>()
        .setCurrentMember(membershipRequestModel);
  }
}
