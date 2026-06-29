import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_contact_info_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class ScrutinyContactDetails extends StatelessWidget {
  const ScrutinyContactDetails({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Contact Information", style: Constants.appbarTitleTextStyle),
        backgroundColor: Constants.themeGradients[0],
        centerTitle: true,
      ),
      body: Consumer<ScrutinyContactInfoVM>(
          builder: (_, model, __) => SingleChildScrollView(
                  child: Form(
                key: model.thirdFormKey,
                child: Column(
                  children: [
                    Form(
                      key: model.mobileFormKey,
                      child: Column(children: [
                        TextFieldWithLabel(
                          label: "Mobile No.",
                          hintText: "Mobile No.",
                          readOnly: model.disabledContactEditing,
                          maxLength: 10,
                          focusNode: model.mobileFocus,
                          nextFocus: model.verificationCodeFocus,
                          keyBoardType: TextInputType.number,
                          controller: model.mobileController,
                          validation: (value) {
                            if (value.isEmpty || value.length != 10) {
                              return 'Enter A Valid Mobile No';
                            }
                            return null;
                          },
                        ),
                      ]),
                    ),
                    if (!model.disabledContactEditing)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 150,
                          height: 80,
                          child: URoundButton(
                              title: "Get OTP",
                              onTap: () async {
                                final isValid = model
                                    .mobileFormKey.currentState!
                                    .validate();
                                if (!isValid) {
                                  return;
                                }
                                model.mobileFormKey.currentState!.save();
                                model.verificationCodeController.clear();
                                model.getOtp(context);
                              }),
                        ),
                      ),
                    // if (model.otpSend && !model.otpVerified)
                    //   Container(
                    //     margin:
                    //         EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    //     child: Pinput(
                    //       length: 6,
                    //       focusNode: model.otpCodeFocus,
                    //       controller: model.verificationCodeController,
                    //       defaultPinTheme: defaultPinTheme,
                    //       followingPinTheme: defaultPinTheme,
                    //       submittedPinTheme: defaultPinTheme,
                    //       pinAnimationType: PinAnimationType.fade,
                    //     ),
                    //   ),
                    if (model.enableOtp && model.otpSend && !model.otpVerified)
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Pinput(
                          length: 6,
                          focusNode: model.verificationCodeFocus,
                          controller: model.verificationCodeController,
                          defaultPinTheme: defaultPinTheme,
                          followingPinTheme: defaultPinTheme,
                          submittedPinTheme: defaultPinTheme,
                          pinAnimationType: PinAnimationType.fade,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          validator: (str) {
                            if (str != null && str.length == 6)
                              return null;
                            else
                              return "Kindly enter Otp";
                          },
                        ),
                      ),
                    // TextFieldWithLabel(
                    //   label: "Verification Code",
                    //   hintText: "Verification Code",
                    //
                    //   keyBoardType: TextInputType.number,
                    //   focusNode: model.verificationCodeFocus,
                    //   nextFocus: model.emailFocus,
                    //   controller: model.verificationCodeController,
                    //   validation: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Enter A Valid Verification Code';
                    //     }
                    //     return null;
                    //   },
                    // ),

                    TextFieldWithLabel(
                        label: "Email Id",
                        hintText: "Email Id",
                        focusNode: model.emailFocus,
                        nextFocus: model.addressFocus,
                        readOnly: model.disableFields,
                        keyBoardType: TextInputType.emailAddress,
                        controller: model.emailController,
                        onSubmit: () {
                          model.changeEditStatus();
                        },
                        validation: (value) {
                          return null;
                          // if (value != null) {
                          //   if (value.length > 5 && value.contains('@')) {
                          //     return null;
                          //   }
                          //   return 'Enter a Valid Email Address';
                          // }
                        }),
                    TextFieldWithLabel(
                      label: "Address",
                      hintText: "Address",
                      readOnly: model.disableFields,
                      focusNode: model.addressFocus,
                      nextFocus: model.pinFocus,
                      keyBoardType: TextInputType.name,
                      controller: model.addressController,
                    ),
                    // TextFieldWithLabel(
                    //   label: "Pin",
                    //   hintText: "Pin",
                    //   readOnly: model.disableFields,
                    //   focusNode: model.pinFocus,
                    //   maxLength: 6,
                    //   inputAction: TextInputAction.done,
                    //   keyBoardType: TextInputType.number,
                    //   controller: model.pinController,
                    //   validation: (value) {
                    //     // if (value.isEmpty) {
                    //     //   return 'Enter A Valid Pin';
                    //     // }
                    //     return null;
                    //   },
                    // ),
                  ],
                ),
              ))),
    );
  }
}
