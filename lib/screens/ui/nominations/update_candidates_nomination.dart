import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/model/data_model/nomination_member.dart';
import 'package:iyc/screens/ui/membership/widgets/state_candidate_dropdown.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/nomination/update_candidate_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class UpdateCandidateNomination extends StatefulWidget {
  const UpdateCandidateNomination({Key? key, required this.nominationMember})
      : super(key: key);
  final NominationMember nominationMember;

  @override
  State<UpdateCandidateNomination> createState() =>
      _UpdateCandidateNominationState();
}

class _UpdateCandidateNominationState extends State<UpdateCandidateNomination> {
  @override
  void initState() {
    context
        .read<UpdateCandidateVM>()
        .initialize(context, widget.nominationMember);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vote Candidate',
        ),
        centerTitle: true,
        backgroundColor: Constants.themeGradients[0],
        elevation: 0,
      ),
      bottomNavigationBar: URoundButton(
        title: "Update",
        onTap: () async {
          context.read<UpdateCandidateVM>().submit(context);
        },
      ),
      body: SafeArea(
        child: Consumer<UpdateCandidateVM>(
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
                          listValues: model.districtPresidentNominationsList,
                          labelText: "District President Candidate",
                          currentValue:
                              model.selectedDistrictPresidentNominations,
                          defaultValue: "Select District Nomination",
                        ),
                        // StateNominationPickerWidget(
                        //   onChanged: (val) {
                        //     model.changeDistrictGsNomination(val);
                        //   },
                        //   listValues: model.districtGsNominationsList,
                        //   labelText: "District GS Candidate",
                        //   currentValue: model.selectedDistrictGSNominations,
                        //   defaultValue: "Select District GS Nomination",
                        // ),
                        // StateNominationPickerWidget(
                        //   onChanged: (val) {
                        //     model.changeAssemblyNomination(val);
                        //   },
                        //   listValues: model.assemblyNominationsList,
                        //   labelText: "Assembly Candidate",
                        //   currentValue: model.selectedAssemblyNominations,
                        //   defaultValue: "Select Assembly Nomination",
                        // ),
                        // if (["KL", "TL", "KA", "DL", "HP", "HR", "TN", "MB","MP","GJ","JH"]
                        //     .contains(model.currentNominationMember.stateCode))
                          // StateNominationPickerWidget(
                          //   onChanged: (val) {
                          //     model.changeMandalamNomination(val);
                          //   },
                          //   listValues: model.mandalamNominationsList,
                          //   labelText: "Mandalam/Block/Ward",
                          //   currentValue: model.selectedMandalamNominations,
                          //   defaultValue:
                          //       "Select Mandalam/Block/Ward Nominations",
                          // ),
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
                                      ), //Checkb
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
    );
  }
}
