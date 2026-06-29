import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/district_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/state_picker_dropdown.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_constituency_info_vm.dart';
import 'package:provider/provider.dart';

class ScrutinyConstituencyInfoPage extends StatelessWidget {
  const ScrutinyConstituencyInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ScrutinyConstituencyInfoVM>().getStatesList();
    return Consumer<ScrutinyConstituencyInfoVM>(
        builder: (_, val, __) => SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Constituency Details",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontSize: 14),
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
                      viewOnly: !val.enableDistrictEdit && val.disableFields,
                      onChanged: (value) {
                        context
                            .read<ScrutinyConstituencyInfoVM>()
                            .changeSelectedDistrict(context
                                .read<ScrutinyConstituencyInfoVM>()
                                .districtList!
                                .singleWhere((element) =>
                                    element.districtCode == value));
                      }),
                  AssemblyPickerDropDown(
                      currentAssembly: val.selectedAssembly,
                      assemblyList: val.assemblyList,
                      viewOnly: !val.enableDistrictEdit && val.disableFields,
                      selectedAssembly: val.selectedAssemblyName ??
                          "Select Assembly Constituency/Block",
                      onChanged: (value) {
                        context
                            .read<ScrutinyConstituencyInfoVM>()
                            .changeSelectedAssembly(context
                                .read<ScrutinyConstituencyInfoVM>()
                                .assemblyList!
                                .singleWhere((element) =>
                                    element.assemblyCode == value));
                      }),
                  //  DropDownTextField(title: " ", label: "Booth"),
                ],
              ),
            ));
  }
}
