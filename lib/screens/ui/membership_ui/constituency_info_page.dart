import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/district_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/dropdown/state_picker_dropdown.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/membership/constituency_info_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

import 'bottom_page_switcher.dart';

class ConstituencyInfoPage extends StatefulWidget {
  const ConstituencyInfoPage({Key? key}) : super(key: key);

  @override
  State<ConstituencyInfoPage> createState() => _ConstituencyInfoPageState();
}

class _ConstituencyInfoPageState extends State<ConstituencyInfoPage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ConstituencyInfoVM>().onInit(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            (context.read<MembershipVM>().currentMember!.isLegalCell)
                ? IycIconButton(
                    title: "Submit",
                    onTap: () {
                      if (context
                          .read<ConstituencyInfoVM>()
                          .validatePage(context)) {
                        context
                            .read<ConstituencyInfoVM>()
                            .populateIntoModel(context);
                        context.read<MembershipVM>().submitLegalCell(context);
                      }
                    })
                : BottomPageSwitcher(
                    actionNext: () {
                      context.read<MembershipVM>().oneNext(4, context);
                    },
                    actionPrev: () {
                      context.read<MembershipVM>().activeStepPrevious();
                    },
                  ),
        body: Consumer<ConstituencyInfoVM>(
            builder: (_, val, __) => SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Constituency Details",
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      StatePickerDropDown(
                        currentState: val.selectedState,
                        selectedState: val.selectedStateName,
                        stateList: val.stateList,
                        viewOnly: val.enableDistrictEdit,
                        onTap: () {
                          //  context.read<RegAssemblyProvider>().refresh();
                        },
                        // onChanged: (value) {
                        // context.read<RegAssemblyProvider>().changeSelectedState(
                        //     context
                        //         .read<RegAssemblyProvider>()
                        //         .stateList!
                        //         .singleWhere(
                        //             (element) => element.stateCode == value));
                        // },
                      ),
                      DistrictPickerDropDown(
                          currentDistrict: val.selectedDistrict,
                          districtList: val.districtList,
                          selectedConstituency: val.selectedDisName ??
                              "Select Parliamentary Constituency",
                          viewOnly:
                              !val.enableDistrictEdit && val.disableFields,
                          onChanged: (value) {
                            context
                                .read<ConstituencyInfoVM>()
                                .changeSelectedDistrict(context
                                    .read<ConstituencyInfoVM>()
                                    .districtList!
                                    .singleWhere((element) =>
                                        element.districtCode == value));
                          }),

                      val.isBlockModel
                          ? DropDownPicker(
                              currentValue: val.selectedBlock?.blockCode,
                              listValues: val.blockListDropDown,
                              onChanged: (value) {
                                context
                                    .read<ConstituencyInfoVM>()
                                    .changeBlock(value);
                              },
                              labelText: "Block",
                              hintText: "Select a Block",
                              selectedBuilder: val.blockListDropDown != null
                                  ? (context) => val.blockListDropDown!
                                      .map<Widget>((e) => Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  e.name,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList()
                                  : null,
                            )
                          : AssemblyPickerDropDown(
                              currentAssembly: val.selectedAssembly,
                              assemblyList: val.assemblyList,
                              viewOnly:
                                  !val.enableDistrictEdit && val.disableFields,
                              selectedAssembly: val.selectedAssemblyName ??
                                  "Select Assembly Constituency/Block",
                              onChanged: (value) {
                                context
                                    .read<ConstituencyInfoVM>()
                                    .changeSelectedAssembly(context
                                        .read<ConstituencyInfoVM>()
                                        .assemblyList!
                                        .singleWhere((element) =>
                                            element.assemblyCode == value));
                              }),

                      if (val.mandalamEnabled)
                        DropDownPicker(
                          currentValue: val.selectedMandalam,
                          listValues: val.mandalamListDropDown,
                          onChanged: (value) {
                            context
                                .read<ConstituencyInfoVM>()
                                .changeMandalam(value);
                          },
                          labelText: "Mandalam/Block",
                          hintText: "Select a Mandalam/Block",
                        ),

                      IndexedStack(
                        index: val.selectedBooth != null ? 0 : 1,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booth",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                                Container(
                                  decoration: Constants.formItemDecoration,
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      minWidth: double.infinity),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            " ${val.selectedBooth?.boothName ?? ""}"),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    onTap: context
                                        .read<ConstituencyInfoVM>()
                                        .openDropdown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropDownPicker(
                            currentValue: val.selectedBooth?.boothCode,
                            listValues: val.boothListDropDown,
                            refKey: context
                                .read<ConstituencyInfoVM>()
                                .dropdownButtonKey,
                            onChanged: (value) {
                              context
                                  .read<ConstituencyInfoVM>()
                                  .changeBooth(value);
                            },
                            labelText: "Booth",
                            hintText: "Select a Booth",
                          )
                        ],
                      ),

                      // URoundButton(
                      //     title: "Next", onTap: () { context.read<MembershipVM>().oneNext( 4, context);
                      // })
                      //  DropDownTextField(title: " ", label: "Booth"),
                    ],
                  ),
                )),
      ),
    );
  }
}
