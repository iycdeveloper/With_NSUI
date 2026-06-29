import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/campaign/campaign_controller.dart';
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
import 'package:provider/provider.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(
      builder: (logic) {
        return SafeArea(
          child:
          GetBuilder<CampaignController>(builder: (logic) {
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
                    text: logic.appBarTitle[logic.campaignId]![logic.selectedLanguage]!,
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
                        listValues: logic.language[logic.selectedLanguage],
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
                  child:
                  Form(
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
                                logic.options[logic.campaignId][logic.selectedLanguage].length,
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
                                                  '${logic.options[logic.campaignId][logic.selectedLanguage][index].name}', style: theme.textTheme.bodyLarge)))
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
                            labelText: logic.bodyTitle[logic.selectedLanguage]
                            ['llb_leader_mobile'],
                            labelStyle: theme.textTheme.bodyLarge!,
                            hintText: logic.bodyTitle[logic.selectedLanguage]
                            ['llb_leader_mobile'],
                            hintStyle: theme.textTheme.bodyLarge!,
                            validator: (value) {
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
                        text: logic.bodyTitle[logic.selectedLanguage]['llb_submit'],
                        onTap: () {
                          if (logic.validateForm(context)) {
                            logic.addCampaign(context);
                          }
                        }))
            );
          }),
        );
      }
    );
  }
}
