import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/modules/nyay_guarantee/nyay_guarantee_controller.dart';
import 'package:iyc/app/modules/rozgar_nyay_patra/local_widget/language_drop_down.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class NyayGuaranteeScreen extends StatelessWidget {
  const NyayGuaranteeScreen();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromRGBO(126, 203, 224, 1),
        ),
      ),
    );
    return SafeArea(
      child: GetBuilder<NyayGuaranteeController>(builder: (logic) {
        return Scaffold(
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
                text: logic.title[logic.selectedLanguage]
                ['title'],
                margin: EdgeInsets.only(left: 12.h),
              ),
              styleType: Style.standard,
              actions: [
                TextButton(
                  child: Text(
                    "View",
                    style: TextStyle(
                      color: Color(0xff2CC7E2),
                    ),
                  ),
                  onPressed: () async {
                    await toPage(
                        context,
                        ChangeNotifierProvider(
                          create: (context) => ViewCampaignDataVM(),
                          child: ViewCampaignData(
                            campaignId: '12',
                          ),
                        ));
                  },
                ),
                LanguageDropDown(
                    title: 'Language',
                    value: logic.selectedLanguage,
                    listValues: logic.language,
                    onChanged: (value) {
                      logic.onChangedLanguage(value);
                    }),
                Container()
              ],
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Form(
                key: logic.formKey,
                child: ListView(
                  children: [
                    CustomFloatingTextField(
                        controller: logic.nameController,
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        // controller: logic.nameController,
                        labelText: logic.title[logic.selectedLanguage]
                            ['llb_name'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]
                            ['llb_name'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          if (value!.length < 3) {
                            return "Please enter valid text";
                          }
                          return null;
                        }),
                    CustomFloatingTextField(
                        controller: logic.ageController,
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        textInputType: TextInputType.number,
                        labelText: logic.title[logic.selectedLanguage]
                            ['llb_age'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]
                            ['llb_age'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          if (value!.length < 1) {
                            return "Please enter valid Age";
                          }
                          return null;
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]
                            ['llb_gender'],
                        value: logic.selectedGender,
                        listValues: logic.gender[logic.selectedLanguage],
                        onChanged: (value) {
                          logic.onChangeGender(value);
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]
                            ['llb_category'],
                        value: logic.selectedCategory,
                        listValues: logic.category[logic.selectedLanguage],
                        onChanged: (value) {
                          logic.onChangeCategory(value);
                        }),
                    StateDropDrown(
                        title: logic.title[logic.selectedLanguage]['llb_state'],
                        value: logic.selectedState,
                        listValues: logic.stateList,
                        onChanged: (value) {
                          logic.onChangeState(value);
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]
                            ['llb_parliament'],
                        value: logic.selectedParliament,
                        listValues: logic.parliamentDropdownItems,
                        onChanged: (value) {
                          logic.changeParliament(value);
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]
                            ['llb_assembly'],
                        value: logic.selectAssembly,
                        listValues: logic.assemblyDropdownItems,
                        onChanged: (value) {
                          logic.changeAssemblySearch(value);
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: List.generate(
                            logic.inclination[logic.selectedLanguage].length,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.green,
                                          value: logic.selectedInclinationList
                                              .contains(index),
                                          onChanged: (value) {
                                            logic.onClickCheckedBox(index);
                                          }),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                          child: Container(
                                              child: Text(
                                                  '${logic.inclination[logic.selectedLanguage][index].name}', style: theme.textTheme.bodyLarge)))
                                    ],
                                  ),
                                )),
                      ),
                    ),
                    CustomFloatingTextField(
                        controller: logic.mobileController,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        textInputType: TextInputType.number,
                        labelText: logic.title[logic.selectedLanguage]
                            ['llb_mobile'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]
                            ['llb_mobile'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          if (value!.length != 10) {
                            return "Please enter valid Mobile No";
                          }
                          return null;
                        }),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 200,
                        height: 70,
                        child: Center(
                          child: URoundButton(
                              title: logic.title[logic.selectedLanguage]
                                  ['llb_rozgaar_nyay_code'],
                              onTap: () async {
                                final isValid =
                                    logic.mobileController.text.length == 10;
                                if (!isValid) {
                                  CustomSnackBar.showWarningSnackBar('Enter 10 digit mobile number');
                                  return;
                                }
                                logic.getOtp(context);
                              }),
                        ),
                      ),
                    ),
                    if (logic.otpSend ) //&& !logic.otpVerified
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Pinput(
                          length: 6,
                          controller: logic.otpCodeController,
                          defaultPinTheme: defaultPinTheme,
                          followingPinTheme: defaultPinTheme,
                          submittedPinTheme: defaultPinTheme,
                          pinAnimationType: PinAnimationType.fade,
                        ),
                      ),
                    CustomFloatingTextField(
                        textInputType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        controller: logic.leaderMobileController,
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        labelText: logic.title[logic.selectedLanguage]
                            ['llb_leader_mobile'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]
                            ['llb_leader_mobile'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          return null;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container (
                padding: EdgeInsets.only(
                    left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
                decoration: AppDecoration.outlineBlue100011,
                child: CustomElevatedButton(
                    text: logic.title[logic.selectedLanguage]['llb_submit'],
                    onTap: () {
                      if (logic.validateForm(context)) {
                        logic.addCampaign(context);
                      }
                    })));
      }),
    );
  }
}
