import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/membership_ui/bottom_page_switcher.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/view_model/membership/add_primary_member_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

class AddPrimaryMembers extends StatefulWidget {
  const AddPrimaryMembers({Key? key, required this.batchMember, required this.isUpdate})
      : super(key: key);

  final BatchMember batchMember;
  final bool isUpdate;

  @override
  _AddPrimaryMembersState createState() => _AddPrimaryMembersState();
}

class _AddPrimaryMembersState extends State<AddPrimaryMembers> {
  @override
  void initState() {
    print("Is update is ${widget.isUpdate}");
    context.read<AddPrimaryMemberVM>().init(widget.batchMember);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPrimaryMemberVM>(
        builder: (_, model, __) => model.showAddMemberPage
            ? SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("Primary Member"),
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () {
                          model.onChangedShowMemberPage();
                        },
                        icon: Icon(Icons.arrow_back)),
                  ),
                  body: ListView(
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
                      SizedBox(height: 20,),
                      SizedBox(
                        height: 80,
                        child: URoundButton(
                            title: "Add Member",
                            onTap: () {
                              model.validatePrimaryMemberFormAndAdd(
                                  context, widget.batchMember);
                              model.onChangedShowMemberPage();
                            }),
                      )
                    ],
                  ),
                ),
            )
            : SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Add Primary Members",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: SizedBox(),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  floatingActionButton: model.primaryMemberList.length >= 5
                      ? SizedBox()
                      : FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            context
                                .read<AddPrimaryMemberVM>()
                                .onChangedShowMemberPage();
                          },
                        ),
                  bottomNavigationBar: BottomPageSwitcher(
                    titleNext: "Submit",
                    actionNext: () {
                      if(model.primaryMemberList.length<5){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Add five primary members")));
                      }else{
                        model.submit(widget.isUpdate);
                        context.read<MembershipVM>().onSubmit(context, widget.isUpdate);
                      }
                    },
                    actionPrev: () {
                      context.read<MembershipVM>().activeStepPrevious();
                    },
                  ),
                  body: SingleChildScrollView(
                      child: model.loadingPage
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: List.generate(
                                  model.primaryMemberList.length,
                                  (index) => ListTile(
                                        title: Text(
                                            '${model.primaryMemberList[index].firstName}'),
                                        subtitle: Text(
                                            '${model.primaryMemberList[index].mobile}'),
                                      )),
                            )
                      // model.loadingPage
                      //     ? Center(
                      //         child: CircularProgressIndicator(),
                      //       )
                      //     :
                      // Column(
                      //         children: [
                      //           ...List.generate(
                      //               5,
                      //               (index) => PrimaryMemberForm(
                      //                   memberIndex: index+1,
                      //                   lastNameController:
                      //                       model.lastNameControllerList[index],
                      //                   firstNameController:
                      //                       model.firstNameControllerList[index],
                      //                   mobileController: model.mobileControllerList[index],
                      //                   idCardController:
                      //                       model.idCardControllerList[index])),
                      //           URoundButton(
                      //               title: "Submit",
                      //               onTap: () {
                      //                 context.read<AddPrimaryMemberVM>().submit();
                      //               })
                      //         ],
                      //       ),
                      ),
                ),
            ));
  }
}
