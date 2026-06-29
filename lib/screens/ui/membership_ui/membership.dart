import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/membership_ui/basic_info_page.dart';
import 'package:iyc/screens/ui/membership_ui/candidates_info_page.dart';
import 'package:iyc/screens/ui/membership_ui/constituency_info_page.dart';
import 'package:iyc/screens/ui/membership_ui/contact_info_page.dart';
// import 'package:iyc/screens/ui/membership_ui/identity_info_page.dart';
import 'package:iyc/screens/ui/membership_ui/personal_info_page.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/membership/add_primary_member_vm.dart';
import 'package:iyc/view_model/membership/basic_info_vm.dart';
import 'package:iyc/view_model/membership/candidates_info_vm.dart';
import 'package:iyc/view_model/membership/constituency_info_vm.dart';
import 'package:iyc/view_model/membership/contact_info_vm.dart';
import 'package:iyc/screens/ui/membership_ui/identity_info_page.dart';
import 'package:iyc/view_model/membership/identity_info_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:iyc/view_model/membership/personal_info_vm.dart';
import 'package:provider/provider.dart';

import '../../../di_container.dart';

class MemberShip extends StatefulWidget {
  const MemberShip(
      {Key? key,
      required this.member,
      this.isUpdate = false,
      this.isLegalCell = false})
      : super(key: key);

  final BatchMember member;
  final bool isUpdate;
  final bool isLegalCell;

  @override
  _MemberShipState createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  @override
  void initState() {
    print("Is update is ${widget.isUpdate}");
    context
        .read<MembershipVM>()
        .setCurrentMember(widget.member, widget.isLegalCell);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BasicInfoVM()),
        ChangeNotifierProvider(
          create: (context) => PersonalInfoVM(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContactInfoVM(apiConfig: sl()),
        ),
        ChangeNotifierProvider(
          create: (context) => IdentityInfoVM(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConstituencyInfoVM(),
        ),
        if (!widget.isLegalCell)
          ChangeNotifierProvider(
            create: (context) => CandidatesInfoVM(),
          ),
        ChangeNotifierProvider(
          create: (context) => AddPrimaryMemberVM(),
        ),
      ],
      builder: (context1, _) => Consumer<MembershipVM>(
        builder: (_, model, __) => SafeArea(
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                onTap: Get.back,
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(
                  left: 20.h,
                  top: 15.v,
                  bottom: 15.v,
                ),
              ),
              title: AppbarSubtitle1(
                text: widget.member.memberId!,
                // margin: EdgeInsets.only(left: 12.h),
              ),
              styleType: Style.standard,
            ),

            body: Column(
              children: [
                NumberStepper(
                  stepColor: Constants.themeGradients[1],
                  numbers: [
                    1,
                    2,
                    3,
                    4,
                    5,
                    if (!widget.isLegalCell) 6,
                    // 7
                    //if (['U1','U2', 'U3'].contains(widget.member.memberId!.substring(0,2))) 7
                  ], // legal cell condition checking
                  stepRadius: 20,
                  enableNextPreviousButtons: false, steppingEnabled: false,
                  nextButtonIcon: const Icon(
                    Icons.navigate_next_outlined,
                    size: 30,
                  ),
                  previousButtonIcon: const Icon(
                    Icons.navigate_before_outlined,
                    size: 30,
                  ),
                  activeStep: model.activeStep,
                  onStepReached: (index) {
                    model.pageNumber > index
                        ? model.onePrevious(index, context1)
                        : model.oneNext(index, context1);
                    // model.pageNumber =index;
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: model.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      model.pageNumberChange(page);
                    },
                    children: [
                      BasicInfoPage(),
                      const PersonalInfoPage(),
                      const ContactInfoPage(),
                      const IdentityInfoPage(),
                      const ConstituencyInfoPage(),
                      if (!widget.isLegalCell)
                        CandidatesInfoPage(
                          isUpdate: widget.isUpdate,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // bottomNavigationBar:
          ),
        ),
      ),
    );
  }
}
