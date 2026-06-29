import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/screens/ui/members/inc/select_inc_nomination.dart';
import 'package:iyc/screens/ui/membership_ui/bottom_page_switcher.dart';
import 'package:iyc/screens/widgets/u_round_edge_container.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/members/search_inc_member_vm.dart';
import 'package:iyc/view_model/members/select_inc_monination_vm.dart';
import 'package:provider/provider.dart';

import 'label_with_text_widget.dart';

class SearchIncMembers extends StatefulWidget {
  const SearchIncMembers({Key? key, required this.batchId}) : super(key: key);

  final String batchId;

  @override
  _SearchIncMembersState createState() => _SearchIncMembersState();
}

class _SearchIncMembersState extends State<SearchIncMembers> {
  late TextEditingController idController;
  @override
  void initState() {
    idController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enroll INC Member"),
        bottom: PreferredSize(
          preferredSize: Size(0.0, 85.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Constants.themeGradients[1],
            padding: EdgeInsets.only(
              top: 3,
            ),
            child: Row(children: [
              URoundEdgeContainer(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    controller: idController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (str) {
                      context
                          .read<SearchIncMemberVM>()
                          .searchMember(context, str, widget.batchId);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Constants.kitThemeGradients[0],
                        ),
                        hintText: "Search eg: INC10001"),
                  )),
              // IconButton(
              //   onPressed: () {},
              //   icon: Image.asset(
              //     "assets/icons/reload.svg",
              //     color: Constants.themeGradients[0],
              //   ),
              // )
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Consumer<SearchIncMemberVM>(
        builder: (_, incVM, __) => incVM.showINCMember
            ? BottomPageSwitcher(
                titleNext: "Accept",
                titlePrev: "Reject",
                actionNext: () => toPage(
                    context,
                    ChangeNotifierProvider(
                      create: (context) => SelectIncNominationVM(),
                      child: SelectIncNomination(
                        incMember: incVM.incMember,
                      ),
                    )),
                actionPrev: () => {},
              )
            : SizedBox.shrink(),
      ),
      body: Consumer<SearchIncMemberVM>(
        builder: (_, incVM, __) => incVM.loadingPage
            ? Center(child: CircularProgressIndicator())
            : incVM.showINCMember
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        LabelWithTextWidget(
                          label: "First Name",
                          text: incVM.incMember.firstName!,
                        ),
                        LabelWithTextWidget(
                          label: "Last Name",
                          text: incVM.incMember.lastName!,
                        ),
                        LabelWithTextWidget(
                          label: "Mobile",
                          text: incVM.incMember.mobile!,
                        ),
                        LabelWithTextWidget(
                          label: "Gender",
                          text: incVM.incMember.gender == "M"
                              ? "Male"
                              : incVM.incMember.gender == "F"
                                  ? "Female"
                                  : "Others",
                        ),
                        LabelWithTextWidget(
                          label: "Date Of Birth",
                          text: incVM.incMember.dob!,
                        ),
                        LabelWithTextWidget(
                          label: "Category",
                          text: incVM.categoryList
                              .firstWhere((element) =>
                                  element.categoryCode ==
                                  incVM.incMember.category)
                              .name,
                        ),
                        LabelWithTextWidget(
                          label: "State",
                          text: incVM.stateList
                              .firstWhere((element) =>
                                  element.stateCode ==
                                  incVM.incMember.stateCode)
                              .name,
                        ),
                        LabelWithTextWidget(
                          label: "District",
                          text: incVM.districtList
                              .firstWhere((element) =>
                                  element.districtCode ==
                                  incVM.incMember.districtCode)
                              .name,
                        ),
                        LabelWithTextWidget(
                          label: "Assembly",
                          text: incVM.assemblyList.any((element) =>
                                  element.assemblyCode ==
                                  incVM.incMember.assemblyCode)
                              ? incVM.assemblyList
                                  .firstWhere((element) =>
                                      element.assemblyCode ==
                                      incVM.incMember.assemblyCode)
                                  .name
                              : "No Assembly available",
                        ),
                        LabelWithTextWidget(
                          label: "Id",
                          text: incVM.incMember.tmpId!,
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  )
                : Center(
                    child: Text("no member found"),
                  ),
      ),
    );
  }
}
