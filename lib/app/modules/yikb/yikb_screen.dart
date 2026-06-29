import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/yikb/yikb_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:pinput/pinput.dart';

class YIKBScreen extends StatelessWidget {
  const YIKBScreen();

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
    return GetBuilder<YIKBController>(builder: (logic) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
              onTap: () => Get.back(),
              svgPath: ImageConstant.imgBiarrowleftIndigo800,
              margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v),
            ),
            title: AppbarSubtitle1(
              text: "YIKB Form",
              margin: EdgeInsets.only(left: 12.h),
            ),
            styleType: Style.standard,
            actions: [
              InkWell(
                onTap: () {
                  logic.onChangeLanguage();
                },
                child: Center(
                  child: Container(
                    height: 28,
                    width: 28,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Color(0xff2CC7E2),
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text(
                        '${logic.isEnglish ? 'EN' : 'HI'}'.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavBar(logic),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: logic.personalDetailFormKey,
              child: ListView(
                children: [
                  CustomFloatingTextField(
                    textInputType: TextInputType.text,
                    controller: logic.fullNameController,
                    margin: const EdgeInsets.only(top: 10),
                    labelText: logic.isEnglish ? 'Full Name' : 'पूरा नाम',
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText: logic.isEnglish ? 'Full Name' : 'पूरा नाम',
                    hintStyle: theme.textTheme.bodyLarge!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter full name";
                      }
                      return null;
                    },
                  ),
                  CustomFloatingTextField(
                    readOnly: true,
                    textInputType: TextInputType.text,
                    controller: logic.dobController,
                    margin: const EdgeInsets.only(top: 10),
                    labelText: logic.isEnglish ? 'Date of Birth' : 'जन्म तिथि',
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText: logic.isEnglish ? 'Date of Birth' : 'जन्म तिथि',
                    hintStyle: theme.textTheme.bodyLarge!,
                    onTap: () async {
                      final datePick = await showDatePicker(
                        context: Get.context!,
                        initialDate: new DateTime.utc(
                          int.parse(
                              await LocalStorageServices().getDobEndRange()),
                        ),
                        firstDate: new DateTime(int.parse(
                          await LocalStorageServices().getDobStartRange(),
                        )),
                        lastDate: new DateTime(
                            int.parse(
                              await LocalStorageServices().getDobEndRange(),
                            ),
                            12,
                            31),
                        builder: (BuildContext? context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Constants.themeGradients[1],
                                onPrimary: Colors.black87,
                                surface: Constants.themeGradients[0],
                                onSurface: Constants.themeGradients[1],
                              ),
                              dialogBackgroundColor:
                                  Constants.themeGradients[0],
                            ),
                            child: child!,
                          );
                        },
                      );
                      //await datePicker(context);
                      print(datePick);
                      if (datePick != null && datePick != logic.selectedDate) {
                        logic.onChangeDate(datePick);
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFloatingDropDown(
                    title: logic.isEnglish ? 'Gender' : 'लिंग',
                    value: logic.selectedGender,
                    listValues: logic.gender,
                    onChanged: (value) {
                      logic.onChangeGender(value);
                    },
                    defaultMargin: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFloatingDropDown(
                    title: logic.isEnglish ? 'Category' : 'श्रेणी',
                    value: logic.selectedCategory,
                    listValues: logic.categories,
                    onChanged: (value) {
                      logic.onChangeCategory(value);
                    },
                    defaultMargin: false,
                  ),
                  StateDropDrown(
                      title: logic.isEnglish ? 'State' : 'राज्य',
                      value: logic.selectedState,
                      listValues: logic.stateList,
                      margin: EdgeInsets.only(top: 10),
                      onChanged: (value) => logic.onChangeState(value)),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFloatingDropDown(
                      defaultMargin: false,
                      title: logic.isEnglish ? "Assembly" : 'विधानसभा',
                      value: logic.selectedAssembly,
                      listValues: logic.assemblyDropdownItems,
                      onChanged: (value) {
                        logic.onChangeAssembly(value);
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFloatingDropDown(
                    title: logic.isEnglish
                        ? 'Educational Qualification'
                        : 'सर्वोच्च शैक्षिक योग्यता',
                    value: logic.selectedQualification,
                    listValues: logic.highestQualifications,
                    onChanged: (value) {
                      logic.onChangeQualification(value);
                    },
                    defaultMargin: false,
                  ),
                  if (logic.selectedQualification == 'Others')
                    CustomFloatingTextField(
                      textInputType: TextInputType.text,
                      controller: logic.educationController,
                      margin: const EdgeInsets.only(top: 10),
                      labelText: logic.isEnglish
                          ? 'Educational Qualification'
                          : 'सर्वोच्च शैक्षिक योग्यता',
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: logic.isEnglish
                          ? 'Educational Qualification'
                          : 'सर्वोच्च शैक्षिक योग्यता',
                      hintStyle: theme.textTheme.bodyLarge!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Congress Affiliation";
                        }
                        return null;
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFloatingDropDown(
                    title: logic.isEnglish ? 'Profession' : 'व्यवसाय',
                    value: logic.selectedProfession,
                    listValues: logic.professions,
                    onChanged: (value) {
                      logic.onChangeProfession(value);
                    },
                    defaultMargin: false,
                  ),
                  if (logic.selectedProfession == 'Others')
                    CustomFloatingTextField(
                      textInputType: TextInputType.text,
                      controller: logic.professionController,
                      margin: const EdgeInsets.only(top: 10),
                      labelText: logic.isEnglish ? 'Profession' : 'व्यवसाय',
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: logic.isEnglish ? 'Profession' : 'व्यवसाय',
                      hintStyle: theme.textTheme.bodyLarge!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Profession";
                        }
                        return null;
                      },
                    ),

                  SizedBox(
                    height: 10,
                  ),

                  CustomFloatingDropDown(
                    title: logic.isEnglish
                        ? 'Congress Affiliation'
                        : 'कांग्रेस से संबद्धता',
                    value: logic.selectedCongressAffiliations,
                    listValues: logic.congressAffiliations,
                    onChanged: (value) {
                      logic.onChangeAffiliations(value);
                    },
                    defaultMargin: false,
                  ),
                  if (logic.selectedCongressAffiliations == 'Others')
                    CustomFloatingTextField(
                      textInputType: TextInputType.text,
                      controller: logic.affiliationController,
                      margin: const EdgeInsets.only(top: 10),
                      labelText: logic.isEnglish
                          ? 'Congress Affiliation'
                          : 'कांग्रेस से संबद्धता',
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: logic.isEnglish
                          ? 'Congress Affiliation'
                          : 'कांग्रेस से संबद्धता',
                      hintStyle: theme.textTheme.bodyLarge!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Congress Affiliation";
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: 10),
                  CustomFloatingDropDown(
                    title: logic.isEnglish
                        ? 'Preferred Language'
                        : 'प्राथमिक भाषा',
                    value: logic.selectedLanguage,
                    listValues: logic.preferredLanguages,
                    onChanged: (value) {
                      logic.onChangeSelectedLanguage(value);
                    },
                    defaultMargin: false,
                  ),
                  if (logic.selectedLanguage == 'Regional')
                    CustomFloatingTextField(
                      textInputType: TextInputType.text,
                      controller: logic.preferredLanguageController,
                      margin: const EdgeInsets.only(top: 10),
                      labelText: logic.isEnglish
                          ? 'Preferred Language'
                          : 'प्राथमिक भाषा',
                      labelStyle: theme.textTheme.bodyLarge!,
                      hintText: logic.isEnglish
                          ? 'Preferred Language'
                          : 'प्राथमिक भाषा',
                      hintStyle: theme.textTheme.bodyLarge!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Preferred Language";
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: 10),
                  CustomFloatingDropDown(
                    title: logic.isEnglish
                        ? 'How did you get to Know about YIKB?'
                        : 'How did you get to Know about YIKB?',
                    value: logic.selectedKnowAboutYIKB,
                    listValues: logic.knowAboutYIKB,
                    onChanged: (value) {
                      logic.onChangeKnowAboutYIKB(value);
                    },
                    defaultMargin: false,
                  ),
                  CustomFloatingTextField(
                    textInputType: TextInputType.text,
                    controller: logic.emailController,
                    margin: const EdgeInsets.only(top: 10),
                    labelText: logic.isEnglish ? 'Email' : 'ईमेल',
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText: logic.isEnglish ? 'Email' : 'ईमेल',
                    hintStyle: theme.textTheme.bodyLarge!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                  ),
                  CustomFloatingTextField(
                    textInputType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: logic.phoneController,
                    margin: const EdgeInsets.only(top: 10),
                    labelText:
                        logic.isEnglish ? 'Contact Number' : 'मोबाइल नंबर',
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText:
                        logic.isEnglish ? 'Contact Number' : 'मोबाइल नंबर',
                    hintStyle: theme.textTheme.bodyLarge!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter contact number";
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 200,
                      height: 70,
                      child: Center(
                        child: URoundButton(
                            title: logic.isEnglish
                                ? 'Verification Code'
                                : 'सत्यापन कोड',
                            onTap: () async {
                              final isValid =
                                  logic.phoneController.text.length == 10;
                              if (!isValid) {
                                CustomSnackBar.showWarningSnackBar(
                                    'Enter 10 digit mobile number');
                                return;
                              }
                              logic.getOtp(context);
                            }),
                      ),
                    ),
                  ),
                  if (logic.otpSend) //&& !logic.otpVerified
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                    textInputType: TextInputType.text,
                    controller: logic.referNameController,
                    margin: const EdgeInsets.only(top: 10),
                    labelText: logic.isEnglish ? 'Refer Name' : 'रेफ़र का नाम',
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText: logic.isEnglish ? 'Refer Name' : 'रेफ़र का नाम',
                    hintStyle: theme.textTheme.bodyLarge!,
                    validator: (value) {
                      return null;
                    },
                  ),
                  CustomFloatingTextField(
                    textInputType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: logic.referPhoneController,
                    margin: const EdgeInsets.only(top: 10),
                    labelText: logic.isEnglish
                        ? 'Refer Phone'
                        : 'रेफ़र का मोबाइल नंबर',
                    labelStyle: theme.textTheme.bodyLarge!,
                    hintText: logic.isEnglish
                        ? 'Refer Phone'
                        : 'रेफ़र का मोबाइल नंबर',
                    hintStyle: theme.textTheme.bodyLarge!,
                    validator: (value) {
                      return null;
                    },
                  ),
                  // CustomFloatingTextField(
                  //     textInputType: TextInputType.text,
                  //     // controller: logic.instagramMediaPostLink,
                  //     margin: const EdgeInsets.only(top: 10),
                  //     labelText: 'Instagram',
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: 'Instagram',
                  //     hintStyle: theme.textTheme.bodyLarge!,
                  //     validator: (value) {
                  //       // if (value!.isEmpty) {
                  //       //   return "Please enter No. of people";
                  //       // }
                  //       // return null;
                  //     }),
                  // CustomFloatingTextField(
                  //     textInputType: TextInputType.text,
                  //     // controller: logic.facebookMediaPostLink,
                  //     margin: const EdgeInsets.only(top: 10),
                  //     labelText: 'Facebook',
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: 'Facebook',
                  //     hintStyle: theme.textTheme.bodyLarge!,
                  //     validator: (value) {
                  //       // if (value!.isEmpty) {
                  //       //   return "Please enter No. of people";
                  //       // }
                  //       // return null;
                  //     }),
                  // CustomFloatingTextField(
                  //     textInputType: TextInputType.text,
                  //     // controller: logic.twitterMediaPostLink,
                  //     margin: const EdgeInsets.only(top: 10),
                  //     labelText: 'Twitter',
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: 'Twitter',
                  //     hintStyle: theme.textTheme.bodyLarge!,
                  //     validator: (value) {
                  //       // if (value!.isEmpty) {
                  //       //   return "Please enter No. of people";
                  //       // }
                  //       // return null;
                  //     }),
                  // CustomFloatingTextField(
                  //     textInputType: TextInputType.text,
                  //     // controller: logic.socialMediaPostLink,
                  //     margin: const EdgeInsets.only(top: 10),
                  //     labelText: 'Youtube',
                  //     labelStyle: theme.textTheme.bodyLarge!,
                  //     hintText: 'Youtube',
                  //     hintStyle: theme.textTheme.bodyLarge!,
                  //     validator: (value) {
                  //       // if (value!.isEmpty) {
                  //       //   return "Please enter No. of people";
                  //       // }
                  //       // return null;
                  //     }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(logic.isEnglish
                      ? 'Record Your Video on Nakuri Do Nasha Nahi topic (in 90 Sec) and Upload it here'
                      : 'नौकरी दो नशा नहीं पर अपना (90 सेकेंड) का वीडियो रिकॉर्ड करें और यहां अपलोड करें'),
                  SizedBox(
                    height: 20,
                  ),
                  UploadButtonImage(
                    defaultPadding: true,
                    disableCamera: true,
                    titleText: 'Video',
                    onlyCamera: true,
                    buttonTextLabel: "Upload Video",
                    onTap: (str) {
                      logic.pickVideo(
                          str, logic.pickedFilePathValue, DocumentType.amImage);
                    },
                    pickedFile: logic.pickedFile,
                    showImage: logic.pickedFilePathValue != null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(logic.isEnglish ? ' Declaration' : ' घोषणा',
                  //     style: CustomTextStyles.titleMedium18.copyWith(
                  //       color: appTheme.indigo800,
                  //     )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: logic.declaration,
                          onChanged: (value) {
                            logic.onChangeDeclaration();
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(logic.isEnglish
                            ? 'I hereby declare that all the information provided in this form is accurate and that I am participating in the Young India ke Bol voluntarily. I agree to abide by the rules and decisions of the organizers'
                            : 'मैं hereby घोषणा करता हूँ कि इस फॉर्म में दी गई सभी जानकारी सही है और मैं स्वयं से इंडिया के बोल में भाग ले रहा हूँ। मैं आयोजकों के नियमों और निर्णयों का पालन करने के लिए सहमत हूँ।'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomNavBar(YIKBController logic) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
        bottom: 10.v,
        top: 10.v,
      ),
      decoration: AppDecoration.outlineBlue100011,
      child: CustomElevatedButton(
        text: "NEXT",
        onTap: () => logic.onSubmit(),
      ),
    );
  }
}
