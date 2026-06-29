import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/provider/membership_register/membership_api_providers/membership_list_provider.dart';
import 'package:iyc/screens/ui/membership_ui/primary_member/add_primary_members.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/members/members_list_vm.dart';
import 'package:iyc/view_model/membership/add_primary_member_vm.dart';
import 'package:iyc/view_model/membership/personal_info_vm.dart';
import 'package:provider/provider.dart';

import '../../di_container.dart';
import 'basic_info_vm.dart';
import 'candidates_info_vm.dart';
import 'constituency_info_vm.dart';
import 'contact_info_vm.dart';
import 'identity_info_vm.dart';

class MembershipVM extends ChangeNotifier {
  final MembershipMemberDB membershipDbRepo = sl<MembershipMemberDB>();

  MembershipVM() {
    pageController = PageController(initialPage: pageNumber);
  }

  late PageController pageController;
  int pageNumber = 0;
  int activeStep = 0; // Initial step set to 5.

  BatchMember? currentMember;
  bool isLegalCellReg = false;
  bool isLoading = false;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void activeStepChange(int index) {
    activeStep++;
    pageNumber = index;
    notifyListeners();
  }

  void activeStepDown(int index) {
    activeStep--;
    pageNumber = index;
    notifyListeners();
  }

  void pageNumberChange(int index) {
    pageNumber = index;
    notifyListeners();
  }

  void activeStepPrevious() {
    pageController.previousPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    activeStep--;
    notifyListeners();
  }

  Future<void> oneNext(int page, BuildContext context) async {
    FocusScope.of(context).unfocus();
    print("next call");
    switch (page) {
      case 0:
        {
          print("on next from 0");
          if (context.read<BasicInfoVM>().validateForm()) {
            context.read<BasicInfoVM>().populateMembershipModel(context);
            pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            activeStepChange(page);
          }
        }
        break;
      case 1:
        {
          print("on next from 1");
          if (context.read<PersonalInfoVM>().validatePage(context)) {
            context.read<PersonalInfoVM>().populateIntoModel(context);
            context.read<ContactInfoVM>().checkPrefillData(context);
            pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            activeStepChange(page);
          }
        }
        break;
      case 2:
        {
          print("on next from 2");
          if (context
                  .read<ContactInfoVM>()
                  .thirdFormKey
                  .currentState!
                  .validate() &&
              await context.read<ContactInfoVM>().validatePage(context)) {
            context.read<ContactInfoVM>().populateModel(context);
            await context.read<IdentityInfoVM>().checkpreFillData(context);
            pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            activeStepChange(page);
          }
        }
        break;
      case 3:
        {
          print("on next from 3");
          if (context.read<IdentityInfoVM>().validatePage(context)) {
            context.read<IdentityInfoVM>().populateToModel(context);
            context.read<ConstituencyInfoVM>().checkForPrefillData(context);
            pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            activeStepChange(page);
          }
        }
        break;
      case 4:
        {
          print("on next from 4");
          if (context.read<ConstituencyInfoVM>().validatePage(context)) {
            context.read<ConstituencyInfoVM>().populateIntoModel(context);
            await context.read<CandidatesInfoVM>().checkForPrefill(context);
            pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            activeStepChange(page);
          }
        }
        break;
      case 5:
        {
          print("on next from 5");

          pageController.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepChange(page);
        }
        break;
      case 6:
        {
          print("on next from 5");

          pageController.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepChange(page);
        }
        break;
      default:
        print("default");
    }
  }

  Future<void> onePrevious(int page, BuildContext context) async {
    FocusScope.of(context).unfocus();

    print("pre call");
    switch (page) {
      case 0:
        {
          print("on next from 0");
          pageController.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepDown(page);
        }
        break;
      case 1:
        {
          print("on next from 1");
          pageController.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepDown(page);
        }
        break;
      case 2:
        {
          print("on next from 2");
          pageController.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepDown(page);
        }
        break;
      case 3:
        {
          print("on next from 3");
          pageController.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepDown(page);
        }
        break;
      case 4:
        {
          print("on next from 4");
          pageController.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepDown(page);
        }
        break;
      case 5:
        {
          print("on next from 5");

          pageController.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          activeStepDown(page);
        }
        break;
      default:
        print("default");
    }
  }

  Future<void> submitLegalCell(BuildContext context) async {
    Navigator.of(context).pop(currentMember);
  }

  Future<void> onSubmit(BuildContext context, bool isUpdate) async {
    if (context.read<CandidatesInfoVM>().validatePage(context)) {
      context.read<CandidatesInfoVM>().populateModel(context);
      try {
        await memberSaveToDB(context, isUpdate);
      } catch (e) {
        print(e);
      }
      // if (false) {
      // } else {
      //   Navigator.of(context).pop();
      // }
    }
  }

  void setCurrentMember(BatchMember membershipRequestModel,
      [bool? isLegalCellReg]) {
    currentMember = membershipRequestModel;
    if (isLegalCellReg != null) this.isLegalCellReg = isLegalCellReg;
  }

  Future<void> memberSaveToDB(BuildContext context, bool isUpdate) async {
    if (isUpdate) {
      await membershipDbRepo.updateMembershipTable(currentMember!);
      getVerificationBottomSheet(context);
    } else {
      await membershipDbRepo.insertData(currentMember!);
      final list = await membershipDbRepo.getData(currentMember!.batchId!);
      int count = list.length;
      await sl<BatchDBRepo>().updateAMCount(
          BatchDataModel(batchId: currentMember!.batchId!, countAM: count));
      getVerificationBottomSheet(context);
      // context
      //     .read<MembersListVM>()
      //     .getMembershipList(context, currentMember!.batchId!);
    }
  }

  getVerificationBottomSheet(BuildContext context) {
    TextEditingController sumController = TextEditingController();
    var random = Random();
    int randomNumber1 = random.nextInt(98) + 1;
    int randomNumber2 = random.nextInt(98) + 1;
    mediaQueryData = MediaQuery.of(context);
    Get.bottomSheet(
      Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          width: double.maxFinite,
          height: 372.v,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      color: appTheme.indigo800,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
                  // decoration: AppDecoration.heading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Verification",
                          style:
                              CustomTextStyles.titleMediumOnPrimaryContainer18),
                      // AppbarImage1(
                      //   onTap: () {
                      //     Get.back();
                      //   },
                      //   svgPath: ImageConstant.imgEpcircleclose,
                      // ),
                      const SizedBox()
                    ],
                  )),
              SizedBox(height: 33.v),
              CustomImageView(
                  svgPath: ImageConstant.imgTrash,
                  height: 69.adaptSize,
                  width: 69.adaptSize),
              SizedBox(height: 25.v),
              Text("$randomNumber1 + $randomNumber2 = ?",
                  style: theme.textTheme.titleLarge),
              SizedBox(height: 9.v),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: sumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter sum of above number',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Circular border
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.v),
              CustomOutlinedButton(
                  width: 220.h,
                  text: "Submit".toUpperCase(),
                  buttonStyle: CustomButtonStyles.outlinePrimary,
                  onTap: () {
                    if (sumController.text.isEmpty) {
                      // Get.back();
                      CustomSnackBar.showErrorSnackBar('Verification failed');
                    }
                    if (randomNumber1 + randomNumber2 ==
                        int.parse(sumController.text)) {
                      Get.back();
                      Navigator.of(context).pop('verification completed');

                      // print('object');
                      // context
                      //     .read<MembersListVM>()
                      //     .initiateSyncMembership(context);
                    } else {
                      // Get.back();
                      CustomSnackBar.showErrorSnackBar('Verification failed');
                    }
                  }),
              SizedBox(height: 5.v)
            ]),
          )),
    );
  }
}
