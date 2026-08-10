import 'package:iyc/nusi/widgets/dropdown_picker_nsui.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
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
      backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Basic Information",
              style: TextStyle(
                  color: ScrutinyTheme.brand,
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          iconTheme: const IconThemeData(color: ScrutinyTheme.brand),
          centerTitle: true,
        ),
        body: Consumer<ScrutinyBasicInfoVM>(
            builder: (_, model, __) => SingleChildScrollView(
                  child: Form(
                    key: model.firstFormKey,
                    child: Column(
                      children: [
                        TextFieldWithLabelNSUI(
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
                        TextFieldWithLabelNSUI(
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
                        TextFieldWithLabelNSUI(
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
                        TextFieldWithLabelNSUI(
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
