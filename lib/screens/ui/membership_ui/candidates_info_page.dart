import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/ui/membership/widgets/state_candidate_dropdown.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/view_model/membership/candidates_info_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

import 'bottom_page_switcher.dart';

class CandidatesInfoPage extends StatefulWidget {
  final bool isUpdate;

  const CandidatesInfoPage({Key? key, this.isUpdate = false}) : super(key: key);

  @override
  State<CandidatesInfoPage> createState() => _CandidatesInfoPageState();
}

class _CandidatesInfoPageState extends State<CandidatesInfoPage> {
  @override
  void initState() {
    context.read<CandidatesInfoVM>().initialize(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CandidatesInfoVM>(
      builder: (_, model, __) => Scaffold(
        bottomNavigationBar: BottomPageSwitcher(
          titleNext: 'Submit',//['U1','U2', 'U3'].contains(model.membershipId!.substring(0,2))?'Submit':"Next",
          actionNext: () {
            // context.read<MembershipVM>().oneNext(6, context);
            context.read<MembershipVM>().onSubmit(context, widget.isUpdate);
            // if (['U1','U2', 'U3'].contains(model.membershipId!.substring(0,2))){
            //   context.read<MembershipVM>().oneNext(6, context);
            // }else{
            //   context.read<MembershipVM>().onSubmit(context, widget.isUpdate);
            // }
          },

          actionPrev: () {
            context.read<MembershipVM>().activeStepPrevious();
          },
        ),
        body: SafeArea(
          child: Consumer<CandidatesInfoVM>(
              builder: (_, model, __) => model.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Candidate section",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          StateNominationPickerWidget(
                            onChanged: (val) {
                              model.changeStateNomination(val);
                            },
                            listValues: model.statePresidentNominationsList,
                            labelText: "State President Candidate",
                            currentValue: model.selectedStatePresidentNominations,
                            defaultValue: "Select State President Nomination",
                          ),
                          StateNominationPickerWidget(
                            onChanged: (val) {
                              model.changeStateGSNomination(val);
                            },
                            listValues:
                                model.stateGeneralSecretaryNominationsList,
                            labelText: "State General Secretary Candidate",
                            currentValue: model.selectedStateGSNominations,
                            defaultValue:
                                "Select State General Secretary Nomination",
                          ),
                          StateNominationPickerWidget(
                            onChanged: (val) {
                              model.changeDistrictNomination(val);
                            },
                            listValues: model.districtNominationsList,
                            labelText: "District President Candidate",
                            currentValue: model.selectedDistrictNominations,
                            defaultValue: "Select District President Nomination",
                          ),
                          StateNominationPickerWidget(
                              onChanged: (val) {
                                model.changeDistrictGsNomination(val);
                              },
                              listValues: model.districtGsNominationsList,
                              labelText: "District GS Candidate",
                              currentValue: model.selectedDistrictGsNominations,
                              defaultValue: "Select District GS Nomination",
                            ),
                          AppConstants.blockStatesList.contains(model.selectedState?.stateCode)
                              ? Column(
                                  children: [
                                    StateNominationPickerWidget(
                                      onChanged: (val) {
                                        model.changeBlockNomination(val);
                                      },
                                      listValues: model.blockNominationsList,
                                      labelText: "Block Candidate",
                                      currentValue:
                                          model.selectedBlockNominations,
                                      defaultValue: "Select Block Nomination",
                                    ),
                                    StateNominationPickerWidget(
                                      onChanged: (val) {
                                        model.changeBoothNomination(val);
                                      },
                                      listValues: model.boothNominationsList,
                                      labelText: "Booth Candidate",
                                      currentValue:
                                          model.selectedBoothNominations,
                                      defaultValue: "Select Booth Nomination",
                                    ),
                                  ],
                                )
                              : StateNominationPickerWidget(
                                  onChanged: (val) {
                                    model.changeAssemblyNomination(val);
                                  },
                                  listValues: model.assemblyNominationsList,
                                  labelText: "Assembly/Block/Ward Candidate",
                                  currentValue: model.selectedAssemblyNominations,
                                  defaultValue:
                                      "Select Assembly/Block/Ward Nomination",
                                ),
                          if (["KL", "TL", "KA", "DL", "HP", "HR" ,"TN","MB","TS","MP","GJ"].contains(model.selectedState?.stateCode))
                            StateNominationPickerWidget(
                              onChanged: (val) {
                                model.changeMandalamNomination(val);
                              },
                              listValues: model.mandalamNominationsList,
                              labelText: "Mandalam/Block Candidate",
                              currentValue: model.selectedMandalamNominations,
                              defaultValue: "Select Mandalam/Block Nomination",
                            ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Declaration',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: model.declarationStatus,
                                          onChanged: (value) {
                                            model.changeDeclarationStatus(value!);
                                          },
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.7,
                                          child: Text(
                                            'I Am Under 35 years Of Age And I Accept Terms And Conditions Of Indian Youth Congress',
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    )
                                  ])),
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}
