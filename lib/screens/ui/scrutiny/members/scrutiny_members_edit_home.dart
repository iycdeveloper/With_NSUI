import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_members_list_vm.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_basic_info_vm.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_constituency_info_vm.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_contact_info_vm.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_identity_info_vm.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_personal_info_vm.dart';
import 'package:provider/provider.dart';

import 'forms/scrutiny_basic_info.dart';
import 'forms/scrutiny_contact_details.dart';
import 'forms/scrutiny_identity_info.dart';
import 'forms/scrutiny_personal_info.dart';

class ScrutinyMembershipEditHomePage extends StatefulWidget {
  const ScrutinyMembershipEditHomePage(
      {Key? key,
      required this.member,
      this.isUpdate = false,
      required this.scrutinyMembersListVM})
      : super(key: key);
  final BatchMember member;
  final bool isUpdate;
  final ScrutinyMembersListVM scrutinyMembersListVM;

  @override
  _ScrutinyMembershipEditHomePageState createState() =>
      _ScrutinyMembershipEditHomePageState();
}

class _ScrutinyMembershipEditHomePageState
    extends State<ScrutinyMembershipEditHomePage> {
  late PageController _pageController;
  int pageNumber = 0;
  late int fixedPageIndex;

  @override
  void initState() {
    context.read<ScrutinyMembershipEditVM>().onInit();
    fixedPageIndex = 3;
    context.read<ScrutinyMembershipEditVM>().setCurrentMember(widget.member);
    _pageController = PageController(initialPage: pageNumber);
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScrutinyBasicInfoVM()),
        ChangeNotifierProvider(
          create: (context) => ScrutinyPersonalInfoVM(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScrutinyContactInfoVM(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScrutinyIdentityInfoVM(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScrutinyConstituencyInfoVM(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScrutinyConstituencyInfoVM(),
        ),
      ],
      builder: (context1, _) => Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageNumber = page;
            });
          },
          children: [
            ScrutinyBasicInfo(),
            ScrutinyPersonalInfoPage(),
            ScrutinyContactDetails(),
            ScrutinyIdentityInfoPage(),
            // ScrutinyConstituencyInfoPage(),
          ],
        ),
        bottomNavigationBar: pageNumber != fixedPageIndex
            ? URoundButton(
                title: "Next", onTap: () => oneNext(pageNumber, context1))
            : URoundButton(title: "Submit", onTap: () => onSubmit(context1)),
      ),
    );
  }

  Future<void> oneNext(int page, BuildContext context) async {
    switch (page) {
      case 0:
        {
          print("on next from 0");
          if (context.read<ScrutinyBasicInfoVM>().validateForm()) {
            context
                .read<ScrutinyBasicInfoVM>()
                .populateMembershipModel(context);
            _pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }
        }
        break;
      case 1:
        {
          print("on next from 1");
          if (context.read<ScrutinyPersonalInfoVM>().validatePage(context)) {
            context.read<ScrutinyPersonalInfoVM>().populateIntoModel(context);
            context.read<ScrutinyContactInfoVM>().checkPrefillData(context);
            _pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }
        }
        break;
      case 2:
        {
          Log.printILog("on next from 2");
          if(context
              .read<ScrutinyContactInfoVM>().disabledContactEditing){
            if (context
                .read<ScrutinyContactInfoVM>()
                .thirdFormKey
                .currentState!
                .validate()) {
              context.read<ScrutinyContactInfoVM>().populateModel(context);
              await context
                  .read<ScrutinyIdentityInfoVM>()
                  .checkpreFillData(context);
              _pageController.nextPage(
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            }
          }
          else{
            await context
                .read<ScrutinyContactInfoVM>().verifyOtpForMember();
            if(context
                .read<ScrutinyContactInfoVM>().otpVerified){
              if (context
                  .read<ScrutinyContactInfoVM>()
                  .thirdFormKey
                  .currentState!
                  .validate()) {
                context.read<ScrutinyContactInfoVM>().populateModel(context);
                await context
                    .read<ScrutinyIdentityInfoVM>()
                    .checkpreFillData(context);
                _pageController.nextPage(
                    duration: Duration(milliseconds: 200), curve: Curves.easeIn);
              }
            }
          }

        }
        break;
      case 3:
        {
          ///

          print("on next 3");
          if (context.read<ScrutinyIdentityInfoVM>().validatePage(context)) {
            context.read<ScrutinyIdentityInfoVM>().populateToModel(context);
            context
                .read<ScrutinyConstituencyInfoVM>()
                .checkForPrefillData(context);
            _pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }
        }
        break;
      default:
        print("default");
    }
  }

  onSubmit(BuildContext context) async {
    Log.printILog('Is update ${widget.isUpdate}');
    if (context.read<ScrutinyIdentityInfoVM>().validatePage(context)) {
      context.read<ScrutinyIdentityInfoVM>().populateToModel(context);
      await Provider.of<ScrutinyMembershipEditVM>(context, listen: false)
          .scrutinyMemberSaveToDB(context, widget.isUpdate);
      // await Provider.of<ScrutinyMembersListVM>(context, listen: false)
      //     .getScrutinyMembersList(context, widget.member.batchId!);;
      // await context
      //     .read<ScrutinyMembersListVM>()
      //     .syncScrutinyBatch(context);
      // Navigator.of(context).pop();
      Navigator.pop(context, "reload");
    }
  }
}
