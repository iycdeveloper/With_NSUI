import 'package:flutter/cupertino.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

class BasicInfoVM extends ChangeNotifier {
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

  bool enableMediaEdit = false;
  bool enableDOBEdit = false;
  bool disableFields = false;
  List<String> scrutinyCodeList = [];

  refresh() {
    try {
      membershipId = "";
      usernameController.clear();
      lastNameController.clear();
      professionController.clear();
      fatherNameController.clear();
      firstFormKey.currentState!.reset();
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
        context.read<MembershipVM>().currentMember!;
    membershipRequestModel.firstName = usernameController.text;
    membershipRequestModel.lastName = lastNameController.text;
    membershipRequestModel.profession = professionController.text;

    ///TODO: need to make dynamic
    membershipRequestModel.relativeName = fatherNameController.text;
    membershipRequestModel.relationCode = "F";
  }

  checkPrefillData(BuildContext context) {
    /// for edit mode fetch data from table
    final value = context.read<MembershipVM>().currentMember!;
    membershipId = value.memberId;
    usernameController.text = value.firstName ?? "";
    lastNameController.text = value.lastName ?? "";
    professionController.text = value.profession ?? "";
    fatherNameController.text = value.relativeName ?? "";
    if (context.read<MembershipVM>().isLegalCellReg)
      professionController.text = "Lawyer";
  }
}

// updatePersonDetails(BuildContext context) {
//    ///
//
//        MembershipSaveSqlProvider(databaseSql: sl()).updatePersonDataSql(
//            context: context,
//            data: MembershipRequestModel(
//                membershipId: membershipId,
//                firstname: usernameController.text,
//                lastname: lastNameController.text,
//                profession: professionController.text,
//                fatherName: fatherNameController.text));
//  }
