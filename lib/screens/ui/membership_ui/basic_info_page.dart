import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/membership/basic_info_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

class BasicInfoPage extends StatelessWidget {
  BasicInfoPage({Key? key, this.memberId}) : super(key: key);

  final String? memberId;
  // final GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    context.read<BasicInfoVM>().checkPrefillData(context);
    return Scaffold(
      bottomNavigationBar:
      // isKeyboardVisible
      //     ? SizedBox.shrink()
      //     :
      URoundButton(
        height: 70,
          title: "Next",
          onTap: () {
            context.read<MembershipVM>().oneNext(0, context);
          }),
      body: Consumer<BasicInfoVM>(
          builder: (_, model, __) => SingleChildScrollView(
            child: Form(
              key: model.firstFormKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Basic Information",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                  TextFieldWithLabel(
                    label: "First Name",
                    hintText: "First Name",
                    focusNode: model.usernameFocus,
                    nextFocus: model.lastNameFocus,
                    readOnly: model.disableFields,
                    keyBoardType: TextInputType.name,
                    controller: model.usernameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return 'Enter A Valid Name';
                      }
                      return null;
                    },
                  ),
                  TextFieldWithLabel(
                    label: "Last Name",
                    hintText: "Last Name",
                    focusNode: model.lastNameFocus,
                    nextFocus: model.professionFocus,
                    readOnly: model.disableFields,
                    keyBoardType: TextInputType.name,
                    controller: model.lastNameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return 'Enter A Valid Name';
                      }
                      return null;
                    },
                  ),
                  if (!context.read<MembershipVM>().isLegalCellReg)
                    TextFieldWithLabel(
                      label: "Your Profession",
                      hintText: "Your Profession",
                      readOnly: model.disableFields,
                      focusNode: model.professionFocus,
                      nextFocus: model.fatherNameFocus,
                      keyBoardType: TextInputType.name,
                      controller: model.professionController,
                      validation: (value) {
                        if (value.isEmpty) {
                          return 'Enter A Valid Profession';
                        }
                        return null;
                      },
                    ),
                  TextFieldWithLabel(
                    label: "Father/Husband Name",
                    hintText: "Father/Husband Name",
                    readOnly: model.disableFields,
                    focusNode: model.fatherNameFocus,
                    keyBoardType: TextInputType.name,
                    controller: model.fatherNameController,
                    validation: (value) {
                      if (value.isEmpty) {
                        return 'Enter A Valid Name';
                      }
                      return null;
                    },
                  ),

                  // URoundButton(
                  //   title: "Next",
                  //   onTap: () {
                  //     final isValid =
                  //     model.personalFirstFormKey.currentState!.validate();
                  //     if (!isValid) {
                  //       return;
                  //     }
                  //     model.personalFirstFormKey.currentState!.save();
                  //     onNext();}
                  //   //=> toPage(context, Home()),
                  // ),
                ],
              ),
            ),
          )),
    );
    //   KeyboardVisibilityBuilder(
    //   builder: (context, isKeyboardVisible) => SafeArea(
    //     child: Scaffold(
    //       bottomNavigationBar:
    //       isKeyboardVisible
    //           ? SizedBox.shrink()
    //           :
    //       URoundButton(
    //               title: "Next",
    //               onTap: () {
    //                 context.read<MembershipVM>().oneNext(0, context);
    //               }),
    //       body: Consumer<BasicInfoVM>(
    //           builder: (_, model, __) => SingleChildScrollView(
    //                 child: Form(
    //                   key: model.firstFormKey,
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                         padding: EdgeInsets.only(left: 20, top: 10),
    //                         alignment: Alignment.centerLeft,
    //                         child: Text(
    //                           "Basic Information",
    //                           style: GoogleFonts.poppins(
    //                             textStyle: TextStyle(
    //                                 color: Colors.black, fontSize: 14),
    //                           ),
    //                         ),
    //                       ),
    //                       TextFieldWithLabel(
    //                         label: "First Name",
    //                         hintText: "First Name",
    //                         focusNode: model.usernameFocus,
    //                         nextFocus: model.lastNameFocus,
    //                         readOnly: model.disableFields,
    //                         keyBoardType: TextInputType.name,
    //                         controller: model.usernameController,
    //                         validation: (value) {
    //                           if (value.isEmpty) {
    //                             return 'Enter A Valid Name';
    //                           }
    //                           return null;
    //                         },
    //                       ),
    //                       TextFieldWithLabel(
    //                         label: "Last Name",
    //                         hintText: "Last Name",
    //                         focusNode: model.lastNameFocus,
    //                         nextFocus: model.professionFocus,
    //                         readOnly: model.disableFields,
    //                         keyBoardType: TextInputType.name,
    //                         controller: model.lastNameController,
    //                         validation: (value) {
    //                           if (value.isEmpty) {
    //                             return 'Enter A Valid Name';
    //                           }
    //                           return null;
    //                         },
    //                       ),
    //                       if (!context.read<MembershipVM>().isLegalCellReg)
    //                         TextFieldWithLabel(
    //                           label: "Your Profession",
    //                           hintText: "Your Profession",
    //                           readOnly: model.disableFields,
    //                           focusNode: model.professionFocus,
    //                           nextFocus: model.fatherNameFocus,
    //                           keyBoardType: TextInputType.name,
    //                           controller: model.professionController,
    //                           validation: (value) {
    //                             if (value.isEmpty) {
    //                               return 'Enter A Valid Profession';
    //                             }
    //                             return null;
    //                           },
    //                         ),
    //                       TextFieldWithLabel(
    //                         label: "Father/Husband",
    //                         hintText: "Father/Husband",
    //                         readOnly: model.disableFields,
    //                         focusNode: model.fatherNameFocus,
    //                         keyBoardType: TextInputType.name,
    //                         controller: model.fatherNameController,
    //                         validation: (value) {
    //                           if (value.isEmpty) {
    //                             return 'Enter A Valid Name';
    //                           }
    //                           return null;
    //                         },
    //                       ),
    //
    //                       // URoundButton(
    //                       //   title: "Next",
    //                       //   onTap: () {
    //                       //     final isValid =
    //                       //     model.personalFirstFormKey.currentState!.validate();
    //                       //     if (!isValid) {
    //                       //       return;
    //                       //     }
    //                       //     model.personalFirstFormKey.currentState!.save();
    //                       //     onNext();}
    //                       //   //=> toPage(context, Home()),
    //                       // ),
    //                     ],
    //                   ),
    //                 ),
    //               )),
    //     ),
    //   ),
    // );
  }
}
