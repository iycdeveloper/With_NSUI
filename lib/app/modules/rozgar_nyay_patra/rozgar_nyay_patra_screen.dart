import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/rozgar_nyay_patra/local_widget/language_drop_down.dart';
import 'package:iyc/app/modules/rozgar_nyay_patra/rozgar_nyay_patra_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class RozgarNyayPatraScreen extends StatelessWidget {
  const RozgarNyayPatraScreen();

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
      child: GetBuilder<RozgarNyayPatraController>(builder: (logic) {
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
                text:logic.title_ ,// logic.isEnglish?"Rozgaar Nyay Patra":"रोज़गार न्याय पत्र",
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
                            campaignId: '9',
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
              onTap: (){
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
                        labelText: logic.title[logic.selectedLanguage]['llb_name'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]['llb_name'],
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
                        labelText: logic.title[logic.selectedLanguage]['llb_age'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]['llb_age'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          if (value!.length < 1) {
                            return "Please enter valid Age";
                          }
                          return null;
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]['llb_gender'],
                        value: logic.selectedGender,
                        listValues: logic.gender[logic.selectedLanguage],
                        onChanged: (value) {
                          logic.onChangeGender(value);
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]['llb_category'],
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
                        title: logic.title[logic.selectedLanguage]['llb_parliament'],
                        value: logic.selectedParliament,
                        listValues: logic.parliamentDropdownItems,
                        onChanged: (value) {
                          logic.changeParliament(value);
                        }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]['llb_assembly'],
                        value: logic.selectAssembly,
                        listValues: logic.assemblyDropdownItems,
                        onChanged: (value) {
                          logic.changeAssemblySearch(value);
                        }),
                    CustomFloatingTextField(
                        controller: logic.educationController,
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        labelText: logic.title[logic.selectedLanguage]['llb_higher_education'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]['llb_higher_education'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          if (value!.length < 1) {
                            return "Please enter valid Highest Educational Qualification";
                          }
                          return null;
                        }),
                    // DistrictDropDrown(
                    //     title: logic.isEnglish ? 'Choose District' : 'लोक सभा',
                    //     value: logic.selectedDistrict,
                    //     listValues: logic.districtList,
                    //     onChanged: (value) {
                    //       logic.onChangeDistrict(value);
                    //     }),
                    // AssemblyDropDrown(
                    //     title:
                    //         logic.isEnglish ? 'Select Assembly Constituency' : 'विधान सभा',
                    //     value: logic.selectedAssembly,
                    //     listValues: logic.assemblyList,
                    //     onChanged: (value) {
                    //       logic.onChangeAssembly(value);
                    //     }),
                    CustomFloatingDropDown(
                        title: logic.title[logic.selectedLanguage]['llb_aspiring_job'],
                        value: logic.selectedJob,
                        listValues: logic.job[logic.selectedLanguage],
                        onChanged: (value) {
                          logic.onChangedJob(value);
                        }),
                    CustomFloatingTextField(
                        controller: logic.mobileController,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        textInputType: TextInputType.number,
                        labelText: logic.title[logic.selectedLanguage]['llb_mobile'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]['llb_mobile'],
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
                              title: logic.title[logic.selectedLanguage]['llb_rozgaar_nyay_code'],
                              onTap: () async {
                                final isValid =
                                    logic.mobileController.text.length == 10;
                                if (!isValid) {
                                  return;
                                }
                                logic.getOtp(context);
                              }),
                        ),
                      ),
                    ),
                    if (logic.otpSend && !logic.otpVerified)
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
                        controller: logic.voterController,
                        margin:
                            EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h),
                        // controller: logic.nameController,
                        labelText: logic.title[logic.selectedLanguage]['llb_voter'],
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: logic.title[logic.selectedLanguage]['llb_voter'],
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          // if (logic.checkBoxTicked) {
                          //   if (value!.length < 10 || value.length > 13)
                          //     return "The length of a Voter ID should be a min of 10 and a max of 13 characters.";
                          // }
                          return null;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Checkbox(
                          value: logic.checkBoxTicked,
                          onChanged: (value) {
                            // context
                            //     .read<AddCampaignMpVM>().validateVoterIdAndShowPopUp();
                            logic.changeCheckBox(!logic.checkBoxTicked);
                          },
                        ), //Checkb
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(logic.title[logic.selectedLanguage]['msg_become_booth_member'],
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
                padding: EdgeInsets.only(
                    left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
                decoration: AppDecoration.outlineBlue100011,
                child: CustomElevatedButton(
                    text: "submit".toUpperCase(),
                    onTap: () {
                      if (logic.validateForm(context)) {
                        logic.addCampaign(context);
                      }
                    })));
      }),
    );
  }
}
