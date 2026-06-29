import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/ch_campaign/ch_campaign_controller.dart';
import 'package:iyc/app/modules/rozgar_nyay_patra/local_widget/language_drop_down.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_ml_button.dart';
import 'package:iyc/screens/ui/home/campaign/view_campaign_data.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class ChCampaignScreen extends StatelessWidget {
  const ChCampaignScreen();

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
      child: GetBuilder<ChCampaignController>(builder: (logic) {
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
                text: logic.title_ ??logic.title[logic.selectedLanguage]
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
                            campaignId: '13',
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
                    UploadButtonMlImage(
                      buttonTextLabel: logic.showProfileImage
                          ? logic.selectedLanguage == 'hi'?'छवि बदलो':"Change Photo"
                          : logic.selectedLanguage == 'hi'?'फोटो अपलोड करें':"Upload Photo",
                      onTap: (str) => logic.pickDocument(str, logic.pickedProfileFilePath,
                          DocumentType.amImage),
                      pickedFile: logic.pickedProfileFile,
                      showImage: logic.showProfileImage,
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text('आप वोट किस आधार पर देंगे?', style: theme.textTheme.bodyLarge,),
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
                          if (value!.length != 10) {
                            return "Please enter valid Leader Mobile No";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 20,
                    ),
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
