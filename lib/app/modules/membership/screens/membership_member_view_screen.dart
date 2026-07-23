import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_view_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/loading_widget.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/nusi/widgets/upload_button_nsui.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:pinput/pinput.dart';

class MembershipMemberviewScreen extends StatelessWidget {
  const MembershipMemberviewScreen();

  @override
  Widget build(BuildContext context) {
      //  Color _indigo = Color(0xFF1356BF);

    return SafeArea(
      child: GetBuilder<MembershipMemberViewController>(
        builder: (logic) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFF),
            appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                onTap: () => Get.back(),
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v),
              ),
              title: AppbarSubtitle1(
                text: "${logic.member.memberId}",
                margin: EdgeInsets.only(left: 12.h),
              ),
              styleType: Style.standard,
            ),
            bottomNavigationBar: _buildBottomNavBar(logic, context),
            body: logic.isLoading
                ? const LoadingWidget()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStepper(logic),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Step ${logic.activeStep + 1} - ${logic.steps['${logic.activeStep + 1}']}',
                          style: const TextStyle(
                            color: Color(0xFF244974),
                            fontFamily: 'Be Vietnam Pro',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          pageSnapping: true,
                          controller: logic.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (page) {
                            logic.pageNumberChange(page);
                          },
                          children: [
                            _basicDetails(logic, context),
                            _consistencyDetails(logic),
                            _identityDetails(logic, context),
                            _candidateDetails(logic,context)
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildStepper(MembershipMemberViewController logic) {
    return Container(
      height: 76.v,
      width: double.infinity,
      color: const Color(0xFF244974),
      child: EasyStepper(
        activeStep: logic.activeStep,
        // lineLength: 40,
        // lineSpace: 0,
        // lineType: LineType.normal,
        // defaultLineColor: const Color(0xFFC0D5F3),
        // finishedLineColor: const Color(0xFFC0D5F3),
        activeStepTextColor: Colors.black87,
        finishedStepBackgroundColor: Colors.transparent,
        finishedStepTextColor: Colors.black87,
        internalPadding: 0,
        showLoadingAnimation: false,
        showStepBorder: false,
        stepShape: StepShape.rRectangle,
        stepBorderRadius: 15,
        padding: const EdgeInsetsDirectional.all(0),
        steps: List.generate(
          logic.steps.keys.length,
          (index) => EasyStep(
            customStep: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: logic.activeStep >= index
                    ? Color(0xFFF28812)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: const Color(0xFFC0D5F3)),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFFC0D5F3),
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
        // onStepReached: logic.updateStepperIndex,
      ),
    );
  }

  Widget _buildBottomNavBar(
      MembershipMemberViewController logic, BuildContext context) {
    if (logic.activeStep == 0) {
      return Container(
        padding: EdgeInsets.only(
          left: 20.h,
          right: 20.h,
          bottom: 10.v,
          top: 10.v,
        ),
        decoration: AppDecoration.outlineBlue100011,
        child: CustomElevatedButton(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 0.5, blurRadius: 0.5)
              ]),
          buttonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
          text: "NEXT",
          onTap: () => logic.next(context),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
        bottom: 10.v,
        top: 10.v,
      ),
      decoration: AppDecoration.outlineBlue100011,
      child: Row(
        children: [
          InkWell(
            onTap: logic.previous,
            child: Container(
              width: 158,
              height: 54,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200]!,
                      spreadRadius: 0.8,
                      blurRadius: 0.8)
                ],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC0D5F3),
                  width: 1.0,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text("Previous".toUpperCase()),
              ),
            ),
          ),
          const Spacer(),
          CustomElevatedButton(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 0.5, blurRadius: 0.5)
                ]),
            buttonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
            width: 158,
            text: logic.activeStep == 3 ? "SUBMIT" : "NEXT",
            onTap: () => logic.activeStep == 3
                ? logic.onSubmit(Get.context!)
                : logic.next(context),
          ),
        ],
      ),
    );
  }

  Widget _basicDetails(
          MembershipMemberViewController logic, BuildContext context) =>
      Form(
        key: logic.basicDetailFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Full Name",
                hintText: "Full Name",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.usernameController,
                validation: (value) {
                  if (value.isEmpty) {
                    return 'Enter a Full Name';
                  }
                  return null;
                },
              ), //
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,

                labelcolor: theme.textTheme.bodyLarge!.color,

                label: "Father's Name",
                hintText: "Father's Name",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.fatherNameController,
                validation: (value) {
                  if (value.isEmpty) {
                    return "Enter a Father's Name";
                  }
                  return null;
                },
              ),
              Form(
                key: logic.mobileFormKey,
                child: TextFieldWithLabelNSUI(
                  readOnly: logic.isUpdate,

                  labelcolor: theme.textTheme.bodyLarge!.color,

                  label: "Mobile Number",
                  hintText: "Mobile Number",
                  maxLength: 10,

                  // focusNode: model.usernameFocus,
                  // nextFocus: model.lastNameFocus,

                  // readOnly: model.disableFields,
                  keyBoardType: TextInputType.name,
                  controller: logic.mobileController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter a Mobile Number';
                    }
                    return null;
                  },
                ),
              ),

              TextFieldWithLabelNSUI(
                readOnly: true,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Email",
                hintText: "Email",
                keyBoardType: TextInputType.name,
                controller: logic.emailController,
              ),
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Date of Birth",
                hintText: "Date of Birth",
                keyBoardType: TextInputType.name,
                controller: logic.usernameController,
              ),

              TextFieldWithLabelNSUI(
                readOnly: true,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Gender",
                hintText: "Gender",
                keyBoardType: TextInputType.name,
                controller: logic.genderController,
              ),
              TextFieldWithLabelNSUI(
                readOnly: true,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Category",
                hintText: "Category",
                keyBoardType: TextInputType.name,
                controller: logic.categoryController,
              ),
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,

                label: "Course",
                hintText: "Course",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.courseController,
              ),
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Permanent Address",
                hintText: "Permanent Address",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.addressController,
                validation: (value) {
                  if (value.isEmpty) {
                    return 'Enter a permanent ddress';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );

  PinTheme defaultPinTheme() {
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
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
  }

  Widget _personalDetail(MembershipMemberViewController logic) => Form(
        key: logic.personalDetailFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomFloatingDropDown(
                readOnly: logic.isUpdate,
                title: 'Gender',
                value: logic.selectedGender,
                listValues: logic.gender,
                onChanged: (value) {
                  logic.onChangeGender(value);
                },
                defaultMargin: false,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFloatingDropDown(
                readOnly: logic.isUpdate,
                title: 'Education',
                value: logic.selectedEducation,
                listValues: logic.educationalDetailsList,
                onChanged: (value) {
                  logic.onChangeEducation(value);
                },
                defaultMargin: false,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFloatingDropDown(
                readOnly: logic.isUpdate,
                title: 'Category',
                value: logic.selectedCategory,
                listValues: logic.category,
                onChanged: (value) {
                  logic.onChangeCategory(value);
                },
                defaultMargin: false,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFloatingTextField(
                readOnly: true,
                textInputType: TextInputType.text,
                controller: logic.dobController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'DOB',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Date of birth',
                hintStyle: theme.textTheme.bodyLarge!,
                onTap: () async {
                  if (logic.isUpdate) return;
                  final datePick = await showDatePicker(
                    context: Get.context!,
                    initialDate: new DateTime.utc(
                      int.parse(await LocalStorageServices().getDobEndRange()),
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
                          dialogBackgroundColor: Constants.themeGradients[0],
                        ),
                        child: child!,
                      );
                    },
                  );
                  //await datePicker(context);
                  print(datePick);
                  if (datePick != null && datePick != logic.eventDate) {
                    logic.onChangeDate(datePick);
                  }
                },
              ),
            ],
          ),
        ),
      );

  Widget _contactDetails(MembershipMemberViewController logic) => Form(
        key: logic.contactDetailFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                controller: logic.mobileController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Mobile Number',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Mobile Number',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter mobile number";
                  }
                  return null;
                },
              ),
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.emailAddress,
                controller: logic.emailController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Email',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Email',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) => value!.isValidEmail()
                    ? null
                    : "Enter a Valid Email Address",
              ),
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.text,
                controller: logic.addressController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Address',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Address',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
              ),
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                controller: logic.pinController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Pincode',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Your Pincode',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter pincode";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );

  Widget _identityDetails(
          MembershipMemberViewController logic, BuildContext context) =>
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              readOnly: true,
              lablecolor: theme.textTheme.bodyLarge!.color,
              onlyCamera: true,
              // disableGallery: true,
              // defaultPadding: true,
              // readOnly: logic.isUpdate,
              onTap: (str) {},
              showImage: logic.showAMImage,
              pickedFile: logic.pickedAMFile,
              buttonTextLabel:
                  logic.showAMImage ? "Change Photo" : "Upload Photo",
              labelText: 'Upload Photo',
            ),
            const SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              readOnly: true,
              lablecolor: theme.textTheme.bodyLarge!.color,
              onlyCamera: true,
              buttonTextLabel: "Upload Photo",
              onTap: (str) {},
              pickedFile: logic.pickedIdFile,
              showImage: logic.showIdImage,
              labelText: 'Upload College ID (Front)',
            ),
            const SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              readOnly: true,
              lablecolor: theme.textTheme.bodyLarge!.color,
              onlyCamera: true,
              buttonTextLabel: "Upload Photo",
              onTap: (str) {},
              pickedFile: logic.pickedIdFile,
              showImage: logic.showIdImage,
              labelText: 'Upload College ID (Back)',
            ),
            const SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              lablecolor: theme.textTheme.bodyLarge!.color,
              readOnly: true,
              // titleText: 'Document',
              // defaultPadding: true,
              onlyCamera: true,
              buttonTextLabel: "Upload Photo",
              onTap: (str) {},
              pickedFile: logic.pickedDocumentBack,
              showImage: logic.showDocumentBack,
              labelText: 'Upload Aadhaar Card Photo (Front)',
            ),
            const SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              lablecolor: theme.textTheme.bodyLarge!.color,
              readOnly: true,
              // titleText: 'Document',
              // defaultPadding: true,
              onlyCamera: true,
              buttonTextLabel: "Upload Photo",
              onTap: (str) {},
              pickedFile: logic.pickedDocumentBack,
              showImage: logic.showDocumentBack,
              labelText: 'Upload Aadhaar Card Photo (Back)',
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );

  Widget _consistencyDetails(MembershipMemberViewController logic) =>
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFieldWithLabelNSUI(
              readOnly: true,
              labelcolor: theme.textTheme.bodyLarge!.color,
              label: "State",
              hintText: "State",
              keyBoardType: TextInputType.name,
              controller: logic.stateController,
            ),
            TextFieldWithLabelNSUI(
              readOnly: true,
              labelcolor: theme.textTheme.bodyLarge!.color,
              label: "District",
              hintText: "District",
              keyBoardType: TextInputType.name,
              controller: logic.districtController,
            ),
            TextFieldWithLabelNSUI(
              readOnly: true,
              labelcolor: theme.textTheme.bodyLarge!.color,
              label: "College/University",
              hintText: "College/University",
              keyBoardType: TextInputType.name,
              controller: logic.universityController,
            ),
            // TextFieldWithLabelNSUI(
            //   readOnly: true,
            //   labelcolor: theme.textTheme.bodyLarge!.color,
            //   label: "College",
            //   hintText: "College",
            //   keyBoardType: TextInputType.name,
            //   controller: logic.collegeController,
            // ),
          ],
        ),
      );

  Widget _candidateDetails(MembershipMemberViewController logic,BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextFieldWithLabelNSUI(
            maxline: 2,
            readOnly: true,
            labelcolor: theme.textTheme.bodyLarge!.color,
            label: "University/College President Candidate",
            hintText: "University/College President Candidate",
            keyBoardType: TextInputType.name,
            controller: logic.assemblyCandidateController,
          ),
          // TextFieldWithLabelNSUI(
          //   maxline: 2,
          //   readOnly: true,
          //   labelcolor: theme.textTheme.bodyLarge!.color,
          //   label: "State President Candidate",
          //   hintText: "State President Candidate",
          //   keyBoardType: TextInputType.name,
          //   controller: logic.statePresidentController,
          // ),
          // TextFieldWithLabelNSUI(
          //   maxline: 2,
          //   readOnly: true,
          //   labelcolor: theme.textTheme.bodyLarge!.color,
          //   label: "State General Secretary Candidate",
          //   hintText: "State General Secretary Candidate",
          //   keyBoardType: TextInputType.name,
          //   controller: logic.stateSGSPresidentController,
          // ),
          // TextFieldWithLabelNSUI(
          //   readOnly: true,
          //   maxline: 2,
          //   labelcolor: theme.textTheme.bodyLarge!.color,
          //   label: "District President Candidate",
          //   hintText: "District President Candidate",
          //   keyBoardType: TextInputType.name,
          //   controller: logic.districtPresidentController,
          // ),
          // TextFieldWithLabelNSUI(
          //   readOnly: true,
          //   maxline: 2,
          //   labelcolor: theme.textTheme.bodyLarge!.color,
          //   label: "University President Candidate",
          //   hintText: "University President Candidate",
          //   keyBoardType: TextInputType.name,
          //   controller: logic.universityPresidentController,
          // ),
          // TextFieldWithLabelNSUI(
          //   readOnly: true,
          //   maxline: 2,
          //   labelcolor: theme.textTheme.bodyLarge!.color,
          //   label: "College President Candidate",
          //   hintText: "College President Candidate",
          //   keyBoardType: TextInputType.name,
          //   controller: logic.universityPresidentController,
          // ),
          const SizedBox(
            height: 10,
          ),
          Container(
              // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Checkbox(
                      value: logic.declarationStatus,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        // logic.changeDeclarationStatus(value!);
                      },
                    ),
                    Container(
                      width: MediaQuery.of(Get.context!).size.width * 0.8,
                      child: Text(
                        'I’m under 27 years of age and I accept the terms and conditions of NSUI',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ),
                  ],
                )
              ])),
          if (logic.otpSent && !logic.otpVerified)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Pinput(
                length: 6,
                // focusNode: model.otpCodeFocus,
                controller: logic.otpCodeController,
                defaultPinTheme: defaultPinTheme,
                followingPinTheme: defaultPinTheme,
                submittedPinTheme: defaultPinTheme,
                pinAnimationType: PinAnimationType.fade,
              ),
            ),
          if (logic.isEnableCSNverify) ...[
            if (!logic.otpVerified)
              SizedBox(
                height: 90,
                child: URoundButton(
                  color: Color(0xFF1356BF),
                    title: logic.otpSent ? "Verify" : "Get OTP To Verify CSN",
                    onTap: () {
                      logic.otpSent
                          ? logic.onClickValidateOtp(context)
                          : logic.onClickSendOtp(context);
                    }),
              )
          ]
        ],
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
