import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/nominations/nominations_main.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/membership/add_primary_member_vm.dart';
import 'package:provider/provider.dart';

class PrimaryMemberForm extends StatelessWidget {
  const PrimaryMemberForm({
    Key? key, required this.batchMember
  }) : super(key: key);
  final BatchMember batchMember;
  @override
  Widget build(BuildContext context) {
    return Consumer<AddPrimaryMemberVM>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Primary Member"),
          elevation: 0,
        ),
        body: Column(
          children: [
        TextFieldWithLabel(
          label: "First Name",
          hintText: "First Name",
          // focusNode: model.usernameFocus,
          // nextFocus: model.lastNameFocus,

          // readOnly: model.disableFields,
          keyBoardType: TextInputType.name,
          controller: model.firstNameController,
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
          keyBoardType: TextInputType.name,
          controller: model.lastNameController,
          validation: (value) {
            if (value.isEmpty) {
              return 'Enter A Valid Name';
            }
            return null;
          },
        ),
        TextFieldWithLabel(
          label: "Mobile Number",
          hintText: "Mobile Number",
          keyBoardType: TextInputType.phone,
          controller: model.mobileController,
          maxLength: 10,
          validation: (value) {
            if (value.isEmpty) {
              return 'Enter A Valid Mobile Number';
            }
            if (['9', '8', '7', '6'].contains(value[0])) {
              return 'Enter A Valid Mobile Number';
            }
            return null;
          },
        ),
        TextFieldWithLabel(
          label: "Id Card Number",
          hintText: "Id Card",
          keyBoardType: TextInputType.name,
          controller: model.idCardController,
          validation: (value) {
            if (value.isEmpty) {
              return 'Enter A Valid Id';
            }
            return null;
          },
        ),
        Spacer(),
        SizedBox(
          height: 80,
          child: URoundButton(
              title: "Add Member",
              onTap: () {
                model.validatePrimaryMemberFormAndAdd(context,batchMember);
                Navigator.pop(context);
              }),
        )
          ],
        ),
      );
    });
  }
}
