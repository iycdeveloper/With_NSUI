import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_basic_info_vm.dart';
import 'package:provider/provider.dart';

class ScrutinyBasicInfo extends StatefulWidget {
  ScrutinyBasicInfo({Key? key, this.memberId}) : super(key: key);

  final String? memberId;

  @override
  State<ScrutinyBasicInfo> createState() => _ScrutinyBasicInfoState();
}

class _ScrutinyBasicInfoState extends State<ScrutinyBasicInfo> {

  @override
  void initState() {
    context.read<ScrutinyBasicInfoVM>().checkPrefillData(context);
    super.initState();
  }

  // final GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Basic Information", style: Constants.appbarTitleTextStyle),
          backgroundColor: Constants.themeGradients[0],
          centerTitle: true,
        ),
        body: Consumer<ScrutinyBasicInfoVM>(
            builder: (_, model, __) => SingleChildScrollView(
                  child: Form(
                    key: model.firstFormKey,
                    child: Column(
                      children: [
                        TextFieldWithLabel(
                          label: "First Name",
                          hintText: "First Name",
                          focusNode: model.usernameFocus,
                          nextFocus: model.lastNameFocus,
                          readOnly: !model.enableNameEdit,
                          keyBoardType: TextInputType.name,
                          controller: model.usernameController,
                          validation: (value) {
                            // if (value.isEmpty) {
                            //   return 'Enter A Valid Name';
                            // }
                            return null;
                          },
                        ),
                        TextFieldWithLabel(
                          label: "Last Name",
                          hintText: "Last Name",
                          focusNode: model.lastNameFocus,
                          nextFocus: model.professionFocus,
                          readOnly: !model.enableNameEdit,
                          keyBoardType: TextInputType.name,
                          controller: model.lastNameController,
                          validation: (value) {
                            // if (value.isEmpty) {
                            //   return 'Enter A Valid Name';
                            // }
                            return null;
                          },
                        ),
                        TextFieldWithLabel(
                          label: "Your Profession",
                          hintText: "Your Profession",
                          readOnly: model.disableFields,
                          focusNode: model.professionFocus,
                          nextFocus: model.fatherNameFocus,
                          keyBoardType: TextInputType.name,
                          controller: model.professionController,
                          validation: (value) {
                            // if (value.isEmpty) {
                            //   return 'Enter A Valid Profession';
                            // }
                            return null;
                          },
                        ),
                        TextFieldWithLabel(
                          label: "Relative Name",
                          hintText: "Relative Name",
                          readOnly: !model.enableRelationEdit,
                          focusNode: model.fatherNameFocus,
                          keyBoardType: TextInputType.name,
                          controller: model.fatherNameController,
                          validation: (value) {
                            // if (value.isEmpty) {
                            //   return 'Enter A Valid Name';
                            // }
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
      ),
    );
  }
}
