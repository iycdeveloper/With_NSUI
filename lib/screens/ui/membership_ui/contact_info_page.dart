import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/membership/contact_info_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import 'bottom_page_switcher.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ContactInfoVM>().init(context);

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
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: isKeyboardVisible
              ? SizedBox.shrink()
              : BottomPageSwitcher(
                  actionNext: () {
                    context.read<MembershipVM>().oneNext(2, context);
                  },
                  actionPrev: () {
                    context.read<MembershipVM>().activeStepPrevious();
                  },
                ),
          body: Consumer<ContactInfoVM>(
              builder: (_, model, __) => GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                        child: Form(
                      key: model.thirdFormKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Contact Details",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          Form(
                            key: model.mobileFormKey,
                            child: Column(children: [
                              TextFieldWithLabel(
                                label: "Mobile No.",
                                hintText: "Mobile No.",
                                readOnly: model.disableFields,

                                maxLength: 10,
                                focusNode: model.mobileFocus,
                                // nextFocus: model.verificationCodeFocus,
                                keyBoardType: TextInputType.number,
                                controller: model.mobileController,
                                onSubmit: () {},
                                validation: (value) {
                                  if (value.isEmpty || value.length != 10) {
                                    return 'Enter A Valid Mobile No';
                                  }
                                  return null;
                                },
                              ),
                            ]),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 150,
                              height: 70,
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
                          if (model.otpSend && !model.otpVerified)
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Pinput(
                                length: 6,
                                focusNode: model.otpCodeFocus,
                                controller: model.verificationCodeController,
                                defaultPinTheme: defaultPinTheme,
                                followingPinTheme: defaultPinTheme,
                                submittedPinTheme: defaultPinTheme,
                                pinAnimationType: PinAnimationType.fade,
                              ),
                            ),
                          TextFieldWithLabel(
                            label: "Email Id",
                            hintText: "Email Id",
                            focusNode: model.emailFocus,
                            nextFocus: model.addressFocus,
                            keyBoardType: TextInputType.emailAddress,
                            controller: model.emailController,
                            onSubmit: () {
                              model.changeEditStatus();
                            },
                            validation: (input) => input.isValidEmail()
                                ? null
                                : "Enter a Valid Email Address",
                          ),
                          TextFieldWithLabel(
                            label: "Address",
                            hintText: "Address",
                            readOnly: model.disableFields,
                            focusNode: model.addressFocus,
                            nextFocus: model.pinCodeFocus,
                            keyBoardType: TextInputType.name,
                            controller: model.addressController,
                          ),
                          TextFieldWithLabel(
                            label: "Pin",
                            hintText: "Pin",
                            readOnly: model.disableFields,
                            focusNode: model.pinCodeFocus,
                            maxLength: 6,
                            inputAction: TextInputAction.done,
                            keyBoardType: TextInputType.number,
                            controller: model.pinController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Pin';
                              }
                              return null;
                            },
                          ),

                          // URoundButton(
                          //     title: "Next", onTap: () { context.read<MembershipVM>().oneNext( 2, context);
                          // })
                        ],
                      ),
                    )),
                  )),
        ),
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
