import 'package:iyc/utils/scrutiny_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:provider/provider.dart';

class ScrutinyBasicInfoVM extends ChangeNotifier {
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode professionFocus = FocusNode();
  final FocusNode fatherNameFocus = FocusNode();
  List<BatchMember> _membershipRequestList = [];

  List<BatchMember> get membershipRequestList => _membershipRequestList;
  String? membershipId;

  bool enableNameEdit = false;
  bool enableRelationEdit = false;
  bool disableFields = true;
  List<String> scrutinyCodeList = [];

  refresh() {
    try {
      membershipId = "";
      usernameController.clear();
      lastNameController.clear();
      professionController.clear();
      fatherNameController.clear();
      // firstFormKey.currentState!.reset();
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  setFirstFormKey(GlobalKey<FormState> formKey) {
    firstFormKey = formKey;
  }

  bool validateForm() {
    final isValid = firstFormKey.currentState!.validate();
    firstFormKey.currentState!.save();
    notifyListeners();
    return isValid;
  }

  populateMembershipModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipRequestModel.firstName = usernameController.text;
    membershipRequestModel.lastName = lastNameController.text;
    membershipRequestModel.profession = professionController.text;
    membershipRequestModel.relativeName = fatherNameController.text;
    context
        .read<ScrutinyMembershipEditVM>()
        .setCurrentMember(membershipRequestModel);
  }

  checkPrefillData(BuildContext context) {
    /// for edit mode fetch data from table
    final value = context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipId = value.memberId;
    usernameController.text = value.firstName ?? "";
    lastNameController.text = value.lastName ?? "";
    professionController.text = value.profession ?? "";
    fatherNameController.text = value.relativeName ?? "";
    if (value.scrutinyCode != null) {
      scrutinyCodeList = ScrutinyCodes.parse(value.scrutinyCode);
      Log.printILog("ScrutinyCode ${value.scrutinyCode}");
      scrutinyCodeList.forEach((element) {
        // if (element == "23") {
        //   enableNameEdit = true;
        //   disableFields = true;
        // }
        if (element == "22") {
          enableNameEdit = true;
          // disableFields = true;
          disableFields = true;
          enableRelationEdit = true;
        }
        if (element == "1") {
          disableFields = true;
        }
        if (element == "2") {
          // enableNameEdit = true;
          // enableRelationEdit = true;
          // disableFields = true;
        }
      });
    }
  }
}
